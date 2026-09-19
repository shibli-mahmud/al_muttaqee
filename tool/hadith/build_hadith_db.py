"""Builds the bundled offline hadith database.

Run from the repo root:

    python tool/hadith/build_hadith_db.py

It downloads the Bengali and Arabic editions of the six canonical collections,
joins them into one SQLite file with an FTS index over the Bangla text, and
writes a gzipped copy to `assets/data/hadith.db.gz`, which the app ships and
inflates on first launch.

Why a prebuilt database rather than JSON assets: the raw editions are ~86 MB of
JSON, and `jsonDecode` on a 14 MB file costs seconds and tens of megabytes of
heap on the low-end phones this app targets. SQLite reads one chapter at a time
and the whole thing compresses to a fraction of the size in the APK.

Chapter titles come from `chapter_names_bn.json`, which is checked in beside
this script so a Bangla reader can correct a title without re-deriving anything.
"""

from __future__ import annotations

import gzip
import io
import json
import os
import re
import shutil
import sqlite3
import sys
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CACHE = Path(
    os.environ.get("HADITH_CACHE", Path(__file__).resolve().parent / ".cache")
)
OUT_DB = ROOT / "build" / "hadith" / "hadith.db"
OUT_GZ = ROOT / "assets" / "data" / "hadith.db.gz"
NAMES = Path(__file__).resolve().parent / "chapter_names_bn.json"

CDN = "https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions"

# slug -> (Bangla name, English name, Arabic name)
BOOKS = {
    "bukhari": ("সহিহ বুখারি", "Sahih al-Bukhari", "صحيح البخاري"),
    "muslim": ("সহিহ মুসলিম", "Sahih Muslim", "صحيح مسلم"),
    "abudawud": ("সুনানে আবু দাউদ", "Sunan Abu Dawud", "سنن أبي داود"),
    "tirmidhi": ("জামে তিরমিজি", "Jami at-Tirmidhi", "جامع الترمذي"),
    "ibnmajah": ("সুনানে ইবনে মাজাহ", "Sunan Ibn Majah", "سنن ابن ماجه"),
    "nasai": ("সুনানে নাসাই", "Sunan an-Nasa'i", "سنن النسائي"),
    "nawawi": ("৪০ হাদিস — নববি", "Forty Hadith of an-Nawawi", "الأربعون النووية"),
}

# The curated entry point for new users, surfaced differently on the হাদিস
# screen. Everything else is browsed as a full collection.
CURATED = {"nawawi"}


def fetch(edition: str) -> dict:
    CACHE.mkdir(parents=True, exist_ok=True)
    path = CACHE / f"{edition}.json"
    if not path.exists():
        url = f"{CDN}/{edition}.min.json"
        print(f"  downloading {edition} …", flush=True)
        with urllib.request.urlopen(url, timeout=300) as response:
            path.write_bytes(response.read())
    with io.open(path, encoding="utf-8") as handle:
        return json.load(handle)


def best_grade(entry: dict) -> str:
    """The single grading worth showing.

    Editions carry several graders; Al-Albani is the one Bangladeshi readers
    are most likely to recognise, so it wins when present.
    """
    grades = entry.get("grades") or []
    if not grades:
        return ""
    for grade in grades:
        if "albani" in (grade.get("name") or "").lower():
            return grade.get("grade") or ""
    return grades[0].get("grade") or ""


GRADE_BN = {
    "sahih": "সহিহ",
    "hasan": "হাসান",
    "da'if": "যঈফ",
    "daif": "যঈফ",
    "hasan sahih": "হাসান সহিহ",
    "sahih sahih": "সহিহ",
    "maudu": "জাল",
    "mawdu": "জাল",
    "munkar": "মুনকার",
    "shadh": "শায",
    "mursal": "মুরসাল",
    "maqtu": "মাকতু",
    "mawquf": "মাওকুফ",
    "batil": "বাতিল",
    "isnaad malool": "সনদে ত্রুটিপূর্ণ",
    "malool": "সনদে ত্রুটিপূর্ণ",
}


def clean_text(text: str) -> str:
    """Trims the stray leading punctuation some editions carry.

    Several of the sunan editions begin a hadith with the danda or a numeral
    that belonged to the print layout, not to the sentence. Left in, it shows
    up as `। ইবনু উমর (রাঃ) …` at the top of the reading card.
    """
    cleaned = (text or "").strip()
    cleaned = re.sub(r"^[\s।\-–—:.,;0-9০-৯/()]+", "", cleaned)
    return cleaned.strip()


def grade_bn(grade: str) -> str:
    key = re.sub(r"[^a-z' ]", "", (grade or "").lower()).strip()
    if not key:
        return ""
    if key in GRADE_BN:
        return GRADE_BN[key]
    for needle, value in GRADE_BN.items():
        if needle in key:
            return value
    return grade


def build() -> None:
    with io.open(NAMES, encoding="utf-8") as handle:
        chapter_names = json.load(handle)

    OUT_DB.parent.mkdir(parents=True, exist_ok=True)
    if OUT_DB.exists():
        OUT_DB.unlink()

    db = sqlite3.connect(OUT_DB)
    db.executescript(
        """
        PRAGMA journal_mode = OFF;
        PRAGMA synchronous  = OFF;

        CREATE TABLE book (
          slug           TEXT PRIMARY KEY,
          name_bn        TEXT NOT NULL,
          name_en        TEXT NOT NULL,
          name_ar        TEXT NOT NULL,
          chapter_count  INTEGER NOT NULL,
          hadith_count   INTEGER NOT NULL,
          curated        INTEGER NOT NULL DEFAULT 0,
          ordinal        INTEGER NOT NULL
        );

        CREATE TABLE chapter (
          book          TEXT NOT NULL,
          number        INTEGER NOT NULL,
          name_bn       TEXT NOT NULL,
          name_en       TEXT NOT NULL,
          hadith_count  INTEGER NOT NULL,
          first_hadith  INTEGER NOT NULL,
          last_hadith   INTEGER NOT NULL,
          PRIMARY KEY (book, number)
        );

        -- An explicit integer id, so the search index can be external-content
        -- and reference rows by rowid instead of keeping its own copy.
        CREATE TABLE hadith (
          id       INTEGER PRIMARY KEY,
          book     TEXT NOT NULL,
          number   INTEGER NOT NULL,
          chapter  INTEGER NOT NULL,
          arabic   TEXT NOT NULL DEFAULT '',
          bengali  TEXT NOT NULL DEFAULT '',
          grade    TEXT NOT NULL DEFAULT ''
        );

        CREATE UNIQUE INDEX idx_hadith_ref ON hadith (book, number);
        CREATE INDEX idx_hadith_chapter ON hadith (book, chapter, number);
        """
    )

    ordinal = 0
    for slug, (name_bn, name_en, name_ar) in BOOKS.items():
        ordinal += 1
        print(f"{slug} …", flush=True)

        ben = fetch(f"ben-{slug}")
        ara = fetch(f"ara-{slug}")

        arabic_by_number = {
            h["hadithnumber"]: (h.get("text") or "") for h in ara["hadiths"]
        }

        sections = {
            int(k): v
            for k, v in ben["metadata"]["sections"].items()
            if v and int(k) > 0
        }
        details = {
            int(k): v for k, v in ben["metadata"]["section_details"].items()
        }

        rows = []
        per_chapter = {}
        for entry in ben["hadiths"]:
            number = entry["hadithnumber"]
            # Editions use a float for sub-numbered hadiths (e.g. 1.1); the app
            # keys on integers, so those collapse onto their parent.
            if not isinstance(number, int):
                if float(number) != int(float(number)):
                    continue
                number = int(number)

            chapter = 0
            for section, detail in details.items():
                first = detail.get("hadithnumber_first")
                last = detail.get("hadithnumber_last")
                if first is None or last is None:
                    continue
                if first <= number <= last:
                    chapter = section
                    break
            if chapter not in sections:
                continue

            rows.append(
                (
                    slug,
                    number,
                    chapter,
                    clean_text(arabic_by_number.get(entry["hadithnumber"], "")),
                    clean_text(entry.get("text")),
                    grade_bn(best_grade(entry)),
                )
            )
            per_chapter[chapter] = per_chapter.get(chapter, 0) + 1

        db.executemany(
            "INSERT INTO hadith "
            "(book, number, chapter, arabic, bengali, grade) "
            "VALUES (?,?,?,?,?,?)",
            rows,
        )

        book_names = chapter_names.get(slug, {})
        missing = []
        chapters = []
        for number, english in sorted(sections.items()):
            bangla = book_names.get(english)
            if not bangla:
                missing.append(english)
                bangla = english
            detail = details.get(number, {})
            chapters.append(
                (
                    slug,
                    number,
                    bangla,
                    english,
                    per_chapter.get(number, 0),
                    detail.get("hadithnumber_first") or 0,
                    detail.get("hadithnumber_last") or 0,
                )
            )

        db.executemany(
            "INSERT OR REPLACE INTO chapter "
            "(book, number, name_bn, name_en, hadith_count, first_hadith, "
            " last_hadith) VALUES (?,?,?,?,?,?,?)",
            chapters,
        )

        db.execute(
            "INSERT OR REPLACE INTO book "
            "(slug, name_bn, name_en, name_ar, chapter_count, hadith_count, "
            " curated, ordinal) VALUES (?,?,?,?,?,?,?,?)",
            (
                slug,
                name_bn,
                name_en,
                name_ar,
                len(chapters),
                len(rows),
                1 if slug in CURATED else 0,
                ordinal,
            ),
        )

        print(f"  {len(rows)} hadiths, {len(chapters)} chapters", flush=True)
        if missing:
            print(
                f"  !! {len(missing)} chapter titles still English: "
                f"{missing[:3]}{' …' if len(missing) > 3 else ''}",
                flush=True,
            )

    # Full-text search over the Bangla text.
    #
    # `content='hadith'` makes this an external-content index: FTS5 stores only
    # the term index and reads the text back from `hadith` by rowid, instead of
    # keeping a second copy. On this corpus that is the difference between a
    # ~169 MB database and a ~95 MB one, which matters because the file is
    # inflated onto the user's device.
    #
    # `unicode61` is enough for Bengali — it splits on the Unicode word
    # boundaries the script already uses, and trigram would balloon the index
    # for little gain on a language with long compound words.
    print("building the search index …", flush=True)
    db.executescript(
        """
        CREATE VIRTUAL TABLE hadith_fts USING fts5(
          bengali,
          content = 'hadith',
          content_rowid = 'id',
          tokenize = 'unicode61'
        );

        INSERT INTO hadith_fts (rowid, bengali)
          SELECT id, bengali FROM hadith;
        """
    )

    db.commit()
    db.execute("VACUUM")
    db.commit()
    db.close()

    raw = OUT_DB.stat().st_size
    OUT_GZ.parent.mkdir(parents=True, exist_ok=True)
    with open(OUT_DB, "rb") as src, gzip.open(OUT_GZ, "wb", compresslevel=9) as dst:
        shutil.copyfileobj(src, dst)
    packed = OUT_GZ.stat().st_size

    print()
    print(f"database  {raw / 1048576:.1f} MB  ->  {OUT_DB}")
    print(f"shipped   {packed / 1048576:.1f} MB  ->  {OUT_GZ}")


if __name__ == "__main__":
    sys.exit(build())

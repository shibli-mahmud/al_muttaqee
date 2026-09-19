# al_muttaqee

A new Flutter project for islamic lifestyle. Prayer Time, Tasbih, Arabic Calender, Daily hadith quotes and so many features.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Setup

### Google Maps (masjid finder)

Two separate keys, or the same key used twice:

- **Places API** — finds the nearby mosques. Read at runtime from `.env` as
  `GOOGLE_PLACES_API_KEY`.
- **Maps SDK for Android** — renders the map. A *build* setting, not a runtime
  one. Put it in `android/local.properties`:

  ```properties
  GOOGLE_MAPS_API_KEY=AIza...
  ```

  or export `GOOGLE_MAPS_API_KEY` before building. It is injected into the
  manifest by Gradle and is never committed.

Restrict the key to the Maps SDK and Places API, and lock it to this app's
package name and signing certificate. Without a key the app still builds and
runs; only the map is blank.

Walking routes use [OSRM](https://project-osrm.org), which is free and needs no
key. The public demo server has no uptime guarantee — point
`RouteRepository._baseUrl` at your own instance before a wide release.

### Hadith corpus

`assets/data/hadith.db.gz` is committed and the app builds from a clean clone.
To rebuild it from source:

```bash
python tool/hadith/build_hadith_db.py
```

It downloads the Bengali and Arabic editions, joins them with the Bangla
chapter titles in `tool/hadith/chapter_names_bn.json`, and writes the gzipped
database. Correct a chapter title in that JSON and re-run.

### App icon

```bash
python tool/branding/build_brand_assets.py
```

Draws the mark and writes every Android density, the adaptive icon, the iOS set
and the splash. Requires Pillow.

### Adhan audio

Not in the repo. Drop `adhan_makkah`, `adhan_madinah` and `adhan_mishary` into
`android/app/src/main/res/raw/` to enable those options; until then they fall
back to the device notification sound.

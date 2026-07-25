# Al Muttaqee — App Updates Guideline (for Cursor AI)

> Read this file fully before writing any code. Follow it phase by phase, in order.
> Do not skip ahead to a later phase until the current phase's modules compile, run, and match the acceptance checklist.
> Match the existing project conventions at all times: GetX (binding/controller/view per module under `lib/src/module/<feature>/`), Figtree typography, green/cream palette, Phosphor icons, bilingual strings via `flutter gen-l10n` (never hardcode English or Bangla text — add both to the `.arb` files).

---

## Ground rules for every phase

1. **No ads, anywhere, ever.** Do not add AdMob, any ad SDK, or any ad-related dependency to `pubspec.yaml` under any circumstance, even if a future prompt asks for "monetization" — monetization here means in-app purchase or donation only (see Phase 6).
2. **Offline-first stays the default.** Only Masjid Finder and (optionally) live Zakat gold/silver rates should touch the network. Everything else — Quran, Hadith, Duas, Prayer Times — must work with zero internet connection, using bundled local assets or on-device calculation.
3. **Every new screen needs an English AND Bangla string**, added to both `.arb` files, never a hardcoded literal in a widget.
4. **Every new feature module follows the existing folder pattern**: `lib/src/module/<feature>/bindings/`, `controllers/`, `models/`, `data/` (if it has bundled local data), `views/`. Register the binding in `initial_bindings.dart` or the relevant route binding, matching how `quran_binding.dart` is wired.
5. **Reuse existing shared widgets** (`application_bar.dart`, `asset_image_view.dart`, `primary_outlined_button.dart`, etc.) before creating new ones. Only add a new shared widget if no existing one fits, and place it in `lib/src/core/shared/widgets/`.
6. **Local persistence** continues through `shared_preferences` for simple flags/settings (last-read, selected qari, selected madhab for prayer calculation, etc.). Don't introduce a database (e.g. sqflite/Hive) unless a phase below explicitly calls for it.
7. **After each phase**, run the app on both a light content screen and a long-content screen (e.g. Surah Al-Baqarah) to check for overflow/performance regressions before moving to the next phase.

---

## Phase 0 — Housekeeping (do this first, it's small)

- [ ] Rename/confirm app metadata (`pubspec.yaml` description) still matches current vision — update if features listed here are added.
- [ ] Add a `CHANGELOG.md` at repo root if one doesn't exist; add an entry each time a phase in this document is completed.
- [ ] Wire the existing unused `dio` scaffolding (`dio_network_provider.dart`) so it's ready for Phase 4 (Masjid Finder) — verify the base URL / interceptors are configured correctly rather than left empty.

---

## Phase 1 — Home Dashboard (highest priority — currently a placeholder)

Home is the most-opened screen in the app and today it's just a logo + menu button. Rebuild it as the actual dashboard:

- [ ] **Next-salat card** at the top: current prayer name, time remaining (live countdown), next prayer name + time. (Depends on Phase 2 being built first — do Phase 2 before finishing this card, but you can scaffold the UI with dummy data now.)
- [ ] **Hijri date row**: Gregorian date + Hijri date side by side.
- [ ] **Daily card carousel or stacked cards**: rotate between "Hadith of the Day" and "Dua of the Day" (bundle a small curated JSON list to start — 30-60 entries is enough to feel fresh for a month on rotation by day-of-month).
- [ ] **Quick-access grid**: Continue Reading Quran (uses existing last-read pref), Qibla, Tasbih, Masjid Finder — 2x2 or horizontal scroll of icon cards.
- [ ] Keep the language drawer entry point exactly where it is now.
- [ ] Acceptance: Home no longer shows only a logo; all four sections render with real or seeded data; no layout overflow on a small screen (iPhone SE size) or a large one (tablet width).

---

## Phase 2 — Prayer Times Module

New module: `lib/src/module/prayer_times/`

- [ ] Add the `adhan_dart` package (pure-Dart port of the Adhan calculation library — no network call needed, works fully offline) to `pubspec.yaml`.
- [ ] Controller computes the day's 5 prayer times + sunrise from device GPS coordinates (reuse the location logic already built for Qibla — don't duplicate permission-handling code, extract it into a shared location service in `core/utils` if it isn't already reusable).
- [ ] Settings: let the user pick a calculation method (default to "Karachi/University of Islamic Sciences" since that's standard for Bangladesh) and an optional manual offset in minutes per prayer, stored via `shared_preferences`.
- [ ] Build the Prayer Times view: today's 5 prayers + sunrise in a clean list, current prayer highlighted, next-prayer countdown at the top (this feeds the Home card from Phase 1).
- [ ] Acceptance: times are correct for the device's current location and match a reference source (e.g. IslamicFinder.org) within a minute or two; toggling calculation method changes the times.

---

## Phase 3 — Local Notifications (Salat Alerts + Dua Reminders)

- [ ] Add `flutter_local_notifications` + `timezone` packages.
- [ ] On app open (and once daily via a lightweight background reschedule, e.g. `workmanager` or rescheduling on each cold start — keep it simple, avoid heavy background-service complexity for v1), schedule notifications for each of the day's 5 prayer times using the times computed in Phase 2.
- [ ] Add a settings toggle per-prayer (some users only want Fajr + Maghrib alerts, for example) and a global on/off switch.
- [ ] Add a second notification channel for "Dua reminders" — 2-3 times a day (morning azkar, evening azkar, before-sleep dua), toggleable separately from salat alerts.
- [ ] Acceptance: notifications fire at the correct scheduled times on a real device (test on both Android and iOS — iOS notification permission flow is stricter, handle the permission-denied case gracefully with an in-app explanation, not just a silent failure).

---

## Phase 4 — Hadith Module

New module: `lib/src/module/hadith/`

- [ ] Scope confirmed: **five books** — Sahih Bukhari, Sahih Muslim, Jami at-Tirmidhi, Sunan Abu Dawud, Sunan Ibn Majah.
- [ ] **Data source**: use the free, no-key **Bangla Hadith API** (`alquranbd.com/api/hadith`, book keys: `bukhari`, `muslim` or `muslimHA`, `abuDaud`, `ibnMajah`, `tirmidi`) — it returns Arabic, Bangla, and English text together per hadith (`hadithArabic`, `hadithBengali`, `hadithEnglish`), structured book → chapter → hadith, sourced from Islamic Foundation Bangladesh's translation. This covers all five target books in all three languages from one source — no need to combine multiple APIs.
- [ ] **Before shipping**: the repo doesn't publish an explicit license file, so send a quick note to the maintainer (via the repo's GitHub Issues tab) confirming it's fine to use in a published app. Build and test against it now in parallel — don't block development on this reply.
- [ ] Fetch once per book/chapter and cache locally (bundled or on first use) — do not re-fetch on every app open, to stay consistent with the offline-first approach.
- [ ] Data structure: book → chapter/section → hadith (Arabic text, Bangla translation, English translation, narrator where provided by the API).
- [ ] Mirror the exact navigation pattern already used in Quran: book list → chapter list → hadith detail, reusing `para_surah_list_view.dart` and `surah_detail_view.dart` as structural templates (rename/adapt, don't reinvent).
- [ ] Add a "Bookmark" feature for individual hadiths (stored in `shared_preferences` as a list of IDs, same pattern as Quran's last-read).
- [ ] Add a simple in-app search across hadith text (title/first line match is enough for v1 — don't build a fuzzy search engine).
- [ ] **Attribution requirement**: add a "Sources" line/screen crediting the Bangla translation source (e.g. Islamic Foundation Bangladesh, depending on which dataset is used) — check the specific dataset's license terms before shipping and include whatever attribution it requires.
- [ ] Acceptance: all 4 books browsable offline, bookmarks persist across app restart, search returns relevant results.

---

## Phase 5 — Quran Module Upgrade (Audio + Multi-Qari)

- [ ] Add per-ayah audio playback. Use a package like `just_audio` (well-maintained, supports gapless playback and background audio) rather than building custom audio handling.
- [ ] **Reciter/audio source — no preference given, so use whatever's free and simplest to integrate:**
  - Primary recommendation: **Al Quran Cloud API** (`api.alquran.cloud`, no key required, no signup) — serves per-ayah audio from a CDN alongside the Arabic text and translations you may already be pulling from `quran_flutter`, and it bundles multiple well-known reciters (Alafasy, Abdul Basit, Al-Sudais, Al-Ghamdi, Minshawy, Al-Ajmy are commonly available through APIs like this). One source for both audio and reference text keeps integration simple.
  - Fallback/alternative: **everyayah.com**'s per-ayah MP3 dataset (widely used by other Quran apps for exactly this feature — includes ~20+ reciters at file-per-ayah granularity, which is ideal for the synced-highlight player below) or **mp3quran.net**'s API (230+ reciters, but mostly per-surah rather than per-ayah, so better suited as a secondary/"more reciters" option than the primary sync-highlight experience).
  - Launch with a small curated set (4-6 well-known reciters) rather than all available ones — keeps the settings UI simple and avoids overwhelming choice; more can be added later without an app update if streamed rather than bundled.
- [ ] **Storage decision**: don't bundle all reciters' audio in the app binary (this would be enormous — full Quran audio per reciter can be 300MB+). Stream/cache per-surah on first play instead, using `flutter_cache_manager` or similar, and let users pick "download for offline" per-surah or per-juz if they want it available without data.
- [ ] Add a **recitation player bar**: play/pause, current ayah highlight (auto-scroll to synced ayah), repeat-ayah, repeat-surah, playback speed control.
- [ ] Add a **qari selection** setting (list of available reciters, stored as a preference, affects which audio source is streamed/played).
- [ ] Acceptance: tapping an ayah plays its audio, the reader auto-scrolls/highlights in sync, switching qari changes the voice, and a chosen surah can be marked for offline download and then played with no connection.

---

## Phase 6 — Masjid Finder (Map)

New module: `lib/src/module/masjid_finder/`

- [ ] Add `google_maps_flutter` (the `dark_map.json` style asset already bundled in `assets/map_styles/` suggests this was anticipated — apply it as the map's night-mode style).
- [ ] Use the device location (reuse the shared location service from Phase 2) as the map center; query nearby mosques via Google Places API (Nearby Search, type=mosque) through the now-wired `dio` network provider.
- [ ] Show results as map pins + a scrollable bottom list (name, distance, "Open in Maps" button for turn-by-turn directions via the native Maps app rather than building in-app navigation).
- [ ] Requires a Google Maps API key + Places API key — add these via `flutter_dotenv` (already a dependency) rather than hardcoding, and add both Android/iOS platform config (API key in `AndroidManifest.xml`, `AppDelegate.swift`) — see the Developer Help Guide for the exact steps and required Google Cloud Console setup.
- [ ] Acceptance: map centers on current location, nearby mosques appear as pins within a reasonable radius (start with 5km, make it adjustable), tapping a pin/list item opens directions in the native maps app.

---

## Phase 7 — Monetization (No Ads)

- [ ] Add `in_app_purchase` package.
- [ ] Define a single one-time "Pro" unlock (not a subscription, to start) that gates: offline audio download for all reciters (vs. one free reciter in the free tier), full hadith bookmarking/search (vs. browse-only in free), and an ad-free-forever badge (moot since there are no ads, but frame it as "support development").
- [ ] Add an optional, separate **"Sadaqah / Support this app"** donation entry point (in-app purchase consumable, any amount, or a link to a payment page) — framed as charity, not a paywall.
- [ ] Do not paywall core worship features: Quran text/translation, Prayer Times, Qibla, and Tasbih must always remain fully free — this matters for both user trust and app store review guidelines around religious app monetization.
- [ ] Acceptance: purchase flow completes and unlocks the correct features on both platforms' sandbox/test environments; restoring a purchase on a new device works correctly.

---

## Phase 8 — Islamic/Arabic Calendar

- [ ] Add a Hijri calendar package (pure calculation, offline) or compute via a well-tested conversion algorithm — avoid needing network for this.
- [ ] Show a month view with Hijri dates overlaid on Gregorian, and mark important Islamic dates (Ramadan start, both Eids, Ashura, Laylatul Qadr estimated nights, etc.).
- [ ] Add a **Ramadan mode**: when the app detects the current Hijri month is Ramadan, show Sehri/Iftar countdown timers on Home (reusing the Prayer Times data — Sehri ends at Fajr, Iftar is at Maghrib) and swap the daily card rotation (Phase 1) to Ramadan-specific duas.
- [ ] Acceptance: Hijri dates are accurate against a reference source; Ramadan mode auto-activates and auto-deactivates at the correct Hijri month boundaries.

---

## Phase 9 — Zakat Calculator (lower priority, do after core features are solid)

- [ ] Simple form: cash, gold, silver, business assets, debts owed to you, debts you owe → nisab threshold comparison → Zakat due amount.
- [ ] Nisab uses current gold/silver rates — this is the one place beyond Masjid Finder where a live API call is justified (fetch and cache daily; fall back to a bundled "last known rate" if offline, with a visible "rates last updated on X" note so the user knows it may be stale).
- [ ] Acceptance: calculation matches standard Zakat calculation methodology; works offline using the last cached rate with a clear staleness indicator.

---

## Legal / licensing checklist before publishing (see Developer Help Guide for full detail)

- [ ] Confirm license terms for: the Quran translation text/audio, each qari's recitation audio, the hadith translation dataset, and the Bangla hadith translation source — attribute all of them in an in-app "Sources" screen.
- [ ] Google Play & App Store both have specific policies on religious apps and in-app purchases — review both stores' current developer policy pages before submission (policies change, so check at submission time rather than relying on this document).
- [ ] Location permission (Qibla, Prayer Times by GPS, Masjid Finder) and notification permission both need clear in-app rationale screens shown before the OS permission prompt, per current Android/iOS best practice and store review expectations.
- [ ] Privacy Policy is mandatory once you request location permission or add in-app purchases — required by both stores.

---

## When you (Cursor) are unsure

If a step above is ambiguous or you need a product decision (e.g., "which hadith dataset exactly," "which qari list to launch with"), stop and ask rather than guessing — these are content/licensing decisions, not implementation details.

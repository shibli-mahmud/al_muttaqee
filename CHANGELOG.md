# Changelog

All notable changes to Al Muttaqee are documented in this file.

## [Unreleased]

### Dusk redesign — the remaining screens

All 21 frames of the design board are now built. This batch covers the ten that
were still on the pre-Dusk layouts.

**তাসবিহ — a misbaha, not a counter.** The screen now draws the bead loop: 33
beads on a cord, a marker at the top, and the ring turning one bead per count
with a little overshoot so a bead settles rather than snapping. Both gestures
work the way the object does — tap for one bead, or drag around the ring and
the beads that pass under your thumb are counted, which is how a misbaha is
actually used. A round completes with a heavier haptic and a brief gold flare.

**কিবলা — the card turns, not the needle.** The compass face rotates under a
fixed needle, the way a real compass card floats under the lubber line;
spinning a needle over a fixed card reads backwards, because the thing that is
moving is you. Painted rather than assembled, so the tick ring, cardinals and
Kaaba marker are one canvas instead of a hundred transforms a frame. The
heading is low-pass filtered — the raw magnetometer jitters several degrees on
a still phone — the needle strengthens as you come onto the bearing, and the
state pill says which way to turn and by how much rather than only saying
"aligned" once you get there. A haptic fires on entering alignment, once.

**মসজিদ ও জামাত — real map, free routing.** Google Maps with a pin per masjid,
the selected one picked out, and a walking route drawn in. Routing uses OSRM,
which is open, keyless and free; Google's Directions API is billed per call and
is not worth it to draw one line to a masjid down the road. When routing fails
the line degrades to a dashed straight line that shows direction and distance
and declines to guess a walking time. Turn-by-turn hands off to the Google Maps
app through a URL, which costs nothing and is what people already use. Jamaat
times are recorded per masjid, with the next one picked out in gold on the
five-cell strip — the crowd-sourcing seam is a local store today and gains a
sync when there is a backend.
- The Maps SDK key now comes from `android/local.properties` or the environment
  through a Gradle manifest placeholder, so no key is committed. A clean clone
  builds without one; only the map is blank.

**কুরআন — the reader.** Rebuilt the index (last-read hero, surah/para/bookmark
tabs, search), the reading surface with a full night mode, per-user Arabic and
translation font scales with live samples, the fixed player bar, the long-press
ayah sheet, and the daily reading plan with a thirty-day heatmap.
- **Tapping an ayah no longer starts playback.** It fired constantly by
  accident while people were reading. Playback starts from the player bar or
  the long-press sheet.
- Bookmarks, notes and reading progress are new tables (schema v3) in the
  user's own database, so they are backed up with their prayer log.

**দুআ — built on the corpus.** There is no free complete Bangla dua dataset to
be had, so rather than hand-assembling one, the module reads the supplication
chapters already in the bundled hadith corpus: 440 narrated duas with Arabic,
Bangla and a source, across Bukhari, Muslim, Ibn Majah and an-Nasa'i. Every dua
is attributable, which for religious content matters more than a tidier list
would. Categories are full-text queries rather than invented tags, and the
contextual chip is chosen by the clock.

**রমজান মোড.** The amber family through the whole screen, not just the hero.
The countdown changes subject at sunset — iftar before Maghrib, the end of
sehri after. A 30-day fast grid where a future day carries no number (nothing
to report yet reads differently from missed), plus taraweeh with a streak.

**যাকাত.** Gold and silver are entered in **bhori**, which is how they are
bought and talked about in Bangladesh. The payable figure is pinned to the
bottom so it stays visible while the inputs that change it are being typed, and
below nisab it states the ruling rather than printing a zero. Custom categories
can be added, and a half-finished calculation survives closing the app.

**হিজরি ক্যালেন্ডার.** The Hijri day is the primary reading with the Gregorian
under it at a full 12px — it is content, not decoration. **The Hijri date is
adjustable by ±1 day**, because the calculated date and the Bangladeshi moon
sighting announcement routinely differ and putting Eid on the wrong day is the
worst thing this app could do.

**Branding.** Replaced the default Flutter launcher icon and the green mosque
clip art with a mark drawn from the app's own primitives — the Dusk gradient,
the khatim tile, one gold form. Every Android density, the adaptive icon, all
fifteen iOS slots and the splash come out of one script.

**Two bugs the new tests caught**
- The dua contextual windows left an hour of the day uncovered, so the screen
  would have opened on nothing between 10 and 11 each morning.
- The polyline decoder ran past the end of a truncated response and threw,
  which would have crashed the masjid map on a dropped connection. It now
  returns the points it managed to decode.

### Hadith — a real, offline Bangla corpus

- **The hadith module had no data.** It fetched from `alquranbd.com/api/`,
  which now 404s on every path, so in practice every screen fell through to the
  twelve-entry sample bundled as its offline fallback. Replaced entirely.
- Added `tool/hadith/build_hadith_db.py`, which joins the Bengali and Arabic
  editions of the six canonical collections into one SQLite file and ships it
  gzipped at `assets/data/hadith.db.gz`. **34,051 hadiths** — Bukhari 7,557 ·
  Muslim 7,471 · Abu Dawud 5,274 · Tirmidhi 3,956 · Ibn Majah 4,075 · Nasa'i
  5,676 · ৪০ হাদিস নববি 42 — each with its Arabic, its Bangla translation and,
  where the edition grades it, an Al-Albani grading rendered in Bangla
  (সহিহ / হাসান / যঈফ …).
- All **334 chapter titles are in Bangla**. They are checked in as
  `tool/hadith/chapter_names_bn.json` so a Bangla reader can correct one
  without re-deriving anything.
- The corpus inflates to the app support directory on first launch (~113 MB)
  and is read-only from then on. It is a separate database from the user's own
  records, which must never be thrown away; this one can be evicted and
  re-inflated at will.
- Added FTS5 search over the Bangla text, with the terms marked in the results.
  The index is external-content, which is the difference between a 169 MB and a
  113 MB database.
- Rebuilt the হাদিস screen on the Dusk design (frame ১৫), plus collection,
  chapter, search and bookmark screens. **Bookmarking is no longer behind the
  Pro unlock** — the design takes the paywall out of the features entirely.
- The home card's hadith of the day now comes from the curated forty, so it is
  always something short and well known rather than a page of isnad.

### Tasbih — a counter that remembers

- **It kept nothing.** The count lived in memory, so backgrounding the app
  mid-dhikr threw it away, there was one hard-coded target of 33, and no
  history. Rebuilt on the Dusk design (frame ০৭).
- Added six dhikr presets — সুবহানাল্লাহ, আলহামদুলিল্লাহ, আল্লাহু আকবার,
  লা ইলাহা ইল্লাল্লাহ, আস্তাগফিরুল্লাহ, দরুদ — each with its Arabic,
  transliteration, meaning and traditional count, and a per-dhikr target the
  user can change.
- Added a `dhikr_log` table (schema v2): one row per dhikr per day, which is
  what makes today's total, the rounds, the streak and a thirty-day history
  possible without storing a row per tap.
- The whole counter card is the tap target, not a small button — on a
  one-handed phone the thumb lands in the middle of the screen. A gold ring
  shows the round without a number, long-press on the count button undoes a
  miscount, a round completes with a heavier haptic and a flare, and the
  haptics toggle is remembered.
- Added a history screen: days counted, total dhikr, streak, and a bar per day
  with the dhikr it was mostly spent on.

### Branding

- **Replaced the placeholder.** The launcher icon was the default Flutter icon
  and the in-app logo was generic green mosque clip art, which the design brief
  rules out twice over — wrong palette, and "no stock mosque imagery,
  geometry and type only".
- Added `tool/branding/build_brand_assets.py`, which draws the mark from the
  same primitives as the app's heroes (the Dusk gradient, the khatim tile, one
  gold form) and exports every Android density, the adaptive icon with its
  monochrome layer, all fifteen iOS slots, and the splash mark.
- The native launch window is now ivory with the mark on it rather than a white
  flash, and the splash screen, the launcher icon and onboarding frame ০৯ all
  carry the same glyph.

### Dusk redesign, phase 1 — retention

The first of three phases recreating the "Dusk" design board in the app. This
one is self-contained and shippable on its own: it re-skins everything, rebuilds
the shell and the two prayer screens, and makes the adhan actually fire on time.

**Design tokens**
- Replaced the cream/green palette in `app_colors.dart` with the Dusk palette —
  deep-teal gradients, a brass-gold accent, warm ivory ground — plus the
  time-of-day hero themes (`DuskHeroTheme`) and the radius scale (`DuskRadius`).
  A block of legacy aliases maps the old `brand*`/`grey*` names onto Dusk
  values, so screens that have not been rebuilt yet shifted palette in the same
  commit instead of leaving the app half old and half new.
- Extended `AppValues` with the Dusk spacing, radius, type, icon and motion
  scales, and added `DuskText` for the three-family type system.
- Bundled **Anek Bangla**, **Plus Jakarta Sans** and **Amiri** under
  `assets/fonts/` and dropped `google_fonts`. The audience is often on a poor
  connection and Amiri has to be present offline for the Quran reader, so no
  interface font is fetched at runtime any more.
- Added the khatim star texture as a `CustomPainter` rather than a tiled PNG.
  The hero's pattern ink changes with the time of day — ivory on teal, warm
  cream at Maghrib — and a raster tile would need one asset per ink.
- Promoted `formatNumberWithLocale` out of the Quran module into
  `core/utils/number_format.dart` and grew it into the app's one number
  surface: Bengali numerals, Indian lakh/crore grouping, taka after the amount,
  countdowns, clock times with the Bangla part of day.

**Shared widgets** (`core/shared/widgets/dusk/`)
- `DuskHero`, `DuskNavBar`, `GroupedCard` / `GroupedRow` / `DuskCard`,
  `DuskSwitch`, `TrackerCircle`, `DuskPrimaryButton`, and the inline
  error/empty/skeleton states.
- `DuskSwitch` is custom rather than `Switch.adaptive`: the Material switch's
  track, thumb and M3 thumb icon cannot be made to match the design.

**Navigation**
- Grew the dashboard from four tabs to five — হোম / কুরআন / নামাজ / তাসবিহ /
  আরও — promoting prayer times to a first-class destination and moving Qibla
  out to a quick action.
- Replaced `BottomNavigationBar` with the floating `DuskNavBar`, and switched
  the tab host to `IndexedStack` so each tab keeps its scroll position.
- Deleted the language drawer; language moved to আরও → ভাষা.

**Screens**
- Rebuilt হোম on the design: time-of-day hero, countdown pill, five-prayer
  strip, dual date cards, the new prayer tracker, continue-reading card, daily
  hadith with its Arabic, and quick access.
- Rebuilt নামাজ: date pager, full prayer list with per-prayer icon chips and
  jamaat times, tracker circles, a month heatmap, and the settings rows.
- Added আরও: a nine-tile feature grid and the settings list.
- Moved calculation method, madhab and per-prayer offsets out of a bottom sheet
  onto a pushed screen, and added user-editable jamaat times beside them.
- Added the three-page onboarding — language, location (with a required
  manual-city fallback), reminders — run once before the dashboard.

**Prayer tracking** (new)
- Added a `sqflite` database for the per-day logs, which accumulate for years
  and are queried by date range for the heatmap and the streak.
- Added `TrackerController` with optimistic writes, and streak logic that does
  not let an unfinished today break yesterday's streak.

**Notifications**
- Rewrote `NotificationService` around a rolling seven-day window of exact
  alarms, refilled on launch, on any settings change and on a location move, so
  a user who does not open the app for a week still hears the adhan.
- Added per-prayer mode (adhan / silent / off), adhan sound and pre-adhan
  offset, plus Jumu'ah, tahajjud and daily-hadith reminders.
- Added a permission surface for `POST_NOTIFICATIONS`, exact alarms and
  battery-optimisation exclusion — including a Kotlin method channel for the
  OEM battery intent — and a status card that says plainly, in Bangla, which
  gate is shut. When exact alarms are unavailable the schedule degrades to
  inexact rather than firing late with no explanation.
- Prayer-alert channels use `USAGE_ALARM` so the adhan is audible in Do Not
  Disturb. **The adhan recordings themselves are not in the repo**: drop
  `adhan_makkah`, `adhan_madinah` and `adhan_mishary` into
  `android/app/src/main/res/raw/` (and the iOS bundle) to enable those options;
  until then they fall back to the device notification sound.
- Removed the old `notification_settings_view.dart`, superseded by the
  আজান ও রিমাইন্ডার screen.

**Not in this phase** — the Quran reader redesign, night mode, bookmarks and
notes, the reading plan, dua and Ramadan (phase 2), and jamaat crowd-sourcing,
home-screen widgets, ৯৯ নাম and zakat history (phase 3). Their routes exist and
land on a "coming soon" screen so the আরও grid has no dead tiles.

### Phase 9 — Zakat Calculator
- Added a Zakat form covering cash, gold, silver, business assets, receivables, and debts, with gold/silver nisab calculation and 2.5% due amount.
- Added daily metal-rate retrieval with SharedPreferences caching and offline fallback.

### Phase 8 — Islamic Calendar
- Added an offline Hijri/Gregorian month calendar with Ashura, Ramadan, Laylatul Qadr, and Eid date markers.
- Added automatic Ramadan Home card showing Sehri end and Iftar times from Prayer Times.

### Phase 7 — Monetization (No Ads)
- Added a one-time Pro purchase and optional consumable Sadaqah support flow, including purchase restore and a debug-only local unlock.
- Kept Quran text, Prayer Times, Qibla, and Tasbih fully free; no ad SDK was added.

### Phase 6 — Masjid Finder
- Added a Google Maps based nearby-mosque finder with shared device location, Places Nearby Search, night map styling, and external Maps directions.
- Added Maps/Places environment-key documentation and Android Maps SDK metadata placeholder.

### Phase 5 — Quran Audio + Multi-Qari
- Added Al Quran Cloud per-ayah playback with six selectable reciters, synchronized verse highlighting, repeat controls, and playback speed.
- Added cached audio streaming plus per-surah offline downloads and persistent qari preference.

### Phase 4 — Hadith
- Added an offline-first Hadith browser for Sahih al-Bukhari, Sahih Muslim, Sunan Abu Dawud, Sunan Ibn Majah, and Jami` at-Tirmidhi
- Added API fetch with cache, bundled offline fallback (`hadith_bundle.json`), chapter navigation, locale-aware Arabic/translation, search, and bookmarks
- Added route `/hadith`, Home Hadith-of-the-Day navigation, and source attribution for Islamic Foundation Bangladesh / alquranbd

### Phase 3 — Local Notifications
- Added `flutter_local_notifications` + timezone scheduling for prayer alerts and dua reminders
- Added per-prayer toggles, global on/off, dua reminder channel, and notification settings screen
- Reschedules on cold start and after prayer times refresh

### Phase 2 — Prayer Times
- Added offline Prayer Times module using `adhan_dart` (Karachi default, Hanafi madhab, per-prayer offsets)
- Extracted shared `LocationService` and reused it from Qibla
- Prayer Times settings sheet + route `/prayer-times`

### Phase 1 — Home Dashboard
- Rebuilt Home with next-salat card, Gregorian/Hijri dates, Hadith/Dua of the Day carousel, and quick-access grid
- Bundled `assets/data/daily_content.json` (30 hadiths + 30 duas, EN/BN)

### Phase 0 — Housekeeping
- Updated app description to match the current product vision
- Added this changelog
- Wired Dio network provider with dotenv-based base URL and request headers for upcoming Masjid Finder / API features
- Added `.env.example` for API configuration

## [1.0.0] — Existing
- Splash, Dashboard shell, Quran reader, Qibla compass, Tasbih counter
- English / Bangla localization

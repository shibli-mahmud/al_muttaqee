# Changelog

All notable changes to Al Muttaqee are documented in this file.

## [Unreleased]

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

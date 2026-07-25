# Changelog

All notable changes to Al Muttaqee are documented in this file.

## [Unreleased]

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

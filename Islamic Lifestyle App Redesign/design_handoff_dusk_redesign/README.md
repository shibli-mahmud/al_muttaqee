# Handoff: Al Muttaqee — "Dusk" UI/UX Redesign (v2)

## Overview

Al Muttaqee is an existing Flutter Islamic-lifestyle app for a Bangladeshi audience (prayer times, Quran with audio, tasbih, qibla, hadith, zakat, masjid finder, Hijri calendar). This package is a **complete visual and structural redesign** of that app, plus a set of new features, delivered as a 21-screen design board.

Two things change:

1. **Visual direction** — from the current cream/green Material-default look to **"Dusk"**: a deep-teal gradient hero with a brass-gold accent on a warm ivory ground, large radii, soft shadows, and a time-of-day-adaptive header.
2. **Information architecture** — from 4 tabs (Home / Quran / Qibla / Tasbih) to **5 tabs (হোম / কুরআন / নামাজ / তাসবিহ / আরও)**, promoting prayer times to a first-class destination and demoting Qibla to a quick action.

New features designed in: prayer tracking with streaks, per-prayer adhan/reminder settings, a Quran daily reading plan, ayah bookmarks & notes, word-by-word audio highlighting, night reading mode, a categorised dua collection, Ramadan mode, and jamaat times on both the prayer list and each masjid.

The app is **Bangla-first**. All interface copy in the designs is final Bangla copy, and all numerals shown to the user are Bengali numerals (০১২৩৪৫৬৭৮৯).

---

## About the Design Files

The files in this bundle — `Al Muttaqee v2 Dusk.dc.html` and `Al Muttaqee Redesign.dc.html` — are **design references created in HTML**. They are prototypes that communicate intended look, layout, and content. **They are not production code and should not be ported, embedded, or transliterated into the app.**

The task is to **recreate these designs in the existing Flutter codebase**, using its established patterns:

- GetX for state and routing (`Get.toNamed`, `GetxController`, `Obx`)
- The `BaseView<Controller>` pattern in `lib/src/core/base/base_view.dart` (each view overrides `appBar()`, `body()`, `bottomNavigationBar()`, `drawer()`)
- The existing module layout `lib/src/module/<feature>/{views,controllers,bindings}/`
- Constants in `lib/src/core/constants/` (`app_colors.dart`, `app_textstyles.dart`, `app_values.dart`)
- `flutter_localizations` + the ARB files behind `lib/l10n/app_localizations.dart`

Do not introduce a new state-management library, a new routing approach, or a new folder convention. The redesign is a re-skin plus new screens inside the architecture that already exists.

**Open the HTML boards in a browser to see the designs.** `support.js` must sit next to them (it is included in this bundle). Both boards pan and zoom like a design canvas. Each phone frame is labelled with a Bengali frame number (০১–২১) and an English caption; this README refers to those numbers.

`Al Muttaqee v2 Dusk.dc.html` is **the design to build**. `Al Muttaqee Redesign.dc.html` is a superseded earlier direction (flat/modernist), included only as history — **do not build from it**.

---

## Fidelity

**High-fidelity.** Final colors, typography, spacing, radii, shadows, iconography and copy. Recreate the UI faithfully using the values in the Design Tokens section.

Two important qualifications on "pixel-perfect":

- **Target token-perfection, not pixel-matching.** Every color, radius, spacing value and font size should come from a named constant in `AppColors` / `AppValues` / `AppTextStyles`. Bangla text metrics resolve differently in a browser than in Flutter's text engine, so vertical rhythm will land a few pixels off the HTML. That is expected and fine. Do not add magic offsets to force a match.
- **The frames are artboards, not viewports.** Several frames are drawn taller than a real phone screen (e.g. হোম at 1252px, নামাজ at 1252px, ক্যালেন্ডার at 988px) so the whole scroll is visible at once. In the app these are ordinary scrolling screens. Frames drawn at 844px are roughly one viewport. Never hardcode the artboard heights.

---

## Design Tokens

Replace the palette in `lib/src/core/constants/app_colors.dart`. A ready-to-use Dart file is included as **`app_colors_dusk.dart`** — it preserves the existing `AppColors.<name>` call-site style so the rest of the app keeps compiling.

### Colors

| Token | Hex | Role |
|---|---|---|
| `duskDeep` | `#06312F` | Hero gradient start; bottom nav bar; primary dark surface |
| `duskMid` | `#0B4A45` | Hero gradient end; icon ink on sage; "done" tracker fill |
| `duskLight` | `#14655A` | Hero gradient third stop (home only) |
| `gold` | `#C9A227` | **The accent.** Primary action, live value, active tab, current-prayer marker |
| `goldInk` | `#241A00` | Text/icons **on** gold |
| `goldInkSoft` | `#3A2B00` | Secondary text on gold |
| `goldOnIvory` | `#8A6A0F` | Gold-as-text on ivory/white grounds (≈4.6:1) |
| `goldOnCanvas` | `#7A5C00` | Gold-as-text on the darker `#EFE9DE` ground |
| `goldBright` | `#E9CE73` | Gold text/icons on deep teal |
| `goldTint` | `#FFF4D6` | Gold chip / streak-pill background on light |
| `goldTintCard` | `#FFF9E8` | Selected-card background on light |
| `goldTintBorder` | `#F0DFA8` | 1px border on gold-tinted cards |
| `ivory` | `#FBF8F3` | Page background (in-app) |
| `canvas` | `#EFE9DE` | Design-board background only — **not an app color** |
| `surface` | `#FFFFFF` | Cards |
| `sage` | `#DCE8E2` | Resting tint: icon chips, secondary date card |
| `sageInk` | `#2F4B47` | Body text on sage |
| `ink` | `#12211F` | Primary text |
| `inkBody` | `#283634` | Long-form body text |
| `inkSecondary` | `#3D4A47` | Secondary text |
| `inkMuted` | `#5E6B68` | Muted labels, captions (≈5.9:1 on white — this is the **minimum** muted step; do not go lighter for text) |
| `onDeepPrimary` | `#F5EFE1` | Primary text on deep teal |
| `onDeepMuted` | `#9EC4BC` | Muted text on deep teal |
| `dashedBorder` | `#B6C4C0` | "Not yet" tracker outline |
| `trackEmpty` | `#EDE7DA` | Empty cell in tracker/heatmap grids |
| `trackPartial` | `#A8C9C2` | Partial day in tracker grid |
| `trackPartialStrong` | `#5E9B90` | Near-complete day in tracker grid |
| `switchOff` | `#D8D2C4` | Switch track, off |
| `danger` | `#A33B12` | Negative amounts (zakat deductions) |

**Time-of-day hero gradients** (component sheet, bottom of the board). All are `LinearGradient` at ~165°, i.e. `begin: Alignment.topCenter, end: Alignment.bottomRight`-ish; use `AlignmentDirectional(-0.35, -1)` → `AlignmentDirectional(0.35, 1)`:

| Window | Stops |
|---|---|
| Fajr (before sunrise) | `#101B4A` → `#2B3E7A` |
| Dhuhr / Asr (day) | `#06312F` → `#0B4A45` → `#14655A` |
| Maghrib (sunset) | `#3D1608` → `#7A3B12` → `#C77A2E` |
| Isha (night) | `#0A1220` → `#1E2A47` |

On the Maghrib theme, the on-hero colors change too: primary `#FFF3DC`, muted `#F0C79A`, accent `#FFD48A` (ink on it `#3D1608` / `#4A2405` / `#6B3708`).

**Ramadan mode** (frame ২০) uses the Maghrib/amber family throughout, not just in the hero: fills `#7A3B12`, accent `#FFD48A`, label ink `#8A4A0F`, dark ink `#3D1608`. It should read as a distinct season inside the app.

**Night reading mode** (frame ০৬): page `#0A1614`, card `#121E1C`, raised card `#152220`, border `#223330`, hairline `#1B2A28`, primary text `#F0EDE4`, body `#D6D2C6`, muted `#8FA6A1`, ayah-number chip `#1F302D` on `#9EC4BC`. Gold stays `#C9A227`.

### Spacing

Extend `AppValues`. Scale actually used: `3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 16, 18, 20, 22, 24, 26, 28, 34`.

Consistent applications:
- Screen horizontal padding: **18**
- Hero horizontal padding: **22**
- Card internal padding: **16–18**
- Gap between stacked cards: **9–10**
- Gap between card groups: **14–16**
- Bottom-nav outer padding: **14** horizontal, **16** bottom
- List-row vertical padding inside a grouped card: **11**

### Radii

| Token | Value | Applies to |
|---|---|---|
| `radiusDevice` | 38 | Device frame (design only) |
| `radiusHero` | 28–30 | Hero sheet **bottom corners only** (`BorderRadius.vertical(bottom: Radius.circular(28))`); 30 on হোম, 28 elsewhere |
| `radiusSheet` | 32 | Bottom sheets (top corners) |
| `radiusNav` | 26 | Floating bottom nav bar |
| `radiusCard` | 22–24 | Cards (24 for grouped/list cards, 22 for single-purpose cards) |
| `radiusCardSm` | 20 | Small tiles (quick access, date cards) |
| `radiusInner` | 18–19 | Rows inside a card, active nav pill (19) |
| `radiusChip` | 999 | Chips, pills, switches, streak badges |
| `radiusIconChip` | 12–14 | Square icon chips (12 in list rows, 13–14 in cards) |
| `radiusGridCell` | 4–6 | Tracker/heatmap cells |

**No sharp corners anywhere.** The one exception is the tracker heatmap cells at 4–6.

### Shadows

| Token | Value |
|---|---|
| `shadowCard` | `BoxShadow(color: Color(0x0D092A28), blurRadius: 12, offset: Offset(0, 3))` — ~`rgba(9,42,40,0.04)` |
| `shadowCardRaised` | `blurRadius: 16, offset: Offset(0, 4)`, ~5% |
| `shadowNav` | `BoxShadow(color: Color(0x4D06312F), blurRadius: 26, offset: Offset(0, 10))` — ~`rgba(6,49,47,0.3)` |
| `shadowGold` | `BoxShadow(color: Color(0x59C9A227), blurRadius: 26, offset: Offset(0, 10))` — ~`rgba(201,162,39,0.35)` |
| `shadowSheet` | `blurRadius: 34, offset: Offset(0, -12)`, ~16% — bottom sheets, cast upward |

One shadow per element. Never stack.

### Typography

Three families, each with one job:

| Family | Used for | Weights needed |
|---|---|---|
| **Anek Bangla** | All Bangla interface text | 400, 500, 600, 700, 800 |
| **Plus Jakarta Sans** | Latin text, and **all large numerals** (countdowns, counters, degrees) | 400, 600, 700, 800 |
| **Amiri** | Arabic — Quran text, hadith, dua, surah names | 400, 700 |

The current app uses Figtree via `google_fonts`. **Bundle these three instead of fetching at runtime** — the audience includes users on poor connections, and Amiri is needed offline for the Quran reader. Add `.ttf` files under `assets/fonts/` and declare them in `pubspec.yaml`; drop the `google_fonts` dependency for these.

Type scale as used (size / weight / line-height):

| Role | Size | Weight | LH | Notes |
|---|---|---|---|---|
| Hero prayer name | 46 | 700 | 1.15 | Anek Bangla |
| Hero countdown (নামাজ, রমজান) | 52–58 | 800 | 1.05 | Plus Jakarta Sans, `tabular-nums`, letter-spacing −0.02em to −0.03em |
| Tasbih counter | 116 | 800 | 0.92 | letter-spacing −0.04em |
| Qibla degrees | 46 | 800 | 1.0 | tabular-nums |
| Screen title (in hero) | 19–21 | 700 | — | Anek Bangla |
| Section heading in card | 15.5 | 700 | — | |
| List row title | 15–16 | 700 | — | |
| Body / translation | 14 | 400 | 1.8 | Anek Bangla |
| Row subtitle | 11.5 | 400/600 | — | `inkMuted` |
| Overline label | 11.5–12 | 700 | — | letter-spacing 0.08–0.12em; gold on dark, `inkMuted` on light |
| Chip / tab label | 10.5–12.5 | 600/700 | — | |
| Arabic — Quran ayah | 25 | 400 | 2.1 | Amiri, RTL, right-aligned |
| Arabic — hadith/dua | 23–24 | 400 | 1.9–2.0 | Amiri |
| Arabic — bismillah | 23 | 400 | 1.9 | Amiri, centered |
| Arabic — word-by-word | 25 | 400 | 1.5 | Amiri, with 11px gloss beneath |
| Arabic — surah name in list | 21 | 400 | — | Amiri |

**Floors, non-negotiable** (the primary audience includes users 45+ with low digital literacy):
- Bangla body text never below **12.5px**
- No text below **12px** anywhere, including secondary numerals
- Tap targets ≥ **44px**
- Text contrast ≥ **4.5:1**; large display type ≥ **3:1**

### Numerals

Every number the user reads is rendered in **Bengali numerals** — times, counters, ayah numbers, dates, currency, percentages, degrees. The codebase already has `formatNumberWithLocale(value, locale)` in the Quran module; promote it to `lib/src/core/utils/` and route all display numbers through it. Under the `en` locale it must fall back to Western digits.

Currency is `৳` **after** the amount with a space: `৫৬,৫০০ ৳`. Grouping is the Indian system (lakh/crore): `২২,৬০,০০০`.

---

## Assets

### Khatim star pattern

The eight-point *khatim* star texture in every hero. Included in this bundle as **`assets/khatim.svg`** — a 56×56 tile: two 28×28 squares centred, one rotated 45°, stroked at 1.1px, no fill.

Apply as a tiled overlay **inside** the hero, above the gradient and below the content:

```dart
Positioned.fill(
  child: Opacity(
    opacity: 0.13, // 0.12 on most heroes, 0.14–0.16 on onboarding + Ramadan
    child: DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/patterns/khatim.png'),
          repeat: ImageRepeat.repeat,
        ),
      ),
    ),
  ),
)
```

Two implementation options, in order of preference:

1. **Raster the SVG** to `khatim@1x/2x/3x.png` at 56/112/168 px with the stroke in `#F5EFE1` (or `#FFF3DC` for the Maghrib/Ramadan heroes) on transparent, then tile with `ImageRepeat.repeat`. Cheapest to render, and tiling is exact.
2. **`CustomPainter`** drawing the two squares — avoids assets and recolors freely, but you must handle tiling yourself.

Do **not** use `flutter_svg` with `repeat` — it will not tile.

The pattern must be clipped by the hero's bottom radius (`ClipRRect` around the whole hero).

### Icons

The designs are drawn in **Lucide**. The codebase already depends on **`phosphor_flutter`**. **Keep Phosphor** — do not add a second icon package. Mapping for every icon used:

| Lucide (design) | Phosphor (build) |
|---|---|
| `house` | `PhosphorIconsRegular.house` / `Fill` when active |
| `book-open` | `bookOpenText` |
| `clock` | `clock` |
| `circle-dot` | `handsPraying` (keep the existing tasbih icon) |
| `layout-grid` | `squaresFour` |
| `map-pin` | `mapPin` |
| `bell` / `bell-ring` | `bell` / `bellRinging` |
| `hourglass` | `hourglass` |
| `flame` | `flame` |
| `check` / `check-check` | `check` / `checks` |
| `plus` / `minus` | `plus` / `minus` |
| `play` / `pause` | `play` / `pause` |
| `skip-back` / `skip-forward` | `skipBack` / `skipForward` |
| `repeat-1` / `repeat` | `repeatOnce` / `repeat` |
| `list` | `listBullets` |
| `mic` | `microphone` |
| `audio-lines` | `waveform` |
| `volume-2` / `volume-x` | `speakerHigh` / `speakerX` |
| `bookmark` | `bookmarkSimple` |
| `pen-line` | `pencilSimple` |
| `book-marked` | `bookBookmark` |
| `book` | `book` |
| `copy` | `copy` |
| `image-down` | `imageSquare` |
| `share-2` | `shareNetwork` |
| `ellipsis` / `ellipsis-vertical` | `dotsThree` / `dotsThreeVertical` |
| `type` | `textAa` |
| `moon` / `moon-star` | `moon` / `moonStars` |
| `sun` / `sunrise` / `sunset` | `sun` / `sunHorizon` / `sunHorizon` (flip) |
| `cloud-sun` | `cloudSun` |
| `compass` | `compass` |
| `landmark` | `mosque` |
| `navigation` | `navigationArrow` |
| `map` | `mapTrifold` |
| `calendar` | `calendarBlank` |
| `calculator` | `calculator` |
| `hand-heart` | `handHeart` |
| `hand-coins` | `handCoins` |
| `heart-pulse` | `heartbeat` |
| `users` | `users` |
| `plane` | `airplaneTilt` |
| `shield` / `shield-check` | `shield` / `shieldCheck` |
| `sparkles` | `sparkle` |
| `scroll-text` | `scroll` |
| `utensils` / `utensils-crossed` | `forkKnife` |
| `search` | `magnifyingGlass` |
| `settings-2` | `slidersHorizontal` |
| `sliders-horizontal` | `faders` |
| `history` | `clockCounterClockwise` |
| `vibrate` | `vibrate` |
| `target` | `target` |
| `rotate-ccw` | `arrowCounterClockwise` |
| `refresh-cw` | `arrowsClockwise` |
| `arrow-left` / `arrow-right` | `arrowLeft` / `arrowRight` |
| `chevron-left` / `chevron-right` | `caretLeft` / `caretRight` |
| `circle` / `circle-check-big` | `circle` / `checkCircle` |
| `circle-arrow-down` | `arrowCircleDown` |
| `circle-help` | `question` |
| `info` | `info` |
| `triangle-alert` | `warning` |
| `x` | `x` |
| `languages` | `translate` |
| `hard-drive-download` | `downloadSimple` |
| `layout-dashboard` | `squaresFour` |
| `signal` / `wifi` / `battery-full` | status bar — **do not build**, the OS draws these |

Icon sizes: 17–19 in list rows and chips, 20–21 in nav and hero actions, 19 in card icon-chips, 23–34 in feature/onboarding marks.

### Photography

None. The design uses no photographs or illustrations — one geometric texture and type only. **Do not add stock mosque imagery.**

---

## Screens / Views

21 frames. Frame numbers below match the labels on the board.

### Global chrome

**Bottom navigation** (frames ০১, ০৩, ০৪, ০৭, ২১) — **new component, replaces `BottomNavigationBar` in `dashboard_view.dart`.**

- A floating bar: `Container` with `duskDeep` fill, radius 26, `shadowNav`, `padding: EdgeInsets.all(8)`, sitting inside `padding: EdgeInsets.fromLTRB(14, 10, 14, 16)`.
- Five equal `Expanded` items. Each: icon 20px + label 10.5px, `column`, `gap 3`.
- **Inactive**: `onDeepMuted` (#9EC4BC), weight 600.
- **Active**: the item gets a `gold` fill, radius 19, and its icon+label go `goldInk` (#241A00), weight 700. The pill is the item's full cell — not a bar or an underline.
- Tabs in order: হোম (`house`), কুরআন (`bookOpenText`), নামাজ (`clock`), তাসবিহ (`handsPraying`), আরও (`squaresFour`).
- `dashboard_controller.dart`'s `currentIndex` grows from 4 to 5 values; page list becomes `[HomeView, QuranView, PrayerTimesView, TasbihView, MoreView]`. `QiblaView` leaves the tab list and is reached by route.
- **Delete the language drawer** in `dashboard_view.dart`. Language moves into আরও → ভাষা.

**Hero sheet** — the shared header on most screens.

- `ClipRRect(borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)))` wrapping a `Container` with the time-of-day `LinearGradient`, the tiled khatim overlay, and content in a `Stack`.
- Contains (top to bottom, varying by screen): status-bar spacing via `SafeArea`, a title/back row, then screen-specific content.
- Text on it is `onDeepPrimary`; secondary is `onDeepMuted`; accents are `gold`/`goldBright`.
- Icon buttons in the hero are 36×36, radius 13, fill `Colors.white.withOpacity(0.12)`, icon `onDeepPrimary`.

**Grouped list card** — used on নামাজ, আজান, যাকাত, আরও.

- `Container`: `surface` fill, radius 24, `shadowCardRaised`, `padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8)`.
- Children are rows with `padding: EdgeInsets.symmetric(vertical: 11, horizontal: 10)`, radius 18 when tinted.
- **No dividers between rows.** Grouping is done by the card, spacing by padding.
- Leading icon chip: 36×36, radius 12, `sage` fill, `duskMid` icon.

---

### ০১ · হোম (Home) — `module/home/views/home_view.dart`

**Purpose:** answer "how long until the next prayer", then offer the day's five habits.

**Layout:** hero sheet → scrolling ivory content → floating nav. Artboard 1252px; real screen scrolls.

Hero, in order:
1. Greeting row: `আসসালামু আলাইকুম` (12.5/600, `onDeepMuted`) over location `ধানমন্ডি, ঢাকা` (16/700, `onDeepPrimary`, with a 14px gold `mapPin` leading). Right: 38×38 bell button, radius 14, with a 7px gold dot badge at top-right when unread.
2. Centered block: overline `পরের নামাজ` (12/700, 0.12em, `gold`) → prayer name `আসর` (46/700, `onDeepPrimary`) → Arabic name `العصر` (Amiri 20, `onDeepMuted`).
3. Countdown pill: centered, `gold` at 18% opacity fill, 1px `gold` at 50% border, radius 999, padding 8×16, containing a 15px `hourglass` in `goldBright` + `১ ঘণ্টা ২৪ মিনিট বাকি` (15/700, `#F2E4B8`).
4. Sub-line: `ওয়াক্ত শুরু বিকাল ৪:১২ · জামাত ৪:৩০` (12.5, `onDeepMuted`).
5. Five-prayer strip: 5 equal cells, each name (11.5/600) over time (14/700). The **current** cell has a `gold` fill, radius 16, ink `goldInkSoft`/`goldInk`. Others are transparent with `onDeepMuted`/`onDeepPrimary`.

Body:
6. Date row: two cards side by side — `আজ / ৬ সেপ্টেম্বর` (white, radius 20, flex 1) and `হিজরি / ২৪ রবিউল আউয়াল` (**`sage` fill**, radius 20, flex 1.25, ink `duskDeep`, label `#456660`).
7. **Prayer tracker card** (new): title `আজকের নামাজ` + a streak pill on the right (`goldTint` fill, `#7A5C00` ink, radius 999, 12px `flame`, `টানা ১২ দিন`). Below, five equal columns, each a 44px circle + an 11.5px label:
   - **done** → `duskMid` fill, `onDeepPrimary` check
   - **due now** → `gold` fill, `goldInk` plus-icon, label `#7A5C00` weight 700
   - **not yet** → transparent, **2px dashed `dashedBorder`**, `inkMuted` minus-icon
   - Tapping a circle logs/unlogs that prayer. This is the primary new interaction on Home.
8. **Continue reading card**: `duskMid → duskLight` gradient, radius 22. Overline `পড়া চালিয়ে যান` in `gold`, surah name 19/700 in `onDeepPrimary`, `আয়াত ৩২ · আজকের লক্ষ্যের ৬০%` in `onDeepMuted`, then a 5px progress track (`white` 22% / `gold` fill, radius 999). Trailing: 50px gold circle with a `play` icon.
9. **Daily hadith card**: white, radius 22. Overline `আজকের হাদিস` in `goldOnIvory` + a trailing bookmark. Arabic in Amiri 23/1.9 RTL right-aligned in `duskDeep`, Bangla translation 14/1.75 in `inkBody`, source 11.5/600 in `inkMuted`.
10. **Quick access**: overline `দ্রুত প্রবেশ`, then 4 equal tiles (white, radius 20) each with a 38×38 `sage` icon chip (radius 14, `duskMid` icon) over a 11.5/600 label: কিবলা, মসজিদ, দুআ, যাকাত.

**Data:** all of it already exists in `HomeController` + `PrayerTimesController` except the tracker (new) and the reading-plan percentage (new).

---

### ০২ · হোম, মাগরিব theme

Same screen, demonstrating the **time-of-day hero**. Only the hero gradient and its on-colors change; the body is identical. Also shows a contextual card that appears only in the Maghrib window: `ইফতারের দুআ` (white, radius 22, `#FFF0DB` icon chip with `#8A4A0F` `forkKnife`, chevron trailing).

Note the copy adapts: when a prayer window is *current* rather than upcoming, the overline becomes `এখনই মাগরিবের ওয়াক্ত` and the countdown pill counts to the **next** prayer (`ইশা শুরু ১ ঘণ্টা ১২ মিনিটে`).

**Implementation:** a `DuskTheme.forPrayerWindow(PrayerName current)` helper returning the gradient + on-color set. Select on the current window from `PrayerTimesController.dayTimes`. Cross-fade over **400ms `Curves.easeInOut`** when the window turns over.

---

### ০৩ · নামাজ (Prayer times + tracker) — `module/prayer_times/views/prayer_times_view.dart`

**Purpose:** the full day, plus jamaat times, plus the month's tracking. This becomes tab 3.

Hero: title row `নামাজ` + two 36px icon buttons (`bellRinging`, `slidersHorizontal`) → date pager (`caretLeft` / `আজ · রবিবার` + `২৪ রবিউল আউয়াল ১৪৪৮` / `caretRight`) → centered overline `আসরের বাকি` in `gold` + countdown `১:২৪:০৬` at 52/800 tabular-nums.

Body:
1. **Prayer list** — one grouped list card, six rows. Each row: 36px icon chip (per-prayer icon and tint, see below) → name 15/700 + subtitle `জামাত ৫:০০ · শেষ ৫:৪৮` 11.5 `inkMuted` → time 15.5/700 → a 30px tracker circle.
   - Per-prayer icon chips: ফজর `sunHorizon`/`sage`, সূর্যোদয় `sun`/`#F1EDE4` + `inkMuted` (this row is **informational** — no tracker circle, muted text, no jamaat line), যোহর `sun`/`sage`, আসর `cloudSun`/**`gold` chip**, মাগরিব `sunHorizon`/`#FFF0DB` + `#8A4A0F`, ইশা `moon`/`#E4E4F2` + `#3B3A6B`.
   - The **next** prayer's row gets a `goldTintCard` fill, 1px `goldTintBorder`, radius 18, and its text goes `#5C4400`/`#7A5C00`.
   - Tracker circles: done → `duskMid` + check; due → 2px `gold` ring, empty; future → 2px dashed `dashedBorder`.
2. **Month tracker card**: title `সেপ্টেম্বর ট্র্যাকার` + `১৪২ / ১৫০` in `goldOnIvory`. A 15-column heatmap grid (2 rows = 30 days), cells `aspect-ratio: 1`, radius 4, gap 4. Fills: `duskMid` (5/5), `trackPartialStrong` (4/5), `trackPartial` (2–3/5), `gold` (today), `trackEmpty` (future). Legend row beneath at 11.5px.
3. Two settings rows in a grouped card: `হিসাব পদ্ধতি ও সমন্বয়` (trailing `করাচি`) and `আজান ও রিমাইন্ডার`.

**Replaces** the current bottom-sheet settings — calculation method, madhab and offsets move to a pushed screen, not a sheet.

**New data:** jamaat time per prayer (user-editable per masjid, see ১৮), and the tracking store.

---

### ০৪ · কুরআন (index) — `module/quran/views/quran_view.dart`

Hero: title `কুরআন` + `magnifyingGlass` + `bookmarkSimple` → **last-read card** (gold at 14% fill, 1px gold at 40%, radius 22): overline `শেষ পড়া`, `আল-কাহফ · আয়াত ৩২` at 21/700, `আজকের লক্ষ্যের ১২ / ২০ আয়াত হয়েছে`, trailing 46px gold circle with `arrowRight`.

Body: three pill tabs (সূরা / পারা / বুকমার্ক) — active is `duskDeep` fill with `onDeepPrimary`; inactive white with `inkSecondary` and `shadowCard`. Then the surah list: white cards, radius 20, `shadowCard`, gap 9. Each row: 34px `sage` number chip (radius 11, `duskMid`, 13.5/800) → name 15.5/700 + `মাক্কি · ৭ আয়াত` 11.5 `inkMuted` → optional 16px `checkCircle` in `goldOnIvory` when downloaded → Arabic name in Amiri 21, `duskMid`.

Keep the existing three tabs from `para_surah_list_view.dart`; **বুকমার্ক is the new third tab**.

---

### ০৫ · সূরা পাঠ, day — `module/quran/views/surah_detail_view.dart`

**Not a hero screen** — the reading surface is ivory so the text is the subject.

Top bar: ivory, 1px `#E7E0D2` bottom border. `arrowLeft` → centered `আল-কাহফ` 16/700 + `১৮ · ১১০ আয়াত · মাক্কি` 11 `inkMuted` → `textAa` → `moon` (night toggle). Beneath it a 4px progress track (`trackEmpty` / `gold`, right-rounded) showing position in the surah.

Body:
- **Bismillah card**: `duskDeep → duskMid` gradient, radius 22, Amiri 23 centered in `onDeepPrimary`.
- **Playing ayah**: `goldTintCard` fill, 1px `goldTintBorder`, radius 22. Header: gold number chip (radius 999, `goldInk`, 12/800) + `waveform` icon + `বাজছে` 11.5/700 in `#7A5C00`, trailing bookmark + `dotsThree`. Then Amiri 25/2.1 RTL right-aligned in `duskDeep` with **the currently-sung word wrapped in a `gold` background, radius 6, 5px horizontal padding**. Then translation 14/1.8 in `inkBody`.
- **Normal ayah**: white, radius 22, `shadowCard`. `sage` number chip with `duskMid` ink. Same Arabic/translation treatment, no highlight.

**Player bar** (fixed at bottom, not scrolling): `duskDeep`, radius 28, `shadowNav`, margin 14, padding 14×18. Row 1: 15px `microphone` in `gold` + reciter name 12.5/600 in `onDeepPrimary` + speed `১.০×` 11.5/700 in `goldBright` + `arrowCircleDown` (or `checks` in `goldBright` when downloaded). Row 2, `spaceBetween`: `repeatOnce` (gold when active) · `skipBack` · **54px gold circle play/pause** · `skipForward` · `listBullets`.

**Behaviour change from the current build:** tapping the ayah **body no longer starts playback** — it fires by accident while reading. Playback starts from the player bar or the ayah's long-press sheet (frame ১৩). Tapping an ayah body does nothing; long-press opens the sheet.

---

### ০৬ · সূরা পাঠ, night + word-by-word

Same structure on the night palette (values in Design Tokens). Adds **word-by-word mode**: the ayah's Arabic becomes a `Wrap` (RTL, spacing 12, runSpacing 10) of per-word columns — Amiri 25 over an 11px Bangla gloss in `#8FA6A1`. The active word's column gets a `gold` fill, radius 12, padding 5×10, with its Arabic in `goldInk` and gloss in `goldInkSoft`.

Toggled from the `textAa` menu; a per-user preference. Only render word-by-word when word-level timing data is available for the selected reciter — otherwise fall back to the whole-ayah highlight of frame ০৫.

---

### ০৭ · তাসবিহ — `module/tasbih/views/tasbih_view.dart`

**Split background:** `duskDeep → duskMid` gradient for the top ~40%, ivory below. In Flutter: a `Stack` with a full-bleed gradient `Container` sized to 40% and the ivory page beneath, or a single gradient with a hard stop.

Hero: title `তাসবিহ` + `clockCounterClockwise` + a **gold-filled** `vibrate` button (active state) → preset chips row (`সুবহানাল্লাহ` active = gold pill; others = white-at-14% pills) → centered Amiri 36 `سُبْحَانَ اللَّه` + `সুবহানাল্লাহ · ৩৩ বার` in `onDeepMuted`.

Counter card, overlapping the gradient edge by −18px: white, **radius 32**, padding 26×22, `shadow: 0 12px 34px rgba(9,42,40,0.1)`. Contents: count `২৭` at 116/800 in `duskDeep`, tabular-nums, letter-spacing −0.04em → a progress row `০ [track] ৩৩` with an 8px track (`trackEmpty`/`gold`, radius 999) → three stat tiles (radius 18): আজ মোট / রাউন্ড on `#F5F2EA`, টানা on `goldTint` with `#7A5C00`/`#5C4400`.

Action row: 58px white circle `arrowCounterClockwise` (reset) · **the count button** (flex, `gold`, radius 30, padding 22 vertical, `plus` 28 + `গণনা করুন` 14/700, `shadowGold`) · 58px white circle `target` (set goal).

**Interaction:** the whole counter card should also be tappable to increment (thumb reach), with `HapticFeedback.selectionClick()` per tap and `HapticFeedback.mediumImpact()` on completing a round of 33.

---

### ০৮ · কিবলা — `module/qibla/views/qibla_view.dart`

**Full-bleed `duskDeep`** with the khatim texture at 10% over the whole screen (not just a hero).

Centered: three concentric circles — 300px with a 1px `#9EC4BC` at 35% border, 238px at 22%, then a 170px disc of `white` at 5% holding `২৭৮°` at 46/800 in `onDeepPrimary` over `কিবলার দিক` 12.5 in `onDeepMuted`.

- Cardinal letters at the 300px ring's edges: **N in `gold` 13/800**, S/E/W in `#A8C2BC` 13/700.
- **Needle**: a 3px-wide, 132px-tall bar from centre, `gold → gold at 15%` vertical gradient, radius 999, rotated to the qibla bearing, `transformOrigin` at its base.
- **Kaaba marker**: a 48px `gold` circle with a `mosque` icon in `goldInk`, positioned on the ring at the bearing angle.
- Rotate the **dial**, not the phone frame; the needle points to the bearing relative to device heading.

Below: an aligned-state pill — `gold` fill, radius 999, `check` + `সোজা সামনে — কিবলা ঠিক আছে` 15/700 in `goldInk`. Shown only within ±5° of the bearing; otherwise show a muted `white`-at-8% pill reading the turn direction. Add `HapticFeedback.mediumImpact()` on entering alignment.

Then two stat cards (`white` at 8%, radius 20): মক্কা থেকে দূরত্ব `৪,৭৯২ কিমি`, নির্ভুলতা `উচ্চ` (from the compass accuracy sensor).

Footer: `arrowsClockwise` + the figure-8 calibration hint in `onDeepMuted` 12.5/1.7.

---

### ০৯–১১ · Onboarding (new) — new module `module/onboarding/`

Runs once, after splash, before dashboard. Three pages, `PageView`, with a 3-dot indicator (active dot is a 26×5 `gold` rounded bar; inactive 8×5 `#CFC8B8`).

**০৯ · স্বাগতম** — a tall hero (gradient + texture at 16%, bottom radius 34): a 72px `gold` rounded-square (radius 26) with a 34px `moonStars` in `goldInk`, then Amiri 30 `المتقي` in `goldBright`, `আল মুত্তাকী` 40/700 in `onDeepPrimary`, and a two-line subtitle in `onDeepMuted`. Below on ivory: overline `ভাষা বাছুন · LANGUAGE`, then two side-by-side language cards — selected is `duskDeep` fill with a `gold` check + `onDeepPrimary` label; unselected is white with `inkSecondary`. Then a note, then the primary button.

**Primary button pattern** (all three pages): `gold`, radius 24, padding 17×22, `shadowGold`, **label flush left at 16/700 in `goldInk` with the icon pushed right by a `Spacer`**.

**১০ · অবস্থান** — earns the permission before the system dialog. 66px `sage` rounded-square with a 30px `mapPin`, heading `সঠিক সময়ের জন্য / অবস্থান দরকার` 29/700, body explaining the data stays on-device, then three white reason cards (radius 20, `sage` icon chips): accurate times, qibla, nearby masjid + jamaat. Two actions: primary `অবস্থানের অনুমতি দিন`; secondary white card `শহর নিজে বাছুন` with trailing `ঢাকা, চট্টগ্রাম…` — **this fallback is required**, many users decline location.

**১১ · রিমাইন্ডার সেটআপ** — heading + a grouped card of the five prayers, each with time and a state pill (`আজান` = `duskDeep`/`onDeepPrimary`; `নীরব` = `#EFEAE0`/`inkSecondary`; `বন্ধ` = same muted style). Then the **exact-alarm warning card**: `goldTintCard` fill, 1px `goldTintBorder`, radius 24, `warning` icon in `goldOnIvory`, title `ঠিক সময়ে আজান শুনতে` in `#5C4400`, body about battery-saver exclusion in `#6B5100`, and an underlined `সেটিংসে যান` in `goldOnIvory`. Primary button `শেষ করুন`.

This screen is where you request `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM` and battery-optimisation exclusion — deep-link to the OEM settings intent.

---

### ১২ · আজান ও রিমাইন্ডার (new screen) — `module/notifications/`

Hero: back + title only.

Body:
1. Overline `প্রতি ওয়াক্তে` → grouped card, five rows (per-prayer icon chips as in ০৩), each: name 15/700 + current setting as subtitle (`মিশারি রশিদ · ৫ মিনিট আগে`, `মক্কা আজান`, `নীরব বিজ্ঞপ্তি`) + chevron. Each pushes a per-prayer detail screen (adhan sound picker, pre-adhan offset, silent/off).
2. **Exact-alarm status card** — `sage` fill, radius 24, `shieldCheck` in `duskMid`, title `সঠিক সময়ে বাজার অনুমতি`, body `Exact alarm ও ব্যাটারি ছাড় — দুটোই চালু আছে।` in `sageInk`, trailing `checkCircle`. **This card sits above the toggle group deliberately** — it decides whether the azan fires at all, so it must not be the thing that scrolls away. When either permission is missing, switch it to the `goldTintCard` warning treatment from frame ১১ with a `সেটিংসে যান` action.
3. Overline `অন্যান্য` → grouped card of three switch rows: জুমার রিমাইন্ডার (on), তাহাজ্জুদ ডাক (off), আজকের হাদিস বিজ্ঞপ্তি (on).
4. Footer: a white card `আজানের শব্দ পরীক্ষা করুন` with a `play` icon — plays the selected adhan at notification volume.

**Switch component:** 46×26 track, radius 999, `gold` when on / `switchOff` when off; 20px white knob inset 3. Use a custom widget, not `Switch.adaptive` — the Material switch will not match.

---

### ১৩ · আয়াত অ্যাকশন (long-press sheet)

A `showModalBottomSheet` over a 30%-opacity reading surface. Sheet: ivory, top radius 32, `shadowSheet`, with a 44×5 `#D8D2C4` grab handle.

Header: a `gold` reference chip `১৮ : ৩২` (radius 999, `goldInk`, 12/800) + `আয়াত ৩২` 16/700 + a 32px `#EFEAE0` circle close button.

Then a grouped card of six actions, each a 36px icon chip + a 14.5/600 label:
- বুকমার্ক করুন — `bookmarkSimple`, **`goldTint` chip with `goldOnIvory` icon**
- নোট লিখুন — `pencilSimple`, `sage`
- এখান থেকে শুনুন — `play`, `sage`
- তাফসির দেখুন — `bookBookmark`, `sage`, trailing `ইবনে কাসির`
- কপি করুন — `copy`, `sage`
- ছবি বানিয়ে শেয়ার করুন — `imageSquare`, `sage`

The bookmark action's gold chip marks it as the most-used. Bookmarks and notes are new persistence (see State Management).

---

### ১৪ · দৈনিক পাঠ পরিকল্পনা (new) — `module/quran/`

Hero: back + title + `slidersHorizontal` → centered overline `আজকের লক্ষ্য` in `gold` → `১২` at 56/800 beside `/ ২০ আয়াত` at 20/700 in `onDeepMuted` → a 7px progress track (`white` 20% / `gold`) → `আর ৮ আয়াত — প্রায় ৪ মিনিট` 13/600 in `onDeepMuted`.

Body:
1. **30-day heatmap card**: white, radius 24. Overline `গত ৩০ দিন`, then a 10-column grid (3 rows), cells radius 5, gap 5. Same fill logic as ০৩; today is a 2px `gold` outline, empty.
2. Overline `পরিকল্পনা বাছুন` → four选 cards (radius 22): selected is `goldTintCard` + `goldTintBorder` with `#5C4400`/`#6B5100` text and a `checkCircle` in `goldOnIvory`; unselected is white with a `circle` outline in `dashedBorder`. Options: দিনে ২০ আয়াত (খতম হবে প্রায় ১১ মাসে), দিনে ১ পারা (রমজানে খতম), দিনে ১০ মিনিট (সময় ধরে, আয়াত নয়), শুক্রবারে সূরা কাহফ (সাপ্তাহিক অভ্যাস).
3. Primary button `আজকের পাঠ শুরু করুন` → opens the reader at the plan's next position.

---

### ১৫ · হাদিস — `module/hadith/views/hadith_view.dart`

Hero: back + title + search + bookmark → **hadith-of-the-day card inside the hero**: `gold` at 14% fill, 1px `gold` at 40%, radius 24. Overline `আজকের হাদিস` in `goldBright`, Amiri 24/1.9 RTL in `onDeepPrimary`, Bangla 15/1.75/500 in `onDeepPrimary`, then a 1px `gold`-at-35% rule and a footer row: source 12/700 in `onDeepMuted` + bookmark/share/image-export icons in `goldBright`.

Body: overline `গ্রন্থ` → white cards (radius 22, gap 9), each with a `sage` `book` chip → collection name 15.5/700 + `৯৭ অধ্যায় · ৭,৫৬৩ হাদিস` → chevron. Collections: সহিহ বুখারি, সহিহ মুসলিম, সুনানে আবু দাউদ, জামে তিরমিজি. The last card, **৪০ হাদিস — নববি**, uses a `goldTint` chip with a `sparkle` icon and a `gold` pill `শুরু করুন` instead of a chevron — it is the curated entry point for new users.

The app already bundles `assets/data/hadith_bundle.json`; the per-collection browse is new.

---

### ১৬ · দুআ সংকলন (new) — new module `module/dua/`

Hero: back + title + search + bookmark → contextual chips row (`ঘুমানোর আগে` active gold pill; `খাওয়ার সময়`, `সফরে` as white-at-14% pills). **The active chip is chosen by time of day**, not by the user — the overline in the body is `এই মুহূর্তে দরকারি`.

Body:
1. **Featured dua card**: white, radius 24. Title 15.5/700 + a 34px `gold` circle `speakerHigh` button + a bookmark. Amiri 24/2.0 RTL in `duskDeep`. **Bangla transliteration** 13/700 in `goldOnIvory`. Translation 13.5/1.75 in `inkBody`. Source 11.5/600 in `inkMuted`.
   - The transliteration line is important — much of the audience reads Arabic slowly but wants to recite correctly.
2. Overline `বিভাগ` → a 2-column grid of white cards (radius 22, gap 10), each a 38px `sage` icon chip → category 14/700 → count 11.5 `inkMuted`: সকাল-সন্ধ্যা (২৪টি), নামাজের দুআ (১৮টি), রোগ ও কষ্টে (১৫টি), পরিবার (১২টি), সফর (৯টি), আশ্রয় প্রার্থনা (১৪টি).

New content: a `assets/data/dua_bundle.json` with Arabic, Bangla transliteration, Bangla translation, source, category, and an audio reference per dua.

---

### ১৭ · যাকাত — `module/zakat/views/zakat_view.dart`

Hero: back + title + `clockCounterClockwise` (history) + `question` (help) → two `white`-at-8% stat cards: নিসাব (রূপা) `৭৮,৫০০ ৳`, রূপা / ভরি `২,১০০ ৳`. **These are live values** — fetch current gold/silver rates, cache, and show the fetch date in the help sheet.

Body:
1. Overline `সম্পদ` → grouped card of five input rows: নগদ ও ব্যাংক, স্বর্ণ (with a `১২ ভরি` sub-label in the row), রূপা, ব্যবসার পণ্য, বিনিয়োগ ও শেয়ার. Each row: label 14/600 (flex) → amount 15/700 → `৳` 12 in `inkMuted`. Tapping a row opens a numeric input.
2. Overline `বাদ যাবে` → grouped card of two rows, ঋণ ও দেনা and বাকি খরচ, amounts prefixed `−` in **`danger`**.
3. A `আরেকটি খাত যোগ করুন` row: 30px `sage` circle `plus` + 14/700 label in `duskMid`.
4. **Total panel, pinned at the bottom** (not scrolling): `duskDeep → duskMid` gradient, radius 28, padding 18×20.
   - Sub-row: `মোট যাকাতযোগ্য সম্পদ` / `২২,৬০,০০০ ৳` at 12.5/600 in `onDeepMuted`
   - 1px `#9EC4BC`-at-30% rule
   - Overline `প্রদেয় যাকাত · ২.৫%` in `gold`, then `৫৬,৫০০ ৳` at 34/700 in `onDeepPrimary`, with a 46px `gold` circle `arrowRight`
   - Two `white`-at-12% buttons (radius 16): `সংরক্ষণ করুন`, `হিসাব শেয়ার`
   - Below nisab, replace the payable figure with `নিসাবের নিচে — যাকাত ফরজ নয়` and disable both buttons.

New: saved calculations year on year, and a shareable/printable summary.

---

### ১৮ · মসজিদ ও জামাত — `module/masjid_finder/views/masjid_finder_view.dart`

Hero (short): back + title + `mapTrifold`.

Then a **158px map strip**. The design shows an abstract placeholder — implement with your real map SDK. Markers: the user is an 18px `gold` circle with a 3px white border and a soft shadow; masjids are 12px `duskDeep` circles with 2px white borders. A white rounded pill bottom-left, radius 999, `shadowCard`: `৭টি মসজিদ · ১ কিমির মধ্যে`.

Filter chips: দূরত্ব (active, `duskDeep`), জামাতের সময়, জুমা (white + `shadowCard`).

List:
- **First/nearest card** is expanded: white, radius 24, 1px `goldTintBorder`, `shadowCardRaised`. Name 16/700 (flex) + distance 14/700 in `goldOnIvory`. Address + walk time 11.5 in `inkMuted`. Then a **jamaat strip**: 5 equal cells, radius 12, gap 5 — `#F5F2EA` fill with 10/600 `inkMuted` label over 12.5/700 time; the **next** jamaat cell is `gold` with `#3A2B00`/`goldInk`. Then two buttons: `পথ দেখান` (`duskDeep`, radius 16, `navigationArrow` + 13/700 `onDeepPrimary`) and `সময় ঠিক করুন` (`#F5F2EA`, `inkSecondary`).
- **Collapsed cards**: white, radius 24, `shadowCard` — name + distance, then `মোহাম্মদপুর · হেঁটে ৮ মিনিট · জুমা ১:১৫`.
- **Unknown-jamaat card**: same, but the subtitle reads `জামাতের সময় জানা নেই` and it carries an underlined 12.5/700 `আপনি জানেন? যোগ করুন` in `duskMid` — the crowd-sourcing entry point.

The product insight here: in Bangladesh the question is rarely "where is a masjid" but "when is jamaat". Jamaat time is the primary content, distance is secondary.

---

### ১৯ · হিজরি ক্যালেন্ডার — `module/calendar/views/calendar_view.dart`

Hero: back + title + `slidersHorizontal` → month pager (`caretLeft` / `রবিউল আউয়াল ১৪৪৮` 18/700 + `আগস্ট – সেপ্টেম্বর ২০২৬` 11.5 `onDeepMuted` / `caretRight`).

Body:
1. **Month card**: white, radius 26, padding 14×12. Weekday header (7 columns, 10.5/700) with **শুক্র in `goldOnIvory`** and the rest in `inkMuted`. Then a 7-column day grid, gap 3, each cell radius 14, padding 7 vertical, centered: **Hijri day at 15/700** over **Gregorian day at 12px in `inkMuted`**.
   - Today: `duskDeep` fill, `onDeepPrimary` Hijri, `onDeepMuted` Gregorian.
   - Event days: `goldTint` fill, `#5C4400` Hijri, `#7A5C00` Gregorian.
   - The Hijri number is the primary reading and the Gregorian is secondary, but **the Gregorian must stay ≥12px** — it is content, not decoration.
2. Overline `এ মাসের দিনগুলো` → event cards (radius 22, gap 9): the first (শবে বরাতের রাত) is `goldTintCard` + `goldTintBorder` with a `gold` `moonStars` chip; the rest are white with `sage` chips. The recurring-fast row (সোম ও বৃহস্পতিবারের রোজা) carries a switch.

Hijri conversion must be **user-adjustable by ±1 day** (in the `slidersHorizontal` settings) — local moon-sighting announcements in Bangladesh routinely differ from calculated dates, and getting this wrong on Eid is the single worst failure this app can have.

---

### ২০ · রমজান মোড (new) — new module `module/ramadan/`

Entered from হোম quick access / আরও. Available year-round but surfaced automatically during Ramadan.

Hero on the **amber** gradient with the texture at 15%: back + title + `shareNetwork` → centered overline `১২তম রোজা · ইফতার বাকি` in `#FFD48A` → countdown `১:৪১:০৮` at 58/800 in `#FFF3DC` → two cards: সেহরি শেষ (`white` at 14%, radius 20, `#F0C79A` label / `#FFF3DC` value) and **ইফতার (`#FFD48A` fill, `#6B3708` label / `#3D1608` value)** — the imminent one is filled.

The countdown switches subject at Maghrib: before sunset it counts to iftar, after it counts to the next sehri end.

Body:
1. **Roza tracker card**: white, radius 24. Title + `১১ / ১২ রাখা হয়েছে` in `#8A4A0F`. A 10-column grid (3 rows = 30 days), cells radius 6, gap 5, each containing its day number at 10/700 — kept (`#7A3B12` fill, `#FFF3DC` ink), missed (`#6E6A63` fill, `#FFF3DC` ink), today (`#FFD48A` fill, `#3D1608` ink), future (`trackEmpty`, no number). Legend at 11.5px.
2. Three rows (radius 22, gap 9): তারাবিহ (`#E4E4F2` chip, subtitle `আজ ২০ রাকাত · ধারাবাহিক ১১ দিন`, trailing a 32px `#7A3B12` check circle), খতমের অগ্রগতি (`sage` chip, `১১ / ৩০ পারা · সময়মতো চলছে`, trailing `৩৭%` at 17/700 in `#8A4A0F`), ফিতরা ও যাকাত (`goldTint` chip, chevron).
3. Footer button: `#7A3B12` fill, radius 24, `রমজানের সময়সূচি শেয়ার করুন` in `#FFF3DC` with a `#FFD48A` `shareNetwork` — generates a shareable image of the month's sehri/iftar table (a genuinely viral surface in Bangladesh).

---

### ২১ · আরও (new screen) — new module `module/more/`

Tab 5. Replaces the language drawer and collects everything that is not a daily habit.

Hero: title `আরও` only.

Body:
1. A 3-column grid of 9 white tiles (radius 20, gap 10), each a 38px `sage` icon chip over a 12/600 label: কিবলা, মসজিদ, দুআ, হাদিস, যাকাত, ক্যালেন্ডার, **রমজান** (`goldTintCard` + `goldTintBorder` + a `gold` chip — highlighted during Ramadan), ৯৯ নাম, উইজেট.
2. Overline `সেটিংস` → a grouped card of eight rows, each a leading 18px `duskMid` icon + a 14.5/600 label + an optional trailing value + chevron: ভাষা (`বাংলা`), অবস্থান (`ধানমন্ডি`), নামাজের হিসাব পদ্ধতি (`করাচি`), আজান ও রিমাইন্ডার, ফন্ট ও পড়ার সেটিংস, রাতের মোড (`স্বয়ংক্রিয়`), অফলাইন ডাউনলোড (`২১৪ এমবি`), অ্যাপ সম্পর্কে (`২.০.০`).

`৯৯ নাম` and `উইজেট` are placeholders for phase 3; wire them to a "coming soon" state or hide them until built.

---

## Interactions & Behavior

### Navigation

- Tab switches are instant, no transition (`IndexedStack` preserves each tab's scroll position — **keep this**, the current build rebuilds pages on switch, which loses the Quran scroll position).
- Pushed screens use the platform default (`CupertinoPageTransition` on iOS, `OpenUpwardsPageTransitionsBuilder` on Android).
- Routes to add to `app_routes.dart` / `app_pages.dart`: `/onboarding`, `/more`, `/dua`, `/ramadan`, `/reading-plan`, `/adhan-settings`, `/adhan-settings/:prayer`, `/quran/bookmarks`, `/hadith/:collection`, `/zakat/history`.

### Motion

| Element | Spec |
|---|---|
| Time-of-day hero cross-fade | 400ms `Curves.easeInOut` on window turnover |
| Tracker circle tap | 180ms `Curves.easeOut` scale 1.0→0.92→1.0, plus fill cross-fade |
| Nav active pill | 260ms `Curves.easeOutCubic` position + fill |
| Countdown tick | **No animation.** Text swap only — animating a per-second digit is distracting and burns battery |
| Ayah highlight advance | 220ms `Curves.easeOut` background fade; the scroll to keep it in view is 400ms `easeInOutCubic` |
| Tasbih count | No layout animation; haptic only. The number changes instantly |
| Qibla needle | Continuous, but **low-pass-filtered** — smooth the compass stream over ~120ms or it jitters unusably |
| Bottom sheets | Default `showModalBottomSheet` curve, 300ms |
| Card press | 120ms opacity to 0.92, or an `InkWell` with `sage`-at-40% splash |

### States

Every interactive element needs these; the board shows the resting state only.

- **Pressed** — cards/rows: `sage` at 40% overlay. Gold button: darken to `#B08D1E`. Deep button: lighten to `duskMid`.
- **Disabled** — 45% opacity, no shadow, no splash.
- **Loading** — never a full-screen spinner. Use per-region skeletons: `trackEmpty`-filled rounded rectangles at the final geometry, with a 1200ms shimmer. The prayer hero's loading state shows the layout with `—` in place of times, not a spinner (the current build's `preparingPrayerTimes` text should become this).
- **Empty** — each list needs one: bookmarks (`bookmarkSimple` in a 66px `sage` circle + `এখনো কোনো বুকমার্ক নেই` + a `কুরআন পড়ুন` action), zakat history, notes, masjid list (location denied).
- **Error** — inline, never a snackbar for data failures: a `goldTintCard` panel with `warning`, a plain-Bangla cause, and a `আবার চেষ্টা করুন` action. Location denied on কিবলা/মসজিদ shows the manual-city fallback from frame ১০.
- **Offline** — prayer times, Quran text, hadith, dua and the calendar must all work offline. Only masjid finder, gold rates and un-downloaded recitation audio require network; each shows the inline error panel above.

### Responsive behaviour

Designed at **390 logical px**. Much of the target market is on **360dp**, and some on 320dp.

Rules:
- Screen padding drops 18 → 14 below 375dp.
- The **5-prayer strip on হোম** and the **5-cell jamaat strip on মসজিদ** are the first things to break. Below 375dp: reduce the cell font to 13/11 and the gap to 4. Below 340dp, make the prayer strip horizontally scrollable rather than compressing further.
- The **5-tab nav** at 360dp: labels stay (they are 4–6 Bangla characters and must not be dropped for the 45+ audience); reduce icon to 19 and label to 10, padding 8→6.
- The tasbih counter scales with width: `min(116, width * 0.30)`.
- Respect `MediaQuery.textScaler` up to 1.3× — all cards must grow, not clip. Test at 1.3×; the tracker card and the prayer rows are where it will hurt.
- Landscape is out of scope except for the Quran reader, which should simply reflow.

---

## State Management

Keep GetX. Existing controllers to extend, new ones to add:

### New persistence (the app currently has none of this)

Use the existing local-preferences layer in `lib/src/core/local/preferences/` for settings, and add a local DB (Hive or `sqflite`) for the logs — these are per-day records that will accumulate for years.

| Store | Shape | Written by |
|---|---|---|
| `prayer_log` | `{date: ISO8601, prayer: PrayerName, status: prayed \| missed \| qada, loggedAt}` | Home tracker circles, নামাজ row circles |
| `prayer_streak` | derived — current streak, longest streak, per-month totals | computed from `prayer_log`, cached |
| `reading_progress` | `{date, ayahsRead, secondsRead, lastSurah, lastAyah}` | reader scroll + plan |
| `reading_plan` | `{type: ayahs \| para \| minutes \| weekly, target, startedAt}` | frame ১৪ |
| `bookmarks` | `{surah, ayah, createdAt}` | ayah sheet |
| `notes` | `{surah, ayah, body, updatedAt}` | ayah sheet |
| `adhan_settings` | per prayer: `{mode: adhan \| silent \| off, soundId, preOffsetMinutes}` | frames ১১, ১২ |
| `roza_log` | `{date, kept: bool}` | Ramadan tracker |
| `taraweeh_log` | `{date, rakats}` | Ramadan |
| `zakat_calculations` | `{year, assets: Map, deductions: Map, payable, savedAt}` | zakat |
| `jamaat_times` | `{masjidId, prayer, time, source: user \| community}` | masjid finder |
| `ui_prefs` | `{locale, nightMode: auto\|on\|off, arabicFontScale, translationFontScale, wordByWord: bool, hijriOffset: int}` | more/settings |

### Controller changes

- `DashboardController` — `currentIndex` 0..4; page list gains `PrayerTimesView` and `MoreView`, loses `QiblaView`.
- `HomeController` — add `todayLog`, `streak`, `togglePrayerLogged(PrayerName)`, `readingProgressToday`, and expose the current prayer window for hero theming.
- `PrayerTimesController` — already computes times, `current`, `next`, `remaining`, method, madhab, offsets. Add: `jamaatTimeFor(PrayerName)`, `monthLog`, and the tracker write-through. **Keep `adhan` as the calculation engine.**
- New `TrackerController`, `ReadingPlanController`, `AdhanSettingsController`, `DuaController`, `RamadanController`, `MoreController`.
- `QuranController` — add bookmarks, notes, night mode, font scales, word-by-word timing lookup. Remove tap-to-play from the ayah body.

### Notifications

The single most important non-visual requirement. The current build has a notifications route but no scheduling.

- `flutter_local_notifications` + `android_alarm_manager_plus` (or `WorkManager`) for a rolling 7-day schedule of exact alarms, rescheduled on boot, on location change, and on any calculation-setting change.
- Android: `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM`, `RECEIVE_BOOT_COMPLETED`, `POST_NOTIFICATIONS`, and a battery-optimisation-exclusion request. Full adhan audio plays via a foreground service with a notification channel set to `AudioAttributes.USAGE_ALARM` so it is audible in DND.
- Surface the permission state in frame ১২'s status card. **If exact alarms are unavailable, say so plainly in Bangla rather than silently firing late** — this is the top complaint in this app category.

---

## Files in this bundle

| File | What it is |
|---|---|
| `Al Muttaqee v2 Dusk.dc.html` | **The design to build.** 21 frames + foundation and component sheets. Open in a browser; pan and zoom. |
| `Al Muttaqee Redesign.dc.html` | Superseded earlier direction (flat/modernist). History only — **do not build from this**. |
| `support.js` | Runtime needed for the two HTML files to render. Keep it beside them. |
| `app_colors_dusk.dart` | Drop-in replacement for `lib/src/core/constants/app_colors.dart` — the full Dusk palette plus the time-of-day gradient sets, in the existing `AppColors.<name>` style. |
| `assets/khatim.svg` | The eight-point star tile for hero backgrounds. Raster to PNG @1x/2x/3x for tiling. |

---

## Suggested build order

**Phase 1 — the retention change.** Touches `core/constants`, `dashboard`, `prayer_times`, `notifications` only.
1. Swap `app_colors.dart` for `app_colors_dusk.dart`; bundle the three fonts; add the khatim asset. Every existing screen shifts to Dusk in one commit.
2. Build the shared `DuskHero`, `DuskNavBar`, `GroupedCard`, `DuskSwitch`, `TrackerCircle` widgets in `core/shared/widgets/`.
3. Rebuild `dashboard_view.dart` (5 tabs, drawer removed) and `more_view.dart`.
4. Rebuild `home_view.dart` and `prayer_times_view.dart`, including the tracker.
5. Build `adhan_settings` + real notification scheduling and the permission flow.
6. Build onboarding.

**Phase 2 — the Quran work.** Reader redesign, night mode, font scales, bookmarks/notes, the ayah sheet, reading plan, then dua and Ramadan.

**Phase 3 — the rest.** Jamaat crowd-sourcing, home-screen widgets, ৯৯ নাম, zakat history.

Phase 1 is self-contained and shippable on its own.

---

## Notes

- The design uses no third-party brand assets.
- Nothing in these screens is gated behind payment — the `module/pro/` paywall is intentionally designed out. If Pro returns later, it should be a single entry point in আরও, not upsells inside features.
- Where Bangla copy appears in this document and on the board, it is **final copy**. Add it to the ARB files rather than paraphrasing; the tone is deliberately plain and warm, and avoids both formal Sadhu-bhasha and English loanwords where a common Bangla word exists.

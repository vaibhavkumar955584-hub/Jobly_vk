# JobBoard — 91 Technologies Internship Assignment

A Flutter job listing app that displays active and archived roles from the Wraeglobal API.

---

## Setup

```bash
# 1. Clone the repo
git clone <your-repo-url>
cd job_listing_app

# 2. Install dependencies
flutter pub get

# 3. Run
flutter run
```

**Requirements:** Flutter 3.x, Dart 3.x (tested on Flutter 3.41.7 / Dart 3.11.5)

---

## Packages Used

| Package | Purpose |
|---|---|
| `http ^1.2.0` | REST GET calls to the Wraeglobal API |
| `intl ^0.19.0` | Date formatting (`dd MMM yyyy`) and number formatting |
| `flutter_html ^3.0.0-beta.2` | Renders the `briefing` field (raw HTML) as rich text |
| `google_fonts ^6.2.1` | Outfit font for clean, modern typography |

---

## Architecture

```
lib/
├── main.dart
├── theme/
│   └── app_theme.dart          # Dark theme, color palette, typography
├── models/
│   └── role.dart               # Role data class + fromJson + cleanBriefing
├── services/
│   └── role_service.dart       # API calls, typed error handling
├── utils/
│   └── formatters.dart         # Date, salary (INR lakh), experience formatters
├── screens/
│   ├── home_screen.dart        # TabBar with Active / Archived tabs
│   ├── role_list_screen.dart   # Per-tab list with search, states, keepAlive
│   └── role_detail_screen.dart # Detail view with HTML briefing
└── widgets/
    ├── role_card.dart          # Card component (both tab modes)
    └── state_views.dart        # Loading / Error / Empty state widgets
```

---

## Key Implementation Notes

### No location field in the API

After hitting both endpoints directly (`getActiveRoles` and `getArchivedRoles`), **there is no `location` field anywhere in the JSON response**. The UI handles this gracefully with a "Not specified" fallback — the app never crashes or shows a blank field because of this absence.

### Double-encoded briefing

Many roles return the `briefing` field with an outer escaped-quote wrapper, e.g.:

```
"\"<p>Job description here...</p>\""
```

The `cleanBriefing` getter on the `Role` model strips this leading/trailing stray `"` before passing the HTML to `flutter_html` for rendering.

### Salary formatting

`min_salary` / `max_salary` are annual figures in raw INR rupees (e.g. `3000000` = Rs 30 LPA). The `Formatters.formatSalary()` utility converts these to a short "L" or "Cr" notation for readability.

### Tab state preservation

Each tab uses `AutomaticKeepAliveClientMixin` (`wantKeepAlive = true`). Navigating to a detail screen and pressing Back returns to the **exact scroll position** without refetching data.

---

## Features

- Two tabs: Active Roles / Archived Roles — each fetches from its own endpoint
- Loading / Error (with Retry) / Empty states — all visually distinct
- Per-tab search bar — local filter, no API calls per keystroke
  - Case-insensitive partial match on title and company name
  - Live updates as you type, X button to clear
  - Different empty-state copy for "no API results" vs "no search matches"
- Role cards: title, company, experience, date (Posted/Deadline/Archived), salary chip
- Detail screen: all fields, HTML job description, salary formatting, referral bonus
- Scroll position preserved on Back navigation
- Graceful error handling: no internet, timeout, malformed JSON, non-200

---

## Running Analysis

```bash
flutter analyze    # Zero errors, zero warnings
```

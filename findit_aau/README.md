# FindIt AAU 🔍

> A campus lost & found platform for Addis Ababa University students — built with Flutter, Bloc, and Dio.

---

## About

**FindIt AAU** helps students at Addis Ababa University report and recover lost items across campus. Whether you lost your student ID near the Main Library or found a backpack at the Engineering Block, FindIt AAU connects the campus community quickly and efficiently.

---

## Features

- 📋 **Browse All Reports** — View all lost and found items in a clean, filterable list
- ➕ **Report an Item** — Submit lost or found item reports with full details
- ✏️ **Edit Reports** — Update any previously submitted report
- 🗑️ **Delete Resolved Reports** — Remove items once they've been reunited with their owner
- 🔍 **Search** — Search by title, location, or category
- 🏷️ **Filter** — Filter by Lost/Found status and item category
- 🔄 **Pull-to-Refresh** — Manually refresh the item list
- 👆 **Swipe Actions** — Swipe cards to quickly edit or delete
- 📍 **AAU Locations** — Predefined campus locations for accurate reporting
- 📱 **Snackbar Feedback** — Clear success/error notifications
- ⚡ **Optimistic UI** — Instant visual feedback on delete operations
- 📭 **Empty State** — Friendly UI when no items exist
- 🌐 **Error Handling** — Network errors, timeouts, and API failures handled gracefully

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter 3.x |
| State Management | flutter_bloc ^8.x |
| Networking | dio ^5.x |
| API | MockAPI (REST) |
| Image Loading | cached_network_image |
| Fonts | google_fonts (Plus Jakarta Sans) |
| Swipe Actions | flutter_slidable |
| Date Formatting | intl |

---

## Architecture

```
lib/
├── blocs/item/
│   ├── item_bloc.dart       # Business logic
│   ├── item_event.dart      # User actions
│   └── item_state.dart      # UI states
├── models/
│   └── item_model.dart      # Data model with fromJson/toJson
├── repositories/
│   └── item_repository.dart # Isolates data logic from Bloc
├── services/
│   └── api_service.dart     # Dio HTTP client (GET/POST/PUT/DELETE)
├── screens/
│   ├── home_screen.dart     # Item list + search/filter
│   ├── add_item_screen.dart # New report form
│   ├── edit_item_screen.dart# Edit form (pre-populated)
│   └── item_detail_screen.dart # Detail view with actions
├── widgets/
│   ├── common_widgets.dart  # Shared UI components
│   └── item_card.dart       # Slidable item card
├── utils/
│   ├── app_theme.dart       # Theme, colors, typography
│   └── constants.dart       # API URL, categories, locations
└── main.dart
```

### Data Flow

```
UI (screens/widgets)
    ↓ dispatch Event
Bloc (item_bloc.dart)
    ↓ calls
Repository (item_repository.dart)
    ↓ calls
API Service (api_service.dart)
    ↓ Dio HTTP request
MockAPI (REST endpoint)
```

---

## API Setup (MockAPI)

1. Go to [mockapi.io](https://mockapi.io) and create a free project
2. Create a resource called `items` with these fields:

| Field | Type |
|-------|------|
| id | ObjectId |
| title | String |
| description | String |
| category | String |
| imageUrl | String |
| location | String |
| contactInfo | String |
| status | String (`Lost` / `Found`) |
| date | String (ISO 8601) |

3. Copy your base URL and update `lib/utils/constants.dart`:

```dart
static const String baseUrl = 'https://YOUR-PROJECT-ID.mockapi.io/api/v1';
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0
- Android Studio / VS Code
- A MockAPI endpoint (see above)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/findit-aau.git
cd findit-aau

# 2. Install dependencies
flutter pub get

# 3. Update the API base URL in lib/utils/constants.dart

# 4. Run the app
flutter run
```

---

## Bloc Events & States

### Events
| Event | Description |
|-------|-------------|
| `FetchItemsEvent` | Load all items from API |
| `AddItemEvent` | Create a new item report |
| `UpdateItemEvent` | Update an existing item |
| `DeleteItemEvent` | Delete an item by ID |
| `SearchItemsEvent` | Filter items by search query |
| `FilterItemsEvent` | Filter by status or category |
| `ClearFiltersEvent` | Remove all active filters |

### States
| State | Description |
|-------|-------------|
| `ItemInitial` | App just launched |
| `ItemLoading` | Fetching from API |
| `ItemLoaded` | Items ready with filter/search |
| `ItemSubmitting` | Create/Update in progress |
| `ItemSuccess` | Operation completed |
| `ItemError` | Fetch failure |
| `ItemOperationError` | CRUD operation failure |

---

## Item Categories

Electronics · ID Cards · Bags · Books · Clothing · Accessories · Other

## Campus Locations

Main Library · Student Union · Science Faculty · Engineering Block · Cafeteria · Administration · Medical Faculty · Law Faculty · Business Faculty · Sports Complex · Dormitory A · Dormitory B · Gate 3 · Gate 6 · Other

---

## License

MIT License — free to use and modify for educational purposes.

---

*Built for AAU students, by AAU students.* 🇪🇹

# FindIt AAU 🔍

A simple lost & found app built for Addis Ababa University students.  
Post items, browse what others found, update reports, or remove them when solved.

---

## What this app does

People lose things all the time on campus. This app is just a shared board to help fix that.

You can:
- Post a lost or found item
- See all reported items
- Edit your own posts
- Delete items when they’re resolved
- Search and filter by category or status

Nothing fancy. Just practical.

---

## Tech stack

- Flutter
- Bloc (state management)
- Dio (API calls)
- MockAPI (backend)

---

## API setup

This project uses MockAPI.

**Base URL:**

https://6a0b93ae5aa893e1015a57fd.mockapi.io/api/v1


**Endpoint:**

/items


---

## Item structure

Each item contains:

- id
- title
- description
- category
- imageUrl
- location
- contactInfo
- status (Lost / Found)
- date (ISO string)

---

## Project structure


lib/
├── blocs/item/
│ ├── item_bloc.dart
│ ├── item_event.dart
│ └── item_state.dart
├── models/
│ └── item_model.dart
├── repositories/
│ └── item_repository.dart
├── services/
│ └── api_service.dart
├── screens/
│ ├── home_screen.dart
│ ├── add_item_screen.dart
│ ├── edit_item_screen.dart
│ └── item_detail_screen.dart
├── widgets/
│ ├── item_card.dart
│ └── common_widgets.dart
├── utils/
│ ├── constants.dart
│ └── app_theme.dart
└── main.dart


---

## How data flows

UI → Bloc → Repository → API Service → MockAPI → UI

---

## Features

- View all items from API
- Add new lost/found items
- Edit existing items
- Delete items
- Search by text
- Filter by category or status
- Pull to refresh
- Loading and error states handled properly

## Screenshots

![Home Screen](assets/Screenshot%202026-05-19%20015440.png)

![Report Item](assets/Screenshot%202026-05-19%20015607.png)

![Reported Item](assets/Screenshot%202026-05-19%20015640.png)

![Edit Item](assets/Screenshot%202026-05-19%20015705.png)

![Edited Item](assets/Screenshot%202026-05-19%20015752.png)

![Deleting Item](assets/Screenshot%202026-05-19%20015822.png)
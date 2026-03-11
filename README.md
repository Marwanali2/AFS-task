# AFS Task - Items Manager

Simple Flutter CRUD app using **Clean Architecture**, **Bloc** state management, and **SQLite** with a mock network layer.

## Features

- **Clean Architecture** (data / domain / presentation).
- **Bloc** for predictable, testable state management.
- **SQLite (sqflite)** for local persistence.
- **Mock remote API** with random failures to simulate network edge cases.
- Full **CRUD**:
  - Create: add new item (name + description).
  - Read: list all stored items.
  - Update: edit existing item.
  - Delete: remove item (with confirmation and undo-like behavior on remote failure).
- Subtle **animations**:
  - Animated list item scale/fade on appearance.
  - Animated bottom sheet for add/edit form.
  - Skeleton loader while initial data is loading.
- **Error handling & UX**:
  - Form validation (required name, min length).
  - Snackbars for success / error feedback.
  - Offline / network errors simulated from the mock API.

## Tech Stack

- Flutter (Material 3)
- flutter_bloc
- sqflite
- path
- dartz
- equatable

## Project Structure

```text
lib/
  core/
    failure.dart
  features/
    item/
      data/
        datasources/
          item_local_data_source.dart
          item_remote_data_source.dart
        models/
          item_model.dart
        repositories/
          item_repository_impl.dart
      domain/
        entities/
          item.dart
        repositories/
          item_repository.dart
        usecases/
          get_items.dart
          create_item.dart
          update_item.dart
          delete_item.dart
      presentation/
        bloc/
          item_bloc.dart
          item_event.dart
          item_state.dart
        pages/
          items_page.dart
        widgets/
          item_card.dart
          item_form_bottom_sheet.dart
  main.dart
```

## Setup & Run

### 1. Install Flutter

Make sure Flutter SDK is installed and configured in your `PATH`.

```bash
flutter --version
```

### 2. Get dependencies

From the project root:

```bash
flutter pub get
```

### 3. Run the app

```bash
flutter run
```

Select an emulator or a connected device when prompted.

## How It Works

- On startup, `main.dart` loads `ItemsPage`.
- `ItemsPage` provides an `ItemBloc` which depends on:
  - `ItemLocalDataSource` (SQLite) for persistent storage.
  - `ItemRemoteDataSourceMock` for network sync simulation.
  - `ItemRepositoryImpl` that coordinates between local and remote layers.
- The Bloc exposes states (`ItemState`) containing:
  - list of items,
  - loading flag,
  - optional error/info messages.
- The UI reacts to Bloc states via `BlocConsumer`:
  - shows list / empty state / loading skeleton.
  - displays Snackbars for success and error messages.

## Edge Cases & Error Handling

- **Invalid input**:
  - Name is required and must be at least 3 characters.
  - Validation errors are shown inline in the bottom sheet form.
- **Database failures**:
  - Caught and mapped to `DatabaseFailure` with a user‑friendly message.
- **Network failures**:
  - Mock remote API randomly fails (~25% of the time) to simulate poor connectivity.
  - Create/update:
    - Item is saved locally first.
    - If remote sync fails, UI shows an error but keeps the local item (marked as not synced).
  - Delete:
    - Local delete happens immediately.
    - If remote delete fails, the item is restored locally and an error message is shown.

## UI / UX Notes

- Uses **Material 3** with a purple seed color for a modern look.
- List items:
  - Show name, description, and sync icon (cloud on/off).
  - Swipe to delete (with confirmation dialog).
  - Tap or edit icon to open the edit form.
- Add/Edit form:
  - Appears in a rounded modal bottom sheet.
  - Responsive to keyboard with smooth padding animation.
  - Primary button shows a progress indicator while submitting.

## Assumptions

- Single feature (items) is enough to demonstrate architecture and patterns.
- Network layer is mocked in‑memory; no real HTTP calls are made.
- Basic English-only UI text is acceptable for this task.


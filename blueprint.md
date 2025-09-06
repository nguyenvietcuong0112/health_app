'''# AI Health & Lifestyle App Blueprint

## Overview

This application is a Flutter-based mobile app designed to help users track their health and wellness. It provides a dashboard to visualize key health metrics, an AI-powered chat for health advice, and personalized suggestions.

## Project Structure

The project follows a feature-driven directory structure to ensure scalability and maintainability.

```
lib/
|-- api/                  # API service definitions (not yet implemented)
|-- l10n/                 # Localization files
|-- models/               # Data models (e.g., HealthData)
|-- screens/              # UI screens for different features
|   |-- chat/
|   |   `-- chat_screen.dart
|   `-- dashboard/
|       |-- dashboard_screen.dart
|       |-- health_card.dart
|       `-- sleep_chart.dart
|-- services/             # Business logic and services (AI, Notifications)
|   |-- ai_api_service.dart
|   `-- notification_service.dart
|-- viewmodels/           # State management (e.g., HealthViewModel, ThemeViewModel)
|   |-- health_viewmodel.dart
|   |-- locale_viewmodel.dart
|   `-- theme_viewmodel.dart
|-- widgets/              # Reusable UI components
|-- firebase_options.dart # Firebase configuration
`-- main.dart             # App entry point
```

## Features & Design

### 1. Wellness Dashboard (`dashboard_screen.dart`)
- **Purpose:** Provides an at-a-glance view of the user's daily health metrics.
- **Components:**
  - **AI Health Tip:** A card displaying a daily health suggestion fetched from the Gemini API via `AiApiService`.
  - **Health Metrics Grid:** Displays key metrics like steps and calories burned using `HealthCard` widgets.
  - **Sleep Analysis:** A line chart (`SleepChart`) visualizing the user's sleep patterns over the last 7 days.
- **Navigation:** An action button in the `AppBar` navigates to the `ChatScreen`.

### 2. AI Chat (`chat_screen.dart`)
- **Purpose:** Allows users to have a conversation with a Gemini-powered AI for health advice.
- **Functionality:**
  - Maintains conversation history.
  - Sends user messages to `AiApiService` and displays the AI's response.

### 3. State Management (`viewmodels/`)
- **Provider Pattern:** The app uses the `provider` package for state management.
- **ViewModels:**
  - `HealthViewModel`: Manages and provides `HealthData` (steps, calories, etc.).
  - `ThemeViewModel`: Manages the app's theme (light/dark mode).
  - `LocaleViewModel`: Manages the app's language and localization.

### 4. Backend Services (`services/`)
- **`AiApiService`**: Interacts with the Firebase AI SDK (Gemini) to generate health tips and chat responses.
- **`NotificationService`**: Manages local push notifications.

### 5. Routing (`main.dart`)
- **`go_router`:** The app uses `go_router` for declarative navigation, allowing for robust routing between the dashboard (`/`) and the chat screen (`/chat`).

### 6. Styling & Theming (`main.dart`)
- **Material 3:** The app uses Material 3 design principles.
- **`google_fonts`:** The `lato` font is used for typography.
- **Dynamic Theme:** A centralized theme builder (`_buildTheme`) creates consistent light and dark themes based on a `ColorScheme` generated from a seed color.

## Current Action Plan: Full System Restore

**Objective:** Fix all compilation and runtime errors caused by a failed package upgrade by performing a complete and methodical restoration of the codebase.

**Steps:**

1.  **Standardize File Structure:**
    - [x] Move all screen files into the `lib/screens/` directory.
    - [x] Rename and move all provider classes to `lib/viewmodels/` to standardize naming conventions.
    - [x] Delete old, now-empty directories (`lib/dashboard`, `lib/providers`).

2.  **Fix Codebase:**
    - [x] **`pubspec.yaml`**: Update to stable, compatible versions of all dependencies, including `firebase_ai: ^1.0.0`, `go_router: ^14.2.0`, and `fl_chart: ^1.1.0`.
    - [x] **`main.dart`**: Rewrite to use the new file structure, correct ViewModel names, and properly initialize `MultiProvider` and `GoRouter`.
    - [x] **All other Dart files**: Update all `import` statements to reflect the new, standardized file structure. Fix any breaking changes from package upgrades, especially in `sleep_chart.dart` and `ai_api_service.dart`.

3.  **Finalize and Run:**
    - [x] Run `flutter pub get` to synchronize dependencies.
    - [x] Run `flutter run` to launch the application.
'''
# AI Health & Lifestyle App Blueprint

## Overview

This application is a Flutter-based mobile app designed to help users track their health and wellness. It provides a dashboard to visualize key health metrics, an AI-powered chat for health advice, and personalized suggestions.

## Project Structure

The project follows a feature-driven directory structure to ensure scalability and maintainability.

```
lib/
|-- api/                  # API service definitions (not yet implemented)
|-- l10n/                 # Localization files
|-- models/               # Data models (e.g., HealthData, ChatMessage)
|-- screens/              # UI screens for different features
|   |-- chat/
|   |   |-- chat_screen.dart
|   |   |-- widgets/
|   |   |   |-- chat_bubble.dart
|   |   |   `-- message_composer.dart
|   |-- dashboard/
|   |   |-- dashboard_screen.dart
|   |   |-- health_card.dart
|   |   `-- sleep_chart.dart
|   `-- main_screen.dart      # Main screen with bottom navigation
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
  - **AI Health Tip:** A card displaying a daily health suggestion.
  - **Health Metrics Grid:** Displays key metrics like steps and calories burned using `HealthCard` widgets.
  - **Sleep Analysis:** A line chart (`SleepChart`) visualizing the user's sleep patterns over the last 7 days.

### 2. AI Chat (`chat_screen.dart`)
- **Purpose:** Allows users to have a conversation with a Gemini-powered AI for health advice.
- **UI Enhancements:**
  - **Styled Chat Bubbles:** Messages are displayed in visually distinct bubbles, with user and AI messages aligned differently and styled with unique colors and icons.
  - **Modern Message Composer:** The text input field and send button have been redesigned for a more polished and user-friendly experience.
- **Functionality:**
  - Maintains conversation history.
  - Sends user messages to `AiApiService` and displays the AI's response.

### 3. State Management (`viewmodels/`)
- **Provider Pattern:** The app uses the `provider` package for state management.
- **ViewModels:**
  - `HealthViewModel`: Manages and provides `HealthData`.
  - `ThemeViewModel`: Manages the app's theme (light/dark mode).
  - `LocaleViewModel`: Manages the app's language and localization.

### 4. Backend Services (`services/`)
- **`AiApiService`**: Interacts with the Firebase AI SDK (Gemini) to generate health tips and chat responses.
- **`NotificationService`**: Manages local push notifications.

### 5. Routing (`main.dart`)
- **`go_router`:** The app uses `go_router` for declarative navigation.
- **`ShellRoute`:** A `ShellRoute` is used to display a `BottomNavigationBar` in the `MainScreen`, which wraps the `DashboardScreen` (`/`) and `ChatScreen` (`/chat`).

### 6. Styling & Theming (`main.dart`)
- **Material 3:** The app uses Material 3 design principles.
- **`google_fonts`:** The `lato` font is used for typography.
- **Dynamic Theme:** A centralized theme builder creates consistent light and dark themes.

## Current Action Plan: Static Analysis Cleanup

**Objective:** Resolve all remaining static analysis warnings and errors from the `flutter analyze` command to improve code quality and maintainability.

**Steps:**

1.  **Run `build_runner`:**
    - [x] Executed `dart run build_runner build --delete-conflicting-outputs` to resolve code generation warnings.

2.  **Fix Deprecation & Lint Warnings:**
    - [x] **`lib/screens/chat/widgets/chat_bubble.dart`**: Replaced `surfaceVariant` with `surfaceContainerHighest` and fixed other minor lint issues.
    - [x] **`lib/screens/chat/widgets/message_composer.dart`**: Replaced deprecated `withOpacity` calls with `withAlpha`.
    - [x] **`lib/widgets/health_card.dart`**: Replaced deprecated `withOpacity` calls.
    - [x] **`lib/widgets/sleep_chart.dart`**: Replaced deprecated `withOpacity` calls.
    - [x] **`lib/viewmodels/health_viewmodel.dart`**: Added `const` keyword to improve performance.
    - [x] **`test/widget_test.dart`**: Removed unused import.

3.  **Final Verification:**
    - [x] Ran `flutter analyze` again to confirm that all issues have been resolved.
    - [x] The codebase is now clean of static analysis warnings.

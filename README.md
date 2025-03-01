
# AI Journal App

A Flutter-based journaling application with AI capabilities, Firebase authentication, and clean architecture implementation.


## Project Structure

```plaintext
lib/
├── common/
│   ├── controllers/      # Base controllers and app-wide state management
│   ├── network/         # Network handling (Dio configuration, interceptors)
│   └── usecase/         # Base usecase definitions
├── core/               # Core utilities and constants
├── features/          # Feature-based modules
│   ├── auth/          # Authentication feature
│   ├── chat/          # AI chat feature
│   ├── journals/      # Journal management
│   └── settings/      # App settings
└── di.dart            # Dependency injection configuration
```

## Architecture

The project follows Clean Architecture principles with the following layers:

1. **Presentation Layer**
   - Views (UI)
   - Controllers (GetX controllers for state management)
   - Widgets

2. **Domain Layer**
   - Use Cases
   - Entities
   - Repository Interfaces

3. **Data Layer**
   - Repository Implementations
   - Models
   - Data Sources

## Key Features

- Firebase Authentication
- Journal Management (CRUD operations)
- AI-powered Chat Interface
- Journal Summarization
- Settings Management

## Error Handling

The application implements a robust error handling system:

1. **Network Error Handling**
   - Custom `Result` wrapper for API responses
   - Dio interceptors for handling HTTP errors
   - Token refresh mechanism for 401 errors
   - Unified error response format

```dart
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;
  
  // ... implementation
}
```

2. **Firebase Error Handling**
   - Specific handling for FirebaseAuthException
   - User-friendly error messages
   - Automatic token refresh

3. **UI Error Handling**
   - Snackbar notifications for user feedback
   - Loading states management
   - Error state handling in controllers

## Dependencies

- **State Management**: GetX
- **Dependency Injection**: GetIt
- **Network**: Dio
- **Authentication**: Firebase Auth
- **UI Components**: 
  - shadcn_ui
  - flutter_chat_ui
  - CupertinoDesign (iOS-style widgets)

## API Integration

The app uses a custom API client built with Dio:

- Automatic token management
- Request/Response logging
- Error interceptors
- Response parsing

## Controllers

The app uses GetX controllers for state management:

- `AppController`: Global app state
- `LoginController`: Authentication state
- `JournalsController`: Journal management
- `ChatController`: AI chat functionality

## Repository Pattern

Repositories abstract data sources and provide clean interfaces:

- `AuthRepository`: Authentication operations
- `JournalRepository`: Journal CRUD operations
- `ChatRepository`: AI chat interactions

## Getting Started

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```
3. Configure Firebase:
   - Add your `google-services.json` (Android)
   - Add your `GoogleService-Info.plist` (iOS)
4. Run the app:
```bash
flutter run
```

## Related Repositories

This application consists of two parts:
- Frontend (Current repository): Flutter mobile application
- Backend: [AI Journal Backend]([https://github.com/Badar25/Journal-backend])

Please ensure you have both repositories set up for full functionality.

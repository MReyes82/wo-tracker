# WoTracker 🏋️

A mobile application designed for structured workout tracking and progressive overload management in strength training.

## Overview

WoTracker is a fitness tracking solution that addresses the core needs of strength training enthusiasts. It provides an intuitive, distraction-free interface for recording sets, repetitions, and weights during gym sessions, enabling users to track their progress and achieve progressive overload systematically.

## Features

### Core Functionality
- **Workout Planning**: Create and manage workout templates with customizable exercise selections
- **Session Tracking**: Record sets, reps, and weights in real-time during workouts
- **Progressive Overload**: Historical data tracking to monitor and surpass previous performance
- **Mesocycle Management**: Organize training into structured mesocycles with weekly progression
- **Exercise Library**: Comprehensive catalog with muscle groups, equipment types, and default weights

### Technical Highlights
- **Offline-First**: Full local data persistence using SQLite
- **Multi-language Support**: English and Spanish localization (easily extensible)
- **Intuitive UI**: Clean Material Design interface optimized for gym use
- **State Management**: Efficient Provider-based architecture

## Technology Stack

- **Framework**: Flutter (Dart SDK ^3.9.2)
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **Internationalization**: Flutter Intl (flutter_localizations)
- **Local Storage**: SharedPreferences
- **Architecture**: MVVM pattern with repository layer

### Key Dependencies
```yaml
sqflite: ^2.3.0              # Local database
provider: ^6.1.1             # State management
intl: ^0.20.2                # Internationalization
shared_preferences: ^2.2.2    # Settings persistence
```

## Getting Started

### Prerequisites
- Flutter SDK 3.9.2 or higher
- Dart SDK ^3.9.2
- Android Studio / VS Code with Flutter extensions
- iOS development: Xcode (for iOS builds)
- Android development: Android SDK

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd wo-tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localizations**
   ```bash
   flutter gen-l10n
   ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── app.dart                    # Main app configuration
├── main.dart                   # Application entry point
├── scheme.sql                  # Database schema
│
├── core/
│   ├── db/                     # Database helper and utilities
│   ├── themes/                 # App theming and colors
│   └── utils/                  # Common utilities
│
├── features/                   # Feature-based modules
│   ├── auth/                   # Authentication (future)
│   ├── exercise/               # Exercise catalog management
│   ├── history/                # Workout history and analytics
│   ├── home/                   # Home screen and dashboard
│   ├── mesocycle/              # Training cycle management
│   ├── navigation/             # App navigation structure
│   ├── register/               # User registration (future)
│   ├── settings/               # App settings and preferences
│   └── workout/                # Workout sessions and templates
│       ├── models/             # Data models
│       ├── repositories/       # Data access layer
│       ├── view_models/        # Business logic
│       ├── views/              # UI screens
│       └── widgets/            # Reusable components
│
├── generated/
│   └── l10n/                   # Generated localization files
│
└── l10n/                       # Localization resources
    ├── app_en.arb              # English translations
    └── app_es.arb              # Spanish translations
```

## Internationalization

The app supports multiple languages through Flutter's localization framework:

- **Current languages**: English (en), Spanish (es)
- **Adding a new language**:
  1. Create `app_<locale>.arb` in `lib/l10n/`
  2. Run `flutter gen-l10n`
  3. The language will be automatically available

## Database Schema

The app uses a local SQLite database with the following main entities:

- **exercise**: Exercise catalog with names, types, equipment, and muscle groups
- **workout_template**: Reusable workout structures
- **workout_session**: Individual workout instances with timestamps
- **workout_exercise**: Exercises within a session
- **workout_set**: Individual sets with reps and weight
- **mesocycle**: Training program organization
- **equipment_type**, **muscle_group**, **exercise_type**: Support tables

## Design Philosophy

WoTracker follows these core principles:

1. **Minimal Friction**: Quick data entry without unnecessary navigation
2. **Progressive Disclosure**: Show only relevant information at each step
3. **Offline-First**: No internet dependency for core functionality
4. **Focused Experience**: Purpose-built for strength training tracking

## Target Platforms

-  Android
-  iOS


##  License

This project is currently unlicensed. All rights reserved.

##  Project Context

This application was developed as part of a case study focusing on mobile solutions for the fitness sector, specifically addressing the needs of strength training practitioners who require structured tracking without the overhead of full training program subscriptions.


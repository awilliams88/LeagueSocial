# LeagueSocial

LeagueSocial is a SwiftUI-based iOS app developed for the League engineering challenge. It demonstrates secure login, post listing, and user detail presentation using modern Swift development practices.

## Architecture

The app uses MVVM architecture with SwiftUI, protocol-oriented programming, and dependency injection via `@Environment`. Networking is handled with async/await, and secure token storage uses Keychain.

### File Structure

```
LeagueSocial/
├── Core/                  // Shared models, networking, security, DI
├── Features/              // Feature-specific folders (Login, PostList, UserInfo)
└── LeagueSocialTests/     // Unit tests
```

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/awilliams88/LeagueSocial.git
cd LeagueSocial
```

### 2. Open the Project in Xcode

```bash
xed .
```

Or open `LeagueSocial.xcodeproj` manually in Xcode.

### 3. Run the App

- Select the `LeagueSocial` scheme
- Choose an iOS Simulator (e.g., iPhone 15)
- Press `Cmd + R` to build and run

### 4. Run Tests

```bash
Cmd + U
```

Tests can also be run from the Test Navigator in Xcode.

## Requirements

- Xcode 16.2 or later
- iOS 18.2 or later

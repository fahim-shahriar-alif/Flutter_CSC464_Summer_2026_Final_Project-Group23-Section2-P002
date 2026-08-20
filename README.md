# Tic Tac Toe (CSE 464)

Flutter final project — Group 23, Section 2 (P002).

A two-player Tic Tac Toe app with **Firebase Authentication**, **Google Sign-In**, and **Cloud Firestore** match history.

## Features

- Email / password login and sign-up (Firebase Auth)
- Continue with Google (Firebase Auth + Google Sign-In)
- Local two-player game with scoreboard and turn controls
- Save completed matches to Firestore (`/matches`)
- Match history screen (newest first)
- Logout (Firebase Auth + Google)

## Tech stack

| Layer | Package / tool |
|--------|----------------|
| UI | Flutter (Material 3) |
| State | `provider` |
| Auth | `firebase_auth`, `google_sign_in` |
| Database | `cloud_firestore` |
| Init | `firebase_core` + `lib/firebase_options.dart` |

**Android application id:** `com.cse464.tic_tac_toe`

## Project structure

```
lib/
├── main.dart
├── firebase_options.dart
├── models/
│   └── match_model.dart
├── services/
│   ├── auth_service.dart
│   └── firestore_service.dart
├── providers/
│   ├── auth_provider.dart
│   ├── game_provider.dart
│   └── history_provider.dart
├── screens/
│   ├── login_screen.dart
│   ├── player_name_screen.dart
│   ├── game_screen.dart
│   └── match_history_screen.dart
└── widgets/
    ├── board_widget.dart
    ├── cell_widget.dart
    ├── scoreboard_widget.dart
    ├── game_controls_widget.dart
    └── match_history_tile.dart
```

## Firestore schema

Collection: `/matches/{matchId}`

| Field | Type |
|--------|------|
| `player1` | string |
| `player2` | string |
| `winner` | `"X"` \| `"O"` \| `"Tie"` |
| `board` | array of 9 strings (`""`, `"X"`, or `"O"`) |
| `createdAt` | timestamp (`FieldValue.serverTimestamp()` on write) |

Passwords are **not** stored in Firestore. There is no `/users` credentials collection.

### Suggested security rules

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /matches/{matchId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Setup

### Prerequisites

- Flutter SDK
- Android Studio / emulator (or a physical device)
- A Firebase project (this app uses project id `tictactoe-ed843`)

### 1. Clone and install

```bash
git clone https://github.com/fahim-shahriar-alif/Flutter_CSC464_Summer_2026_Final_Project-Group23-Section2-P002.git
cd Flutter_CSC464_Summer_2026_Final_Project-Group23-Section2-P002
flutter pub get
```

### 2. Firebase config files

Make sure these exist (generated via FlutterFire / Firebase Console):

- `android/app/google-services.json`
- `lib/firebase_options.dart`
- (iOS) `ios/Runner/GoogleService-Info.plist`

If you need to regenerate Android config:

```bash
flutterfire configure --project=tictactoe-ed843 --android-package-name=com.cse464.tic_tac_toe --platforms=android --yes
```

### 3. Firebase Console checklist

1. Enable **Authentication → Email/Password**
2. Enable **Authentication → Google** (for the Google button)
3. Create a **Firestore** database
4. Publish the security rules above
5. For Google Sign-In on Android, add your debug **SHA-1** under Project settings → Your Android app

Get SHA-1:

```bash
cd android && ./gradlew signingReport
```

### 4. Run

```bash
flutter run
```

## How to use

1. Sign up or log in with email/password (or Google)
2. Enter Player 1 and Player 2 names
3. Play on the 3×3 board
4. Finished games are saved to Firestore
5. Open Match History to view past games
6. Log out from the game controls

## Assets

- `assets/google_logo.png` — used on the login screen Google button

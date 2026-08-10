# Vision Companion

A Flutter-based accessibility-focused vision assistance application developed as part of the **Flutter Developer Intern Assignment**.

Vision Companion provides real-time object detection and AI-powered image analysis, with Firebase authentication, cloud history, localization, and Android TalkBack accessibility support.

---

## Features

### Live Object Detector

- Real-time camera-based object detection.
- TensorFlow Lite SSD MobileNet V1 model.
- Bounding boxes and confidence scores.
- Text-to-speech announcements for detected objects.
- Haptic feedback.
- Pause/Resume detection.
- Detection history stored in Firestore.

### AI Image Analyzer

- Capture an image using the device camera.
- AI-powered image description using Groq Vision API.
- Simple descriptions suitable for spoken audio.
- Loading and error states.
- Retry and Analyze Another Image options.
- Analysis history stored in Firestore.

### Authentication

- Firebase Email/Password authentication.
- Google Sign-In.
- User profile information.
- Sign-out functionality.

### History

- Stores object detection results.
- Stores AI image analysis results.
- History is associated with the authenticated user.

### Localization

- English and Hindi support.
- ARB-based Flutter localization.
- Language selection from Settings.
- Selected language is persisted locally.

### Accessibility

- Android TalkBack support.
- Flutter `Semantics` labels.
- Accessible buttons and controls.
- Live-region detection status.
- Accessible camera controls.
- Text-to-speech object detection feedback.

---

## Screenshots

### Login

![Login Page](docs/screenshots/login.jpeg)

### Home

![Home Page](docs/screenshots/home.jpeg)

### Home Hindi

![Hindi Home Page](docs/screenshots/home-hindi.jpeg)

### Live Object Detector

![Live Object Detector](docs/screenshots/object-detector.jpeg)

### AI Image Analyzer

![AI Image Analyzer](docs/screenshots/image-analyzer.jpeg)

### History

![History Page](docs/screenshots/history.jpeg)

### Profile

![Profile Page](docs/screenshots/profile.jpeg)

### Settings

![Settings Page](docs/screenshots/settings.jpeg)

---

## Architecture

The application follows a **feature-first architecture** with Cubit-based state management.

```text
                         Vision Companion
                                |
                +---------------+---------------+
                |                               |
          Presentation                      Core
                |                               |
        +-------+-------+               +-------+-------+
        |               |               |               |
      Cubit           Widgets         Router          DI
        |                               |
        +---------------+---------------+
                        |
                 Services / Repositories
                        |
          +-------------+-------------+
          |             |             |
     TFLite Model   Groq Vision    Firebase
          |             |             |
     Object        Image Analysis   Auth
     Detection                     Firestore
                                   Analytics
                                   Crashlytics
```

### Application Flow

```text
User
  ↓
Flutter UI
  ↓
Cubit
  ↓
Service / Repository
  ↓
TFLite / Groq / Firebase
  ↓
Cubit State
  ↓
Updated UI + Accessibility Feedback
```

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Flutter / Dart | Application development |
| Flutter Bloc / Cubit | State management |
| GoRouter | Navigation |
| Firebase Auth | Authentication |
| Cloud Firestore | User history |
| Firebase Analytics | Usage analytics |
| Firebase Crashlytics | Crash reporting |
| TensorFlow Lite | Object detection |
| SSD MobileNet V1 | Detection model |
| Groq Vision API | AI image analysis |
| Camera | Camera access |
| Flutter TTS | Voice feedback |
| Flutter Semantics | Accessibility |
| Shared Preferences | Local settings persistence |
| Flutter Dotenv | Environment configuration |
| GetIt | Dependency injection |

---

## Project Structure

```text
lib/
├── core/
│   └── di/
│
├── features/
│   ├── auth/
│   ├── home/
│   ├── detector/
│   ├── analyzer/
│   ├── history/
│   └── settings/
│
├── l10n/
│   ├── app_en.arb
│   └── app_hi.arb
│
├── app.dart
├── main.dart
└── firebase_options.dart
```

---

## Firebase Configuration

The application uses Firebase for authentication, history, analytics, and crash reporting.

### Firebase Authentication

Enabled authentication methods:

- Email/Password
- Google Sign-In

### Cloud Firestore

History is stored per authenticated user:

```text
users/{uid}/history/{documentId}
```

Each history entry contains:

```text
timestamp
featureType
resultSummary
```

### Firebase Analytics

The application records events including:

```text
feature_opened
detection_completed
image_analyzed
```

### Firebase Crashlytics

Flutter errors are reported to Firebase Crashlytics for crash monitoring.

---

## Groq API Configuration

The AI Image Analyzer uses the Groq Vision API.

Create a `.env` file in the project root:

```env
GROQ_API_KEY=YOUR_GROQ_API_KEY
```

The application reads the key using:

```dart
dotenv.env['GROQ_API_KEY']
```

**Do not commit `.env` or API keys to GitHub.**

Recommended `.gitignore` entries:

```gitignore
.env
.env.*
!.env.example
```

---

## Setup

### 1. Clone the Repository

```bash
git clone <https://github.com/Ayush-620/vision-companion>
cd vision_companion
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Configure Firebase

Configure the following Firebase services:

- Firebase Authentication
- Cloud Firestore
- Firebase Analytics
- Firebase Crashlytics

Configure Google Sign-In with the required SHA-1/SHA-256 fingerprints.

### 4. Configure Groq

Create `.env` in the project root:

```env
GROQ_API_KEY=YOUR_GROQ_API_KEY
```

### 5. Generate Localization

```bash
flutter gen-l10n
```

### 6. Analyze the Project

```bash
flutter analyze
```

### 7. Run the Application

```bash
flutter run
```

---

## Localization

Supported languages:

- English
- Hindi

Localization files:

```text
lib/l10n/app_en.arb
lib/l10n/app_hi.arb
```

Generate localization files using:

```bash
flutter gen-l10n
```

The selected language is persisted using `shared_preferences`.

---

## Accessibility / TalkBack

Vision Companion supports Android TalkBack using Flutter `Semantics`.

Accessibility has been implemented for:

- Login controls.
- Home feature cards.
- Camera preview.
- Detection status.
- Pause/Resume button.
- Image capture button.
- Analysis processing state.
- Analysis result.
- Retry controls.
- History.
- Settings and language selection.

### Enabling TalkBack

On Android:

```text
Settings
→ Accessibility
→ TalkBack
→ Enable
```

The application was tested using TalkBack navigation and double-tap activation.

Object detection voice feedback is intentionally provided in **English (`en-US`)**.

---

## Testing

The following functionality has been tested:

- [x] Email/Password Login
- [x] Google Sign-In
- [x] Home Page
- [x] Live Object Detection
- [x] Object Detection Voice Feedback
- [x] Haptic Feedback
- [x] Pause/Resume Detection
- [x] AI Image Analysis
- [x] Groq Vision API
- [x] Firestore History
- [x] Firebase Analytics
- [x] Firebase Crashlytics
- [x] English Localization
- [x] Hindi Localization
- [x] TalkBack Accessibility
- [x] Physical Android Device
- [x] Android Emulator
- [x] Release APK

---

## Build Release APK

Generate the release APK using:

```bash
flutter build apk --release
```

The generated APK will be available at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

## Security

The following files and credentials must **not** be committed to GitHub:

```text
.env
API keys
Private signing keys
Service account credentials
```

Before pushing changes, check:

```bash
git status
git diff
```

Make sure no credentials or sensitive information are staged.

---

## Assignment Submission

The final submission includes:

- Public GitHub repository
- Complete Flutter source code
- Firebase integration
- Live object detection
- AI image analysis
- English/Hindi localization
- TalkBack accessibility
- Screenshots
- Project documentation
- Release APK
- Demonstration video

### GitHub Repository

```text
<https://github.com/Ayush-620/vision-companionL>
```

### Release APK

```text
<https://drive.google.com/file/d/19EZu1KSt0qHA_tQZjW3AO10BLFT25m9g/view?usp=drivesdk>
```

---

## Screenshots Directory

Place the screenshots in the following directory:

```text
docs/
└── screenshots/
    ├── login.jpeg
    ├── home.jpeg
    ├── object-detector.jpeg
    ├── image-analyzer.jpeg
    ├── history.jpeg
    ├── profile.jpeg
    └── settings.jpeg
```

---

## Repository Structure

```text
vision_companion/
│
├── android/
├── lib/
├── assets/
├── docs/
│   ├── screenshots/
│   │   ├── login.jpeg
│   │   ├── home.jpeg
│   │   ├── object-detector.jpeg
│   │   ├── image-analyzer.jpeg
│   │   ├── history.jpeg
│   │   ├── profile.jpeg
│   │   └── settings.jpeg
│   │
│   └── Vision_Companion_Submission_Documentation.pdf
│
├── .env.example
├── .gitignore
├── pubspec.yaml
└── README.md
```

---

## License

This project was developed as part of the **Flutter Developer Intern Assignment**.
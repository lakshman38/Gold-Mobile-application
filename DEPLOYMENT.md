# Deployment Guide

## Prerequisites

- Flutter SDK 3.0.0+
- Android Studio / Xcode
- Firebase account
- OpenAI API key (optional for chatbot)
- Metal Price API key (optional for live rates)

## Local Development Setup

### 1. Clone and Install Dependencies

```bash
git clone https://github.com/lakshman38/Gold-Mobile-application.git
cd Gold-Mobile-application
flutter pub get
```

### 2. Firebase Setup

Follow `FIREBASE_SETUP.md` to:
- Create Firebase project
- Enable Phone Authentication
- Setup Firestore
- Download config files
- Update firebase_options.dart

### 3. API Configuration

Follow `API_SETUP.md` to:
- Get OpenAI API key
- Get Metal Price API key
- Update service files

### 4. Run the App

```bash
# Check for issues
flutter doctor

# Run on connected device
flutter run

# Run on specific device
flutter devices
flutter run -d <device-id>
```

## Android Deployment

### 1. Generate Keystore

```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

### 2. Configure Signing

Create `android/key.properties`:
```
storePassword=<your-store-password>
keyPassword=<your-key-password>
keyAlias=upload
storeFile=<path-to-keystore>
```

Add to `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

### 3. Build APK/AAB

```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### 4. Play Store Submission

1. Create Google Play Console account
2. Create new app
3. Upload AAB file
4. Fill in store listing
5. Submit for review

## iOS Deployment

### 1. Configure Signing

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner project
3. Go to Signing & Capabilities
4. Select your team
5. Configure bundle identifier: `com.balajigold.app`

### 2. Build IPA

```bash
flutter build ios --release
```

Or build in Xcode:
1. Open `ios/Runner.xcworkspace`
2. Select "Any iOS Device (arm64)"
3. Product → Archive
4. Distribute App

### 3. App Store Submission

1. Create Apple Developer account
2. Create App Store Connect record
3. Upload IPA using Xcode Organizer or Application Loader
4. Fill in app information
5. Submit for review

## Firebase Deployment

### 1. Firestore Indexes

If you get index errors, Firebase will provide a link to create them automatically.

### 2. Security Rules

Update Firestore rules in Firebase Console:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /customers/{customerId} {
      allow read, write: if request.auth != null;
    }
    match /transactions/{transactionId} {
      allow read, write: if request.auth != null;
    }
    match /rates/{rateId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

### 3. Authentication Settings

- Enable Phone Authentication
- Add authorized domains
- Configure phone number restrictions if needed

## Environment-Specific Configuration

### Development

Use `.env.development`:
```
API_ENDPOINT=https://dev-api.example.com
DEBUG_MODE=true
```

### Production

Use `.env.production`:
```
API_ENDPOINT=https://api.example.com
DEBUG_MODE=false
```

## CI/CD Setup

### GitHub Actions

Create `.github/workflows/flutter.yml`:

```yaml
name: Flutter CI

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    - run: flutter pub get
    - run: flutter analyze
    - run: flutter test
    - run: flutter build apk
```

## Monitoring & Analytics

### Firebase Analytics

Already integrated. View analytics in Firebase Console.

### Crashlytics

Add Firebase Crashlytics:

```yaml
# pubspec.yaml
dependencies:
  firebase_crashlytics: ^3.4.8
```

```dart
// main.dart
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
```

## Performance Optimization

### 1. Enable Obfuscation

```bash
flutter build apk --release --obfuscate --split-debug-info=build/app/outputs/symbols
```

### 2. Reduce App Size

```bash
flutter build apk --release --split-per-abi
```

### 3. Enable R8

Already enabled in `android/gradle.properties`:
```
android.enableR8=true
```

## Testing Before Release

### 1. Automated Tests

```bash
flutter test
```

### 2. Integration Tests

```bash
flutter drive --target=test_driver/app.dart
```

### 3. Manual Testing Checklist

- [ ] Test authentication flow
- [ ] Add/view customers
- [ ] Add transactions
- [ ] Calculate balances correctly
- [ ] Export PDF/CSV
- [ ] Chatbot functionality
- [ ] Dark mode
- [ ] Offline mode
- [ ] Different screen sizes
- [ ] Different OS versions

## Post-Release

### Monitor

- Firebase Console for crashes
- Play Console/App Store Connect for reviews
- Analytics for user behavior

### Updates

```bash
# Bump version in pubspec.yaml
version: 1.0.1+2

# Build and deploy
flutter build appbundle --release
```

## Troubleshooting

### Common Issues

**Firebase Auth not working**
- Check google-services.json is in android/app/
- Verify SHA-1 fingerprint in Firebase Console

**Build failures**
- Run `flutter clean`
- Delete build folders
- Run `flutter pub get`

**App crashes**
- Check Firebase Crashlytics
- Test on different devices
- Check console logs

## Support

For issues or questions:
- Open GitHub issue
- Check documentation
- Contact development team

---

Remember to test thoroughly before each release!

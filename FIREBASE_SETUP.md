# Firebase Setup Guide

## Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click "Add Project"
3. Enter project name: "balaji-gold"
4. Follow the setup wizard

## Step 2: Enable Authentication

1. In Firebase Console, go to Authentication
2. Click "Get Started"
3. Enable "Phone" sign-in method
4. Configure your authentication settings

## Step 3: Setup Firestore

1. In Firebase Console, go to Firestore Database
2. Click "Create Database"
3. Choose "Start in production mode"
4. Select your preferred location
5. Create the following collections:
   - `customers`
   - `transactions`
   - `rates`

## Step 4: Setup Firestore Rules

```
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

## Step 5: Add Android App

1. Click "Add App" → Android
2. Enter package name: `com.balajigold.app`
3. Download `google-services.json`
4. Place it in `android/app/` directory

## Step 6: Add iOS App

1. Click "Add App" → iOS
2. Enter bundle ID: `com.balajigold.app`
3. Download `GoogleService-Info.plist`
4. Place it in `ios/Runner/` directory

## Step 7: Update Firebase Options

1. Run the following command to generate firebase_options.dart:
```bash
flutterfire configure
```

Or manually update `lib/firebase_options.dart` with your Firebase project credentials.

## Step 8: Test Connection

Run the app and test authentication:
```bash
flutter run
```

## Troubleshooting

- **Authentication not working**: Check if Phone auth is enabled in Firebase Console
- **Firestore permission denied**: Update Firestore rules as mentioned above
- **App crashes on startup**: Verify google-services.json and GoogleService-Info.plist are in correct locations

# Quick Start Guide - Balaji Gold

This guide will help you get the Balaji Gold application up and running in minutes.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (3.0.0 or higher)
  - Install from: https://flutter.dev/docs/get-started/install
- **Git**
- **Android Studio** (for Android development)
- **Xcode** (for iOS development, macOS only)
- **A code editor** (VS Code recommended)

## Step 1: Clone the Repository

```bash
git clone https://github.com/lakshman38/Gold-Mobile-application.git
cd Gold-Mobile-application
```

## Step 2: Install Dependencies

```bash
flutter pub get
```

## Step 3: Verify Flutter Installation

```bash
flutter doctor
```

Fix any issues shown by `flutter doctor` before proceeding.

## Step 4: Setup Firebase (Required)

### Quick Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project named "balaji-gold"
3. Add an Android app:
   - Package name: `com.balajigold.app`
   - Download `google-services.json`
   - Place in `android/app/`
4. Add an iOS app (optional):
   - Bundle ID: `com.balajigold.app`
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`
5. Enable Authentication:
   - Go to Authentication → Sign-in method
   - Enable "Phone" authentication
6. Create Firestore Database:
   - Go to Firestore Database
   - Create database in production mode
   - Collections will be created automatically

For detailed instructions, see [FIREBASE_SETUP.md](FIREBASE_SETUP.md)

## Step 5: Configure API Keys (Optional but Recommended)

### OpenAI for Chatbot

1. Get API key from: https://platform.openai.com
2. Open `lib/services/chatbot_service.dart`
3. Replace `YOUR_OPENAI_API_KEY` with your actual key

### Gold/Silver Rates API

1. Get API key from: https://metalpriceapi.com
2. Open `lib/services/gold_rate_service.dart`
3. Replace `YOUR_API_KEY` with your actual key

**Note:** The app will work without these API keys using default/mock values.

For detailed instructions, see [API_SETUP.md](API_SETUP.md)

## Step 6: Run the Application

### On Android

```bash
# List available devices
flutter devices

# Run on connected Android device
flutter run
```

### On iOS (macOS only)

```bash
# Open iOS project in Xcode
open ios/Runner.xcworkspace

# Or run directly
flutter run -d ios
```

### On Emulator/Simulator

```bash
# Start Android emulator
flutter emulators
flutter emulators --launch <emulator_id>

# Start iOS simulator (macOS only)
open -a Simulator

# Run app
flutter run
```

## Step 7: First Launch

When you first launch the app:

1. You'll see the **Splash Screen** (Balaji Gold logo)
2. Then the **Get Started Screen**
3. Click "Get Started" to go to **Login Screen**
4. Enter mobile number (for testing, use Firebase Test Phone Numbers)
5. Enter OTP
6. You're in! 🎉

## Testing Without Phone Auth

For testing without actual SMS, you can:

1. In Firebase Console → Authentication → Sign-in method
2. Click on "Phone" provider
3. Add test phone numbers (e.g., +91 1234567890 with OTP 123456)
4. Use these in the app for testing

## Common Commands

```bash
# Check for issues
flutter doctor

# Get dependencies
flutter pub get

# Clean build
flutter clean

# Build APK
flutter build apk

# Build iOS
flutter build ios

# Run tests
flutter test

# Check for code issues
flutter analyze
```

## Project Structure

```
lib/
├── controllers/           # State management (Provider)
│   ├── auth_controller.dart
│   ├── customer_controller.dart
│   └── theme_controller.dart
├── models/               # Data models
│   ├── customer.dart
│   ├── transaction.dart
│   └── gold_rate.dart
├── screens/              # UI screens
│   ├── splash_screen.dart
│   ├── get_started_screen.dart
│   ├── login_screen.dart
│   ├── otp_screen.dart
│   ├── home_screen.dart
│   ├── add_customer_screen.dart
│   ├── customer_detail_screen.dart
│   └── reports_screen.dart
├── services/             # Business logic
│   ├── auth_service.dart
│   ├── customer_service.dart
│   ├── chatbot_service.dart
│   ├── gold_rate_service.dart
│   ├── pdf_service.dart
│   └── csv_service.dart
├── widgets/              # Reusable widgets
│   ├── customer_card.dart
│   ├── dashboard_card.dart
│   ├── transaction_card.dart
│   └── chatbot_button.dart
├── utils/                # Utilities
│   ├── theme.dart
│   ├── constants.dart
│   ├── validators.dart
│   ├── date_helper.dart
│   └── currency_helper.dart
└── main.dart             # Entry point
```

## Key Features to Try

1. **Authentication**
   - Login with phone number
   - OTP verification

2. **Customer Management**
   - Add new customer
   - View customer list
   - See profit/loss indicators

3. **Transactions**
   - Add "You Got" transaction
   - Add "You Gave" transaction
   - Auto-calculation of totals

4. **Dashboard**
   - View overall summary
   - See total profit/loss
   - Customer count

5. **Reports**
   - Export customer statements (PDF/CSV)
   - View comprehensive reports

6. **AI Chatbot**
   - Click floating chat button
   - Ask about gold rates
   - Query customer balances

7. **Theme**
   - Toggle dark/light mode
   - See gradient UI

## Troubleshooting

### Build Failed
```bash
flutter clean
flutter pub get
flutter run
```

### Firebase Auth Not Working
- Check if google-services.json is in android/app/
- Verify Firebase Phone Auth is enabled
- Use test phone numbers for development

### Dependencies Error
```bash
flutter pub cache repair
flutter pub get
```

### Gradle Error (Android)
- Update Android Studio
- Update Gradle in android/gradle/wrapper/gradle-wrapper.properties
- Sync project

## Next Steps

- [ ] Customize theme colors in `lib/utils/theme.dart`
- [ ] Add your API keys
- [ ] Test all features
- [ ] Read full documentation:
  - [README.md](README.md) - Complete overview
  - [FIREBASE_SETUP.md](FIREBASE_SETUP.md) - Detailed Firebase setup
  - [API_SETUP.md](API_SETUP.md) - API configuration
  - [DEPLOYMENT.md](DEPLOYMENT.md) - Production deployment
  - [CONTRIBUTING.md](CONTRIBUTING.md) - How to contribute

## Support

If you encounter issues:

1. Check documentation files
2. Run `flutter doctor` and fix all issues
3. Check Firebase configuration
4. Verify API keys (if using)
5. Open an issue on GitHub

## Development Tips

- Use hot reload: Press `r` in terminal while app is running
- Use hot restart: Press `R` in terminal
- Enable Flutter DevTools for debugging
- Check Flutter logs for errors
- Use Firebase Console to view database

## Production Deployment

When ready to deploy:

1. Follow [DEPLOYMENT.md](DEPLOYMENT.md) guide
2. Set up proper signing keys
3. Test thoroughly
4. Submit to app stores

---

**Congratulations! You're all set to use Balaji Gold!** 🎉

For detailed information on any topic, refer to the specific documentation files in the repository.

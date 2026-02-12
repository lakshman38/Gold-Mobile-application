# Balaji Gold - Mobile Application

A colorful, modern finance-based mobile application for gold business management built with Flutter.

## Features

### 🔐 Authentication
- Mobile number login using Firebase OTP
- Secure Firebase Authentication
- Get Started screen with smooth animations

### 🏠 Home Screen
- Colorful dashboard with gradient cards
- Customer management with add/view functionality
- Real-time balance tracking
- Profit/Loss indicators with color coding (Green for profit, Red for loss)

### 💰 Customer Management
- Add customers with name and mobile number
- View customer list with balance information
- Customer statement page with detailed transactions
- Net balance calculation (Total You Got - Total You Gave)

### 📊 Transactions
- "You Got" (Incoming money - Green)
- "You Gave" (Outgoing money - Red)
- Transaction form with:
  - Amount
  - Gold weight (grams)
  - Rate per gram
  - Auto-calculation of total
- Date-wise transaction history
- Transaction filtering

### 🤖 AI Chatbot
- Floating chatbot button
- OpenAI API integration
- Query support for:
  - Current gold rates
  - Current silver rates
  - Customer balance queries
- Example queries:
  - "What is today's gold rate?"
  - "Show Ramesh balance"

### 📈 Gold & Silver Rates
- Real-time rate fetching from public API
- Rates stored in Firestore
- Automatic rate updates

### 📄 Reports & Downloads
- PDF generation for customer statements
- CSV export for customer statements
- Download all customer statements
- Comprehensive reports page

### 🎨 UI/UX Features
- Colorful gradients throughout the app
- Rounded cards with smooth animations
- Dark mode and light mode support
- Responsive layout
- Professional finance look
- Material Design 3

### 🔧 Technical Features
- Clean MVC/MVVM architecture
- Firebase Firestore backend
- Offline support with sync
- State management with Provider
- Modern Flutter best practices

## Architecture

```
lib/
├── controllers/       # State management controllers
├── models/           # Data models
├── screens/          # UI screens
├── services/         # Business logic and API services
├── widgets/          # Reusable widgets
└── utils/            # Utilities and themes
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Firebase project setup
- OpenAI API key (for chatbot)
- Gold/Silver rate API key (optional)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/lakshman38/Gold-Mobile-application.git
cd Gold-Mobile-application
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
   - Create a Firebase project at https://console.firebase.google.com
   - Add Android and iOS apps to your Firebase project
   - Download `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in `android/app/` and `ios/Runner/` respectively
   - Update `lib/firebase_options.dart` with your Firebase configuration

4. Configure API Keys:
   - Update OpenAI API key in `lib/services/chatbot_service.dart`
   - Update Gold/Silver rate API key in `lib/services/gold_rate_service.dart`

5. Run the app:
```bash
flutter run
```

## Firebase Setup

### Firestore Collections Structure

**customers**
```json
{
  "name": "string",
  "mobileNumber": "string",
  "netBalance": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

**transactions**
```json
{
  "customerId": "string",
  "type": "youGot | youGave",
  "amount": "number",
  "goldWeight": "number",
  "ratePerGram": "number",
  "total": "number",
  "date": "timestamp",
  "createdAt": "timestamp"
}
```

**rates**
```json
{
  "goldRate": "number",
  "silverRate": "number",
  "timestamp": "string",
  "currency": "string"
}
```

### Firebase Authentication
- Enable Phone Authentication in Firebase Console
- Configure phone authentication settings

## Dependencies

Key packages used:
- `firebase_core` & `firebase_auth` - Firebase integration
- `cloud_firestore` - Database
- `provider` - State management
- `google_fonts` - Custom fonts
- `fl_chart` - Charts and graphs
- `pdf` - PDF generation
- `csv` - CSV export
- `chat_gpt_sdk` - OpenAI integration
- `intl` - Internationalization and date formatting
- `shared_preferences` - Local storage

## Color Scheme

- Primary Green: #00C853 (Profit/You Got)
- Primary Red: #FF1744 (Loss/You Gave)
- Primary Blue: #2196F3 (Primary actions)
- Primary Purple: #9C27B0 (Accents)
- Primary Gold: #FFD700 (Branding)

## Supported Platforms
- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)

## Contributing
Contributions are welcome! Please feel free to submit a Pull Request.

## License
This project is licensed under the MIT License.

## Contact
For any queries or support, please contact the development team.

---
Made with ❤️ using Flutter

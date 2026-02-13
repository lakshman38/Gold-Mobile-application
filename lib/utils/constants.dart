class Constants {
  // App Information
  static const String appName = 'Balaji Gold';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Your Gold Business Manager';
  
  // Firebase Collections
  static const String customersCollection = 'customers';
  static const String transactionsCollection = 'transactions';
  static const String ratesCollection = 'rates';
  
  // Shared Preferences Keys
  static const String themeKey = 'isDarkMode';
  static const String languageKey = 'language';
  static const String firstLaunchKey = 'isFirstLaunch';
  
  // API Endpoints
  static const String metalPriceApiUrl = 'https://api.metalpriceapi.com/v1/latest';
  
  // Transaction Types
  static const String youGot = 'youGot';
  static const String youGave = 'youGave';
  
  // Default Values
  static const double defaultGoldRate = 6000.0;
  static const double defaultSilverRate = 70.0;
  static const String defaultCurrency = 'INR';
  static const String currencySymbol = '₹';
  
  // Limits
  static const int maxCustomerNameLength = 50;
  static const int minCustomerNameLength = 2;
  static const int phoneNumberLength = 10;
  static const int otpLength = 6;
  static const int maxTransactionAmount = 10000000; // 1 crore
  static const int maxGoldWeight = 10000; // grams
  
  // UI Constants
  static const double cardBorderRadius = 16.0;
  static const double buttonBorderRadius = 12.0;
  static const double defaultPadding = 16.0;
  static const double defaultElevation = 4.0;
  
  // Animation Durations
  static const int splashDuration = 3000; // milliseconds
  static const int animationDuration = 300; // milliseconds
  static const int chatbotAnimationDuration = 1500; // milliseconds
  
  // Pagination
  static const int itemsPerPage = 20;
  static const int maxItemsPerPage = 100;
  
  // Date Formats
  static const String displayDateFormat = 'dd MMM yyyy';
  static const String displayDateTimeFormat = 'dd MMM yyyy, hh:mm a';
  static const String apiDateFormat = 'yyyy-MM-dd';
  
  // Error Messages
  static const String networkError = 'Network error. Please check your internet connection.';
  static const String authError = 'Authentication failed. Please try again.';
  static const String firestoreError = 'Database error. Please try again later.';
  static const String unknownError = 'Something went wrong. Please try again.';
  
  // Success Messages
  static const String customerAddedSuccess = 'Customer added successfully';
  static const String transactionAddedSuccess = 'Transaction added successfully';
  static const String pdfGeneratedSuccess = 'PDF generated successfully';
  static const String csvGeneratedSuccess = 'CSV generated successfully';
  
  // Chatbot Messages
  static const String chatbotWelcome = 'Hello! I\'m your AI assistant. I can help you with:\n'
      '• Current gold and silver rates\n'
      '• Customer balance queries\n'
      '• General questions about the app\n\n'
      'Try asking: "What is today\'s gold rate?"';
  
  // Phone Country Codes
  static const List<String> countryCodes = ['+91', '+1', '+44', '+61', '+971'];
  
  // Color Names (for reference)
  static const String colorPrimaryGreen = 'Primary Green (#00C853)';
  static const String colorPrimaryRed = 'Primary Red (#FF1744)';
  static const String colorPrimaryBlue = 'Primary Blue (#2196F3)';
  static const String colorPrimaryPurple = 'Primary Purple (#9C27B0)';
  static const String colorPrimaryGold = 'Primary Gold (#FFD700)';
}

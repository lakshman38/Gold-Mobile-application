class Validators {
  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter mobile number';
    }
    
    // Remove spaces and special characters
    String cleaned = value.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check if it contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(cleaned)) {
      return 'Please enter valid mobile number';
    }
    
    // Check length (10 digits for most countries)
    if (cleaned.length < 10 || cleaned.length > 15) {
      return 'Mobile number must be between 10-15 digits';
    }
    
    return null;
  }
  
  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter name';
    }
    
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    if (value.length > 50) {
      return 'Name must not exceed 50 characters';
    }
    
    // Check if name contains only letters and spaces
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    
    return null;
  }
  
  // Amount validation
  static String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter amount';
    }
    
    final amount = double.tryParse(value);
    
    if (amount == null) {
      return 'Please enter valid amount';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    return null;
  }
  
  // Weight validation
  static String? validateWeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter weight';
    }
    
    final weight = double.tryParse(value);
    
    if (weight == null) {
      return 'Please enter valid weight';
    }
    
    if (weight <= 0) {
      return 'Weight must be greater than 0';
    }
    
    if (weight > 10000) {
      return 'Weight seems unusually high';
    }
    
    return null;
  }
  
  // Rate validation
  static String? validateRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter rate';
    }
    
    final rate = double.tryParse(value);
    
    if (rate == null) {
      return 'Please enter valid rate';
    }
    
    if (rate <= 0) {
      return 'Rate must be greater than 0';
    }
    
    return null;
  }
  
  // OTP validation
  static String? validateOTP(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter OTP';
    }
    
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      return 'OTP must contain only digits';
    }
    
    return null;
  }
  
  // Email validation (optional, for future use)
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }
    
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter valid email';
    }
    
    return null;
  }
}

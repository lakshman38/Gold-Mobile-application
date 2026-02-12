import 'package:intl/intl.dart';

class CurrencyHelper {
  static final NumberFormat currencyFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 2,
  );
  
  static final NumberFormat compactCurrencyFormat = NumberFormat.compactCurrency(
    symbol: '₹',
    decimalDigits: 1,
  );
  
  static String formatCurrency(double amount) {
    return currencyFormat.format(amount);
  }
  
  static String formatCompactCurrency(double amount) {
    return compactCurrencyFormat.format(amount);
  }
  
  static String formatWithoutSymbol(double amount) {
    return amount.toStringAsFixed(2);
  }
  
  static double? parseAmount(String? amountString) {
    if (amountString == null || amountString.isEmpty) return null;
    
    // Remove currency symbols and commas
    String cleaned = amountString.replaceAll(RegExp(r'[₹,\s]'), '');
    
    try {
      return double.parse(cleaned);
    } catch (e) {
      return null;
    }
  }
  
  static String formatPercentage(double value, {int decimals = 2}) {
    return '${value.toStringAsFixed(decimals)}%';
  }
}

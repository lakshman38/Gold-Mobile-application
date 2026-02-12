import 'package:flutter/material.dart';
import '../models/customer.dart';
import '../models/transaction.dart';
import '../services/customer_service.dart';

class CustomerController extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();
  
  List<Customer> _customers = [];
  List<Transaction> _transactions = [];
  bool _isLoading = false;
  
  List<Customer> get customers => _customers;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading;

  // Load all customers
  Future<void> loadCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      _customers = await _customerService.getCustomers();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add a new customer
  Future<void> addCustomer(String name, String mobileNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      final customer = Customer(
        id: '',
        name: name,
        mobileNumber: mobileNumber,
      );
      await _customerService.addCustomer(customer);
      await loadCustomers();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Load transactions for a customer
  Future<void> loadTransactions(String customerId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _customerService.getTransactions(customerId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Add a transaction
  Future<void> addTransaction({
    required String customerId,
    required TransactionType type,
    required double amount,
    required double goldWeight,
    required double ratePerGram,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final transaction = Transaction(
        id: '',
        customerId: customerId,
        type: type,
        amount: amount,
        goldWeight: goldWeight,
        ratePerGram: ratePerGram,
      );
      
      await _customerService.addTransaction(transaction);
      await loadTransactions(customerId);
      await loadCustomers(); // Reload to update balances
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Calculate customer balance
  double getCustomerBalance(String customerId) {
    final customerTransactions = _transactions
        .where((t) => t.customerId == customerId)
        .toList();
    
    double totalGot = customerTransactions
        .where((t) => t.type == TransactionType.youGot)
        .fold(0.0, (sum, t) => sum + t.total);
    
    double totalGave = customerTransactions
        .where((t) => t.type == TransactionType.youGave)
        .fold(0.0, (sum, t) => sum + t.total);
    
    return totalGot - totalGave;
  }

  // Get filtered transactions by date
  List<Transaction> getTransactionsByDateRange(
    String customerId,
    DateTime startDate,
    DateTime endDate,
  ) {
    return _transactions
        .where((t) =>
            t.customerId == customerId &&
            t.date.isAfter(startDate) &&
            t.date.isBefore(endDate))
        .toList();
  }
}

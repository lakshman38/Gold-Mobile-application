import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer.dart';
import '../models/transaction.dart';

class CustomerService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all customers
  Future<List<Customer>> getCustomers() async {
    try {
      final snapshot = await _firestore
          .collection('customers')
          .orderBy('createdAt', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => Customer.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load customers: $e');
    }
  }

  // Add a new customer
  Future<void> addCustomer(Customer customer) async {
    try {
      await _firestore.collection('customers').add(customer.toMap());
    } catch (e) {
      throw Exception('Failed to add customer: $e');
    }
  }

  // Update customer
  Future<void> updateCustomer(Customer customer) async {
    try {
      await _firestore
          .collection('customers')
          .doc(customer.id)
          .update(customer.toMap());
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  // Get transactions for a customer
  Future<List<Transaction>> getTransactions(String customerId) async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .where('customerId', isEqualTo: customerId)
          .orderBy('date', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => Transaction.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load transactions: $e');
    }
  }

  // Add a transaction
  Future<void> addTransaction(Transaction transaction) async {
    try {
      // Add transaction
      await _firestore.collection('transactions').add(transaction.toMap());

      // Update customer balance
      await _updateCustomerBalance(transaction.customerId);
    } catch (e) {
      throw Exception('Failed to add transaction: $e');
    }
  }

  // Update customer balance based on transactions
  Future<void> _updateCustomerBalance(String customerId) async {
    try {
      final transactions = await getTransactions(customerId);
      
      double totalGot = transactions
          .where((t) => t.type == TransactionType.youGot)
          .fold(0.0, (sum, t) => sum + t.total);
      
      double totalGave = transactions
          .where((t) => t.type == TransactionType.youGave)
          .fold(0.0, (sum, t) => sum + t.total);
      
      double netBalance = totalGot - totalGave;

      await _firestore.collection('customers').doc(customerId).update({
        'netBalance': netBalance,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update customer balance: $e');
    }
  }

  // Get all transactions (for reports)
  Future<List<Transaction>> getAllTransactions() async {
    try {
      final snapshot = await _firestore
          .collection('transactions')
          .orderBy('date', descending: true)
          .get();
      
      return snapshot.docs.map((doc) => Transaction.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to load all transactions: $e');
    }
  }
}

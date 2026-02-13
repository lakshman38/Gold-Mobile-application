import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/customer.dart';
import '../models/transaction.dart';

class CsvService {
  Future<File> generateCustomerStatement(
    Customer customer,
    List<Transaction> transactions,
  ) async {
    final dateFormat = DateFormat('dd-MM-yyyy HH:mm');
    
    // Create CSV data
    List<List<dynamic>> rows = [];
    
    // Header
    rows.add(['Balaji Gold - Customer Statement']);
    rows.add([]);
    rows.add(['Customer Name:', customer.name]);
    rows.add(['Mobile Number:', customer.mobileNumber]);
    rows.add(['Statement Date:', dateFormat.format(DateTime.now())]);
    rows.add([]);
    
    // Transaction Header
    rows.add(['Date', 'Type', 'Gold Weight (g)', 'Rate per Gram', 'Total Amount']);
    
    // Transactions
    for (var transaction in transactions) {
      rows.add([
        dateFormat.format(transaction.date),
        transaction.type == TransactionType.youGot ? 'You Got' : 'You Gave',
        transaction.goldWeight.toStringAsFixed(2),
        transaction.ratePerGram.toStringAsFixed(2),
        transaction.total.toStringAsFixed(2),
      ]);
    }
    
    // Summary
    double totalGot = transactions
        .where((t) => t.type == TransactionType.youGot)
        .fold(0.0, (sum, t) => sum + t.total);
    
    double totalGave = transactions
        .where((t) => t.type == TransactionType.youGave)
        .fold(0.0, (sum, t) => sum + t.total);
    
    double netBalance = totalGot - totalGave;
    
    rows.add([]);
    rows.add(['Summary']);
    rows.add(['Total You Got:', totalGot.toStringAsFixed(2)]);
    rows.add(['Total You Gave:', totalGave.toStringAsFixed(2)]);
    rows.add(['Net Balance:', netBalance.toStringAsFixed(2)]);

    // Convert to CSV
    String csv = const ListToCsvConverter().convert(rows);

    // Save CSV
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/statement_${customer.name}_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    
    return file;
  }

  Future<File> generateAllCustomersReport(
    List<Customer> customers,
    Map<String, List<Transaction>> customerTransactions,
  ) async {
    final dateFormat = DateFormat('dd-MM-yyyy HH:mm');
    
    // Create CSV data
    List<List<dynamic>> rows = [];
    
    // Header
    rows.add(['Balaji Gold - All Customers Report']);
    rows.add(['Report Date:', dateFormat.format(DateTime.now())]);
    rows.add([]);
    
    // Customer Summary Header
    rows.add(['Customer Name', 'Mobile Number', 'Net Balance', 'Total Transactions']);
    
    // Customers Summary
    for (var customer in customers) {
      final transactions = customerTransactions[customer.id] ?? [];
      rows.add([
        customer.name,
        customer.mobileNumber,
        customer.netBalance.toStringAsFixed(2),
        transactions.length.toString(),
      ]);
    }
    
    rows.add([]);
    rows.add(['Detailed Transactions']);
    rows.add([]);
    
    // Detailed transactions for each customer
    for (var customer in customers) {
      final transactions = customerTransactions[customer.id] ?? [];
      if (transactions.isEmpty) continue;
      
      rows.add(['Customer:', customer.name, 'Mobile:', customer.mobileNumber]);
      rows.add(['Date', 'Type', 'Gold Weight (g)', 'Rate per Gram', 'Total Amount']);
      
      for (var transaction in transactions) {
        rows.add([
          dateFormat.format(transaction.date),
          transaction.type == TransactionType.youGot ? 'You Got' : 'You Gave',
          transaction.goldWeight.toStringAsFixed(2),
          transaction.ratePerGram.toStringAsFixed(2),
          transaction.total.toStringAsFixed(2),
        ]);
      }
      
      rows.add([]);
    }

    // Convert to CSV
    String csv = const ListToCsvConverter().convert(rows);

    // Save CSV
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/all_customers_report_${DateTime.now().millisecondsSinceEpoch}.csv');
    await file.writeAsString(csv);
    
    return file;
  }
}

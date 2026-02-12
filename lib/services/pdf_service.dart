import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import '../models/customer.dart';
import '../models/transaction.dart';

class PdfService {
  Future<File> generateCustomerStatement(
    Customer customer,
    List<Transaction> transactions,
  ) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd MMM yyyy');
    final currencyFormat = NumberFormat.currency(symbol: '₹');

    // Calculate totals
    double totalGot = transactions
        .where((t) => t.type == TransactionType.youGot)
        .fold(0.0, (sum, t) => sum + t.total);
    
    double totalGave = transactions
        .where((t) => t.type == TransactionType.youGave)
        .fold(0.0, (sum, t) => sum + t.total);
    
    double netBalance = totalGot - totalGave;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          // Header
          pw.Header(
            level: 0,
            child: pw.Text(
              'Balaji Gold - Customer Statement',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          
          // Customer Info
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Customer Name: ${customer.name}',
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Text('Mobile Number: ${customer.mobileNumber}'),
                pw.SizedBox(height: 5),
                pw.Text('Statement Date: ${dateFormat.format(DateTime.now())}'),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Summary
          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.grey100,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total You Got:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(currencyFormat.format(totalGot), style: const pw.TextStyle(color: PdfColors.green)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Total You Gave:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text(currencyFormat.format(totalGave), style: const pw.TextStyle(color: PdfColors.red)),
                  ],
                ),
                pw.Divider(),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Net Balance:', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      currencyFormat.format(netBalance.abs()),
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                        color: netBalance >= 0 ? PdfColors.green : PdfColors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // Transactions Table
          pw.Text('Transaction History',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            children: [
              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Date', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Weight (g)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Rate', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text('Amount', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
              // Data Rows
              ...transactions.map((t) => pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(dateFormat.format(t.date)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      t.type == TransactionType.youGot ? 'You Got' : 'You Gave',
                      style: pw.TextStyle(
                        color: t.type == TransactionType.youGot ? PdfColors.green : PdfColors.red,
                      ),
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(t.goldWeight.toStringAsFixed(2)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(currencyFormat.format(t.ratePerGram)),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(currencyFormat.format(t.total)),
                  ),
                ],
              )),
            ],
          ),
        ],
      ),
    );

    // Save PDF
    final output = await getApplicationDocumentsDirectory();
    final file = File('${output.path}/statement_${customer.name}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    
    return file;
  }
}

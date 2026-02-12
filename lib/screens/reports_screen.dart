import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/customer_controller.dart';
import '../services/csv_service.dart';
import '../utils/theme.dart';
import '../models/transaction.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  void _exportAllCustomers(BuildContext context) async {
    final controller = context.read<CustomerController>();
    final customers = controller.customers;

    try {
      // Get all transactions for each customer
      Map<String, List<Transaction>> customerTransactions = {};
      for (var customer in customers) {
        await controller.loadTransactions(customer.id);
        customerTransactions[customer.id] = List.from(controller.transactions);
      }

      final csvService = CsvService();
      final file = await csvService.generateAllCustomersReport(
        customers,
        customerTransactions,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Report saved to ${file.path}'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate report: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCard(context),
            const SizedBox(height: 24),
            _buildExportSection(context),
            const SizedBox(height: 24),
            _buildCustomerBreakdown(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context) {
    return Consumer<CustomerController>(
      builder: (context, controller, _) {
        final customers = controller.customers;

        double totalProfit = 0;
        double totalLoss = 0;
        int profitCustomers = 0;
        int lossCustomers = 0;

        for (var customer in customers) {
          if (customer.netBalance >= 0) {
            totalProfit += customer.netBalance;
            profitCustomers++;
          } else {
            totalLoss += customer.netBalance.abs();
            lossCustomers++;
          }
        }

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: AppTheme.purpleGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Overall Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildSummaryRow('Total Customers', customers.length.toString(), Icons.people),
              const SizedBox(height: 12),
              _buildSummaryRow('Profit Customers', profitCustomers.toString(), Icons.trending_up),
              const SizedBox(height: 12),
              _buildSummaryRow('Loss Customers', lossCustomers.toString(), Icons.trending_down),
              const SizedBox(height: 12),
              _buildSummaryRow('Total Profit', '₹${totalProfit.toStringAsFixed(2)}', Icons.add_circle),
              const SizedBox(height: 12),
              _buildSummaryRow('Total Loss', '₹${totalLoss.toStringAsFixed(2)}', Icons.remove_circle),
              const Divider(color: Colors.white54, height: 32),
              _buildSummaryRow(
                'Net Balance',
                '₹${(totalProfit - totalLoss).toStringAsFixed(2)}',
                Icons.account_balance_wallet,
                isTotal: true,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon, {bool isTotal = false}) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: isTotal ? 20 : 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildExportSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Export Reports',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _exportAllCustomers(context),
            icon: const Icon(Icons.download),
            label: const Text('Download All Customer Statements (CSV)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerBreakdown(BuildContext context) {
    return Consumer<CustomerController>(
      builder: (context, controller, _) {
        final customers = controller.customers;

        if (customers.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('No customers to display'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final customer = customers[index];
                final isProfit = customer.netBalance >= 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isProfit
                          ? AppTheme.primaryGreen
                          : AppTheme.primaryRed,
                      child: Icon(
                        isProfit ? Icons.trending_up : Icons.trending_down,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      customer.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(customer.mobileNumber),
                    trailing: Text(
                      '₹${customer.netBalance.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        color: isProfit
                            ? AppTheme.primaryGreen
                            : AppTheme.primaryRed,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

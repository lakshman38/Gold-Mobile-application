import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/customer.dart';
import '../models/transaction.dart';
import '../controllers/customer_controller.dart';
import '../utils/theme.dart';
import '../widgets/transaction_card.dart';
import '../services/pdf_service.dart';
import '../services/csv_service.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  const CustomerDetailScreen({super.key, required this.customer});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _weightController = TextEditingController();
  final _rateController = TextEditingController();
  double _calculatedTotal = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CustomerController>().loadTransactions(widget.customer.id);
    });

    // Add listeners for auto-calculation
    _weightController.addListener(_calculateTotal);
    _rateController.addListener(_calculateTotal);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _weightController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final weight = double.tryParse(_weightController.text) ?? 0.0;
    final rate = double.tryParse(_rateController.text) ?? 0.0;
    setState(() {
      _calculatedTotal = weight * rate;
    });
  }

  void _addTransaction(TransactionType type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: type == TransactionType.youGot
                            ? AppTheme.profitGradient
                            : AppTheme.lossGradient,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        type == TransactionType.youGot
                            ? Icons.arrow_downward
                            : Icons.arrow_upward,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      type == TransactionType.youGot ? 'You Got' : 'You Gave',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Gold Weight (grams)',
                    prefixIcon: Icon(Icons.scale),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter weight';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Rate per Gram',
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter rate';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${_calculatedTotal.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: type == TransactionType.youGot
                              ? AppTheme.primaryGreen
                              : AppTheme.primaryRed,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<CustomerController>(
                  builder: (context, controller, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () => _submitTransaction(type),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: type == TransactionType.youGot
                              ? AppTheme.primaryGreen
                              : AppTheme.primaryRed,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: controller.isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Add Transaction',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitTransaction(TransactionType type) async {
    if (_formKey.currentState!.validate()) {
      final controller = context.read<CustomerController>();

      try {
        await controller.addTransaction(
          customerId: widget.customer.id,
          type: type,
          amount: _calculatedTotal,
          goldWeight: double.parse(_weightController.text),
          ratePerGram: double.parse(_rateController.text),
        );

        if (mounted) {
          Navigator.of(context).pop();
          _weightController.clear();
          _rateController.clear();
          setState(() {
            _calculatedTotal = 0.0;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaction added successfully'),
              backgroundColor: AppTheme.primaryGreen,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add transaction: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _exportPDF() async {
    final controller = context.read<CustomerController>();
    final transactions = controller.transactions;

    try {
      final pdfService = PdfService();
      final file = await pdfService.generateCustomerStatement(
        widget.customer,
        transactions,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to ${file.path}'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _exportCSV() async {
    final controller = context.read<CustomerController>();
    final transactions = controller.transactions;

    try {
      final csvService = CsvService();
      final file = await csvService.generateCustomerStatement(
        widget.customer,
        transactions,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('CSV saved to ${file.path}'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate CSV: ${e.toString()}'),
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
        title: Text(widget.customer.name),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pdf',
                child: Row(
                  children: [
                    Icon(Icons.picture_as_pdf, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Export PDF'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'csv',
                child: Row(
                  children: [
                    Icon(Icons.table_chart, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Export CSV'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              if (value == 'pdf') {
                _exportPDF();
              } else if (value == 'csv') {
                _exportCSV();
              }
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<CustomerController>().loadTransactions(widget.customer.id);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildHeader(),
              _buildActionButtons(),
              _buildTransactionList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer<CustomerController>(
      builder: (context, controller, _) {
        final balance = widget.customer.netBalance;
        final isProfit = balance >= 0;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: isProfit ? AppTheme.profitGradient : AppTheme.lossGradient,
          ),
          child: Column(
            children: [
              const Text(
                'Net Balance',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '₹${balance.abs().toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isProfit ? 'Profit' : 'Loss',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.customer.mobileNumber,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _addTransaction(TransactionType.youGot),
              icon: const Icon(Icons.arrow_downward),
              label: const Text('You Got'),
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
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _addTransaction(TransactionType.youGave),
              icon: const Icon(Icons.arrow_upward),
              label: const Text('You Gave'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList() {
    return Consumer<CustomerController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final transactions = controller.transactions;

        if (transactions.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Transaction History',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return TransactionCard(transaction: transaction);
              },
            ),
          ],
        );
      },
    );
  }
}

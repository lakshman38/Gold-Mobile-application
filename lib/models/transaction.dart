import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { youGot, youGave }

class Transaction {
  final String id;
  final String customerId;
  final TransactionType type;
  final double amount;
  final double goldWeight; // in grams
  final double ratePerGram;
  final double total;
  final DateTime date;
  final DateTime createdAt;

  Transaction({
    required this.id,
    required this.customerId,
    required this.type,
    required this.amount,
    required this.goldWeight,
    required this.ratePerGram,
    DateTime? date,
    DateTime? createdAt,
  })  : total = goldWeight * ratePerGram,
        date = date ?? DateTime.now(),
        createdAt = createdAt ?? DateTime.now();

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'type': type.toString().split('.').last,
      'amount': amount,
      'goldWeight': goldWeight,
      'ratePerGram': ratePerGram,
      'total': total,
      'date': Timestamp.fromDate(date),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // Create from Firestore document
  factory Transaction.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Transaction(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      type: data['type'] == 'youGot' 
          ? TransactionType.youGot 
          : TransactionType.youGave,
      amount: (data['amount'] ?? 0.0).toDouble(),
      goldWeight: (data['goldWeight'] ?? 0.0).toDouble(),
      ratePerGram: (data['ratePerGram'] ?? 0.0).toDouble(),
      date: (data['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Transaction copyWith({
    String? id,
    String? customerId,
    TransactionType? type,
    double? amount,
    double? goldWeight,
    double? ratePerGram,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Transaction(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      goldWeight: goldWeight ?? this.goldWeight,
      ratePerGram: ratePerGram ?? this.ratePerGram,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

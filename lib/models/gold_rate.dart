class GoldRate {
  final double goldRate;
  final double silverRate;
  final DateTime timestamp;
  final String currency;

  GoldRate({
    required this.goldRate,
    required this.silverRate,
    DateTime? timestamp,
    this.currency = 'INR',
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'goldRate': goldRate,
      'silverRate': silverRate,
      'timestamp': timestamp.toIso8601String(),
      'currency': currency,
    };
  }

  factory GoldRate.fromMap(Map<String, dynamic> map) {
    return GoldRate(
      goldRate: (map['goldRate'] ?? 0.0).toDouble(),
      silverRate: (map['silverRate'] ?? 0.0).toDouble(),
      timestamp: map['timestamp'] != null 
          ? DateTime.parse(map['timestamp']) 
          : DateTime.now(),
      currency: map['currency'] ?? 'INR',
    );
  }
}

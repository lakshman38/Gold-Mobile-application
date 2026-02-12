import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/gold_rate.dart';

class GoldRateService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Fetch gold and silver rates from a public API
  // Note: This is a mock implementation. Replace with actual API endpoint
  Future<GoldRate> fetchCurrentRates() async {
    try {
      // Mock API endpoint - Replace with actual API
      // Example: https://api.metalpriceapi.com/v1/latest
      final response = await http.get(
        Uri.parse('https://api.metalpriceapi.com/v1/latest?api_key=YOUR_API_KEY&base=INR&currencies=XAU,XAG'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Parse rates (adjust based on actual API response structure)
        final goldRate = (data['rates']['XAU'] ?? 6000.0).toDouble();
        final silverRate = (data['rates']['XAG'] ?? 70.0).toDouble();
        
        final rates = GoldRate(
          goldRate: goldRate,
          silverRate: silverRate,
        );

        // Store in Firestore
        await _storeRatesInFirestore(rates);
        
        return rates;
      } else {
        // Fallback to stored rates if API fails
        return await getStoredRates();
      }
    } catch (e) {
      // Fallback to stored rates if API fails
      return await getStoredRates();
    }
  }

  // Store rates in Firestore
  Future<void> _storeRatesInFirestore(GoldRate rates) async {
    try {
      await _firestore.collection('rates').doc('latest').set(rates.toMap());
    } catch (e) {
      throw Exception('Failed to store rates: $e');
    }
  }

  // Get stored rates from Firestore
  Future<GoldRate> getStoredRates() async {
    try {
      final doc = await _firestore.collection('rates').doc('latest').get();
      
      if (doc.exists) {
        return GoldRate.fromMap(doc.data() as Map<String, dynamic>);
      } else {
        // Return default rates if none stored
        return GoldRate(
          goldRate: 6000.0,
          silverRate: 70.0,
        );
      }
    } catch (e) {
      // Return default rates on error
      return GoldRate(
        goldRate: 6000.0,
        silverRate: 70.0,
      );
    }
  }
}

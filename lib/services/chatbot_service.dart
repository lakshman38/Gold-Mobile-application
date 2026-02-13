import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import '../models/customer.dart';
import 'gold_rate_service.dart';
import 'customer_service.dart';

class ChatbotService {
  late OpenAI _openAI;
  final GoldRateService _goldRateService = GoldRateService();
  final CustomerService _customerService = CustomerService();

  ChatbotService() {
    // Initialize OpenAI - Replace with your API key
    _openAI = OpenAI.instance.build(
      token: 'YOUR_OPENAI_API_KEY',
      baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 30)),
      enableLog: true,
    );
  }

  Future<String> sendMessage(String message) async {
    try {
      // Check if message is about gold/silver rates
      if (_isRateQuery(message)) {
        return await _handleRateQuery(message);
      }
      
      // Check if message is about customer balance
      if (_isBalanceQuery(message)) {
        return await _handleBalanceQuery(message);
      }

      // For general queries, use OpenAI
      final request = ChatCompleteText(
        messages: [
          Messages(
            role: Role.system,
            content: 'You are a helpful assistant for Balaji Gold, a gold business management app. '
                'You can help with gold rates, silver rates, and customer balance queries.',
          ),
          Messages(
            role: Role.user,
            content: message,
          ),
        ],
        maxToken: 200,
        model: Gpt4ChatModel(),
      );

      final response = await _openAI.onChatCompletion(request: request);
      
      if (response != null && response.choices.isNotEmpty) {
        return response.choices.first.message?.content ?? 'Sorry, I could not process that.';
      }
      
      return 'Sorry, I could not process that.';
    } catch (e) {
      return 'Sorry, I encountered an error: ${e.toString()}';
    }
  }

  bool _isRateQuery(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('gold rate') ||
        lowerMessage.contains('silver rate') ||
        lowerMessage.contains('today') && (lowerMessage.contains('gold') || lowerMessage.contains('silver'));
  }

  bool _isBalanceQuery(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('balance') ||
        lowerMessage.contains('show') ||
        lowerMessage.contains('customer');
  }

  Future<String> _handleRateQuery(String message) async {
    try {
      final rates = await _goldRateService.getStoredRates();
      
      if (message.toLowerCase().contains('gold')) {
        return 'Current Gold Rate: ₹${rates.goldRate.toStringAsFixed(2)} per gram';
      } else if (message.toLowerCase().contains('silver')) {
        return 'Current Silver Rate: ₹${rates.silverRate.toStringAsFixed(2)} per gram';
      } else {
        return 'Current Rates:\n'
            'Gold: ₹${rates.goldRate.toStringAsFixed(2)} per gram\n'
            'Silver: ₹${rates.silverRate.toStringAsFixed(2)} per gram';
      }
    } catch (e) {
      return 'Sorry, I could not fetch the current rates.';
    }
  }

  Future<String> _handleBalanceQuery(String message) async {
    try {
      // Extract customer name from message
      final customers = await _customerService.getCustomers();
      
      // Simple name matching - can be improved with better NLP
      Customer? matchedCustomer;
      for (var customer in customers) {
        if (message.toLowerCase().contains(customer.name.toLowerCase())) {
          matchedCustomer = customer;
          break;
        }
      }

      if (matchedCustomer != null) {
        final balance = matchedCustomer.netBalance;
        final status = balance >= 0 ? 'profit' : 'loss';
        final absBalance = balance.abs();
        
        return '${matchedCustomer.name}\'s Balance:\n'
            '₹${absBalance.toStringAsFixed(2)} ($status)\n'
            'Mobile: ${matchedCustomer.mobileNumber}';
      } else {
        return 'I could not find that customer. Please check the name and try again.';
      }
    } catch (e) {
      return 'Sorry, I could not fetch customer balance.';
    }
  }
}

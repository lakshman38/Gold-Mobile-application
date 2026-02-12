import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthController extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  String? _verificationId;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthController() {
    _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> sendOTP(String phoneNumber) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.sendOTP(
        phoneNumber: phoneNumber,
        codeSent: (verificationId, forceResendingToken) {
          _verificationId = verificationId;
          _isLoading = false;
          notifyListeners();
        },
        verificationFailed: (error) {
          _isLoading = false;
          notifyListeners();
          throw error;
        },
      );
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> verifyOTP(String otp) async {
    if (_verificationId == null) {
      throw Exception('Please send OTP first');
    }

    _isLoading = true;
    notifyListeners();

    try {
      await _authService.verifyOTP(
        verificationId: _verificationId!,
        otp: otp,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    _verificationId = null;
    notifyListeners();
  }
}

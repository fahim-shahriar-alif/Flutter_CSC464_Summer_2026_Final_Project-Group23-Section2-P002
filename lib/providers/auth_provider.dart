import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  String? _loggedInUsername;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoggedIn => _loggedInUsername != null;
  String get loggedInUsername => _loggedInUsername ?? '';
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> signIn(String username, String password) async {
    _startLoading();
    _loggedInUsername = username.trim().isEmpty ? 'Player' : username.trim();
    _stopLoading();
  }

  Future<void> signUp(String username, String password) async {
    await signIn(username, password);
  }

  Future<void> signInWithGoogle() async {
    _startLoading();
    _loggedInUsername = 'Google Player';
    _stopLoading();
  }

  Future<void> signOut() async {
    _loggedInUsername = null;
    _errorMessage = null;
    notifyListeners();
  }

  void _startLoading() {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _stopLoading() {
    _isLoading = false;
    notifyListeners();
  }
}
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService() {
    _listenToAuthChanges();
  }

  final AuthService _authService;
  StreamSubscription<User?>? _authSubscription;

  bool _isLoading = false;
  String? _errorMessage;
  User? _user;

  bool get isFirebaseReady => _authService.isFirebaseReady;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  User? get currentUser => _user;

  String get loggedInUsername {
    final user = _user;
    if (user == null) return '';
    if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
      return user.displayName!.trim();
    }
    if (user.email != null && user.email!.trim().isNotEmpty) {
      return user.email!.trim();
    }
    return 'Player';
  }

  void _listenToAuthChanges() {
    _user = _authService.currentUser;
    _authSubscription?.cancel();
    _authSubscription = _authService.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    await _runAuthAction(() => _authService.signIn(email, password));
  }

  Future<void> signUp(String email, String password) async {
    await _runAuthAction(() => _authService.signUp(email, password));
  }

  Future<void> signInWithGoogle() async {
    _startLoading();

    try {
      if (!_authService.isFirebaseReady) {
        _errorMessage =
            'Firebase is not configured. Add google-services.json / GoogleService-Info.plist.';
        return;
      }

      final credential = await _authService.signInWithGoogle();
      if (credential == null) {
        // User cancelled the Google account picker.
        _errorMessage = null;
        return;
      }
      _user = credential.user ?? _authService.currentUser;
    } on FirebaseAuthException catch (error) {
      _errorMessage = _mapFirebaseAuthError(error);
    } on StateError catch (error) {
      _errorMessage = error.message;
    } catch (error) {
      _errorMessage = 'Google sign-in failed. Please try again.';
      debugPrint('AuthProvider.signInWithGoogle error: $error');
    } finally {
      _stopLoading();
    }
  }

  Future<void> signOut() async {
    _startLoading();
    try {
      await _authService.signOut();
      _user = null;
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Could not sign out. Please try again.';
      debugPrint('AuthProvider.signOut error: $error');
    } finally {
      _stopLoading();
    }
  }

  Future<void> _runAuthAction(
    Future<UserCredential> Function() action,
  ) async {
    _startLoading();

    try {
      if (!_authService.isFirebaseReady) {
        _errorMessage =
            'Firebase is not configured. Add google-services.json / GoogleService-Info.plist.';
        return;
      }

      final credential = await action();
      _user = credential.user ?? _authService.currentUser;
    } on FirebaseAuthException catch (error) {
      _errorMessage = _mapFirebaseAuthError(error);
    } on StateError catch (error) {
      _errorMessage = error.message;
    } catch (error) {
      _errorMessage = 'Something went wrong. Please try again.';
      debugPrint('AuthProvider auth action error: $error');
    } finally {
      _stopLoading();
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'That email is already registered. Try logging in.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait and try again.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
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

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}

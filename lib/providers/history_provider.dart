import 'package:flutter/foundation.dart';
import '../models/match_model.dart';
import '../services/firestore_service.dart';

class HistoryProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<MatchModel> _matches = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<MatchModel> get matches => _matches;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMatches() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _matches = await _firestoreService.getMatches();
    } catch (error) {
      _matches = [];
      _errorMessage = 'Could not load match history. Check your connection.';
      debugPrint('HistoryProvider.loadMatches error: $error');
    }

    _isLoading = false;
    notifyListeners();
  }
}
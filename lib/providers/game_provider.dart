import 'package:flutter/foundation.dart';
import '../models/match_model.dart';
import '../services/firestore_service.dart';

class GameProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();

  List<String> _board = List.filled(9, '');
  String _currentPlayer = 'X';
  String _startingPlayer = 'X';
  String _player1Name = 'Player 1';
  String _player2Name = 'Player 2';
  String? _winner;
  bool _isGameOver = false;
  int _xWins = 0;
  int _oWins = 0;
  int _ties = 0;
  bool _matchSaveFailed = false;

  List<String> get board => _board;
  String get currentPlayer => _currentPlayer;
  String get startingPlayer => _startingPlayer;
  String get player1Name => _player1Name;
  String get player2Name => _player2Name;
  String? get winner => _winner;
  bool get isGameOver => _isGameOver;
  int get xWins => _xWins;
  int get oWins => _oWins;
  int get ties => _ties;
  bool get matchSaveFailed => _matchSaveFailed;

  String get currentPlayerName =>
      _currentPlayer == 'X' ? _player1Name : _player2Name;

  void setPlayerNames(String player1, String player2) {
    _player1Name = player1.trim();
    _player2Name = player2.trim();
    resetBoard();
  }
  void updateScore(String winner) {
    if (winner == 'X') {
      _xWins++;
    } else if (winner == 'O') {
      _oWins++;
    } else {
      _ties++;
    }
  }
  void resetBoard() {
    _board = List.filled(9, '');
    _currentPlayer = _startingPlayer;
    _winner = null;
    _isGameOver = false;
    _matchSaveFailed = false;
    notifyListeners();
  }
  void switchStartingPlayer() {}

  void makeMove(int cellIndex) {}
  String? checkWin() => null;
  bool checkTie() => false;
  Future<void> saveMatchToFirestore() async {}
}
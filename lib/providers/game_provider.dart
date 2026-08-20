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

  void switchStartingPlayer() {
    _startingPlayer = _startingPlayer == 'X' ? 'O' : 'X';
    resetBoard();
  }

  void makeMove(int cellIndex) {
    if (_isGameOver) return;
    if (_board[cellIndex].isNotEmpty) return;

    _board[cellIndex] = _currentPlayer;

    final winningPlayer = checkWin();

    if (winningPlayer != null) {
      _winner = winningPlayer;
      _isGameOver = true;
      updateScore(winningPlayer);
      saveMatchToFirestore();
    } else if (checkTie()) {
      _winner = 'Tie';
      _isGameOver = true;
      updateScore('Tie');
      saveMatchToFirestore();
    } else {
      _currentPlayer = _currentPlayer == 'X' ? 'O' : 'X';
    }

    notifyListeners();
  }
  String? checkWin() {
    const List<List<int>> winningLines = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6],
    ];

    for (final line in winningLines) {
      final firstCell = _board[line[0]];
      final secondCell = _board[line[1]];
      final thirdCell = _board[line[2]];

      final lineIsComplete = firstCell.isNotEmpty &&
          firstCell == secondCell &&
          secondCell == thirdCell;

      if (lineIsComplete) return firstCell;
    }

    return null;
  }

  bool checkTie() {
    return _board.every((cell) => cell.isNotEmpty);
  }

  Future<void> saveMatchToFirestore() async {
    _matchSaveFailed = false;

    try {
      final completedMatch = MatchModel(
        player1: _player1Name,
        player2: _player2Name,
        winner: _winner!,
        board: List<String>.from(_board),
        createdAt: DateTime.now(),
      );
      await _firestoreService.saveMatch(completedMatch);
    } catch (error) {
      _matchSaveFailed = true;
      debugPrint('Failed to save match: $error');
    }

    notifyListeners();
  }
}
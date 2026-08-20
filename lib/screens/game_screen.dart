import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/board_widget.dart';
import '../widgets/scoreboard_widget.dart';
import '../widgets/game_controls_widget.dart';
import 'match_history_screen.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _resultDialogShown = false;

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    if (!gameProvider.isGameOver) {
      _resultDialogShown = false;
    } else if (!_resultDialogShown) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _resultDialogShown) return;
        _showGameOverDialog(context, gameProvider);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${gameProvider.player1Name} vs ${gameProvider.player2Name}',
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Match History',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MatchHistoryScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const ScoreboardWidget(),
          const SizedBox(height: 12),
          if (!gameProvider.isGameOver)
            Text(
              "${gameProvider.currentPlayerName}'s Turn",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          const SizedBox(height: 8),
          const Expanded(child: BoardWidget()),
          const GameControlsWidget(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  void _showGameOverDialog(BuildContext context, GameProvider gameProvider) {
    if (ModalRoute.of(context)?.isCurrent != true) return;

    _resultDialogShown = true;
    final resultMessage = _buildResultMessage(gameProvider);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text(resultMessage, style: const TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (gameProvider.matchSaveFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not save match to history.'),
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  String _buildResultMessage(GameProvider gameProvider) {
    if (gameProvider.winner == 'Tie') return "It's a Tie!";

    final winnerName = gameProvider.winner == 'X'
        ? gameProvider.player1Name
        : gameProvider.player2Name;
    return '$winnerName wins!';
  }
}
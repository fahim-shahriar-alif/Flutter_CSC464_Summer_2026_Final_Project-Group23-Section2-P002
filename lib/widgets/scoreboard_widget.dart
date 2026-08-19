import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class ScoreboardWidget extends StatelessWidget {
  const ScoreboardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildScoreColumn(
            label: '${gameProvider.player1Name}\n(X)',
            score: gameProvider.xWins,
            color: Colors.blue.shade700,
          ),
          _buildDivider(),
          _buildScoreColumn(
            label: 'Ties',
            score: gameProvider.ties,
            color: Colors.grey.shade700,
          ),
          _buildDivider(),
          _buildScoreColumn(
            label: '${gameProvider.player2Name}\n(O)',
            score: gameProvider.oWins,
            color: Colors.red.shade700,
          ),
        ],
      ),
    );
  }

  Widget _buildScoreColumn({
    required String label,
    required int score,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$score',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 50, width: 1, color: Colors.deepPurple.shade200);
  }
}
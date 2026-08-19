import 'package:flutter/material.dart';
import '../models/match_model.dart';

class MatchHistoryTile extends StatelessWidget {
  final MatchModel match;

  const MatchHistoryTile({super.key, required this.match});

  String _formatDate(DateTime dateTime) {
    const monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = monthNames[dateTime.month];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$day $month $year  $hour:$minute';
  }

  Color _winnerColor() {
    if (match.winner == 'X') return Colors.blue;
    if (match.winner == 'O') return Colors.red;
    return Colors.grey;
  }

  String _resultText() {
    if (match.winner == 'Tie') return 'Result: Tie';
    return 'Winner: ${match.winner}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _winnerColor(),
          child: Text(
            match.winner == 'Tie' ? '=' : match.winner,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          '${match.player1}  vs  ${match.player2}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(_resultText()),
        trailing: Text(
          _formatDate(match.createdAt),
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ),
    );
  }
}
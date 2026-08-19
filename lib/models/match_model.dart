import 'package:cloud_firestore/cloud_firestore.dart';

class MatchModel {
  final String? id;
  final String player1;
  final String player2;
  final String winner;
  final List<String> board;
  final DateTime createdAt;

  MatchModel({
    this.id,
    required this.player1,
    required this.player2,
    required this.winner,
    required this.board,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'player1': player1,
      'player2': player2,
      'winner': winner,
      'board': board,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MatchModel.fromMap(String id, Map<String, dynamic> data) {
    final createdAtRaw = data['createdAt'];
    final DateTime createdAt;
    if (createdAtRaw is Timestamp) {
      createdAt = createdAtRaw.toDate();
    } else {
      createdAt = DateTime.now();
    }

    return MatchModel(
      id: id,
      player1: data['player1'] as String,
      player2: data['player2'] as String,
      winner: data['winner'] as String,
      board: List<String>.from(data['board'] as List),
      createdAt: createdAt,
    );
  }
}
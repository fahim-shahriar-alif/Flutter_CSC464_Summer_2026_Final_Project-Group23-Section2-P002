import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/match_model.dart';

class FirestoreService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  Future<void> saveMatch(MatchModel match) async {
    await _db.collection('matches').add({
      'player1': match.player1,
      'player2': match.player2,
      'winner': match.winner,
      'board': match.board,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<MatchModel>> getMatches() async {
    final snapshot = await _db
        .collection('matches')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MatchModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}
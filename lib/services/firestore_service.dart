import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../models/match_model.dart';

class FirestoreService {
  FirebaseFirestore get _db => FirebaseFirestore.instance;

  bool get isFirebaseReady => Firebase.apps.isNotEmpty;

  void _ensureFirebaseReady() {
    if (!isFirebaseReady) {
      throw StateError('Firebase is not configured');
    }
  }

  Future<void> saveMatch(MatchModel match) async {
    _ensureFirebaseReady();

    await _db.collection('matches').add({
      'player1': match.player1,
      'player2': match.player2,
      'winner': match.winner,
      'board': match.board,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<MatchModel>> getMatches() async {
    _ensureFirebaseReady();

    final snapshot = await _db
        .collection('matches')
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MatchModel.fromMap(doc.id, doc.data()))
        .toList();
  }
}

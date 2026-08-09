import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  HistoryRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth;

  Future<void> saveHistory({
    required String featureType,
    required String resultSummary,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated.');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .add({
      'timestamp': FieldValue.serverTimestamp(),
      'featureType': featureType,
      'resultSummary': resultSummary,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> watchHistory() {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not authenticated.');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
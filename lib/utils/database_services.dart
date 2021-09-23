import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spa_beauty/model/points_model.dart';
import 'package:spa_beauty/model/user_model.dart';
class DatabaseServices{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Stream<UserModel> streamUser(String id) {
    return _db.collection('customer').doc(id)
        .snapshots().map((snap) => UserModel.fromMap(snap.data()!,snap.reference.id));
  }

  Stream<PointModel> streamPoints() {
    return _db.collection('settings').doc('points')
        .snapshots().map((snap) => PointModel.fromMap(snap.data()!));
  }
}
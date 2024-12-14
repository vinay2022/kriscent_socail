import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/profile/user_model.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          return UserModel.fromJson(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
  Future<bool> addUser({required UserModel user}) async {
    try {
      await _firestore.collection('users').doc(user.id).set(user.toJson());
      return true;

    } catch (e) {
      print(e.toString());

    }
    return false;
  }
}

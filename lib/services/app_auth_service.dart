import 'package:firebase_auth/firebase_auth.dart';

class AppAuth{
  static String? userId = FirebaseAuth.instance.currentUser?.uid;
}
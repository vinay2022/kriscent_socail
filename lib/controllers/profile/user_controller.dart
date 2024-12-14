import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
 import '../../models/profile/user_model.dart';
import '../../services/app_auth_service.dart';

class UserController extends GetxController {
  UserController(){
    fetchUserData();
  }
  Rx<UserModel> _user = UserModel().obs;
  UserModel get user => _user.value;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() async {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).snapshots().listen((doc) {
      _user.value = UserModel.fromJson(doc.data() ?? <String,dynamic>{});
    } ,);
  }

  void addNewFollowing(String? authorId) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
      "following":FieldValue.arrayUnion([authorId]),
    });
    FirebaseFirestore.instance.collection('users').doc(authorId).update({
      "followers":FieldValue.arrayUnion([AppAuth.userId]),
    });
  }
  void removeFollowing(String? authorId) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
      "following":FieldValue.arrayRemove([authorId]),
    });
    FirebaseFirestore.instance.collection('users').doc(authorId).update({
      "followers":FieldValue.arrayRemove([AppAuth.userId]),
    });
  }
  void removeFollower(String? authorId) {
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).update({
      "followers":FieldValue.arrayRemove([authorId]),
    });
    FirebaseFirestore.instance.collection('users').doc(authorId).update({
      "following":FieldValue.arrayRemove([AppAuth.userId]),
    });
  }

  Stream<UserModel> getFollowersData(String? followerId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followerId)
        .snapshots()
        .map(
          (snapshot) {
        if (snapshot.exists) {
          return UserModel.fromJson(snapshot.data()!);
        } else {
          throw UserModel();
        }
      },
    );
  }
  Stream<UserModel> getFollowingData(String? followingId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingId)
        .snapshots()
        .map(
          (snapshot) {
        if (snapshot.exists) {
          return UserModel.fromJson(snapshot.data()!);
        } else {
          throw UserModel();
        }
      },
    );
  }

}

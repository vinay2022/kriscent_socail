import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../../models/profile/user_model.dart';
import '../../services/app_auth_service.dart';
import '../../services/storage_service.dart';
import '../../services/user_service.dart';
import '../../view/screens/auth/login_screen.dart';
import '../../view/screens/auth/sign_up_screen.dart';
import '../../view/screens/home/home_page.dart';
import '../profile/user_controller.dart';

class AuthController extends GetxController {
  Rx<TextEditingController> _emailController = TextEditingController().obs;
  Rx<TextEditingController> _passwordController = TextEditingController().obs;
  Rx<TextEditingController> _nameController = TextEditingController().obs;
  Rx<TextEditingController> _phoneController = TextEditingController().obs;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;

  TextEditingController get nameController => _nameController.value;

  TextEditingController get emailController => _emailController.value;

  TextEditingController get passwordController => _passwordController.value;

  TextEditingController get phoneController => _phoneController.value;

  String get name => nameController.text;

  String get password => passwordController.text;

  String get phone => phoneController.text;

  String get email => emailController.text;

  Rx<File?> _imageFile = Rx<File?>(null);

  File? get imageFile => _imageFile.value;
  RxBool _isLoading = false.obs;
  get isLoading => _isLoading.value;

  updateLoading(bool value) => _isLoading.value = value;

  void updateImageFile(File? file) => _imageFile.value = file;

  onSignUpTap() => Get.offAll(SignUpScreen());

  onLoginTap() => Get.offAll(LoginScreen());

  final StorageService _storageService =
  StorageService(collectionName: 'Users/profileImages');

  Future<void> signUp() async {
    if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
      Fluttertoast.showToast(
        msg: "Fill all the fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else if (imageFile == null) {
      showMessage(message: 'Please Choose Image');
    } else {
      updateLoading(true);
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await uploadUserData();

      } catch (e) {
        print(e.toString());
      }
      updateLoading(false);
    }
  }

  Future<void> login() async {
    if (email.isEmpty || password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Fill all the fields",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } else {
      updateLoading(true);
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        showMessage(message: "Successfully logged in");
        resetFields();
        Get.offAll(HomePage());
      } catch (e) {
        print(e);
        showMessage(message: "logged in failed..");
      }
      updateLoading(false);
    }
  }

  Future<void> uploadUserData() async {
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _storageService.uploadMedia(
          file: imageFile!, fileName: userId ?? '', type: MediaType.image);
    }
    var user = UserModel(
      id: FirebaseAuth.instance.currentUser?.uid,
      name: name,
      email: email,
      phone: phone,
      followers: [],
      following: [],
      profileImage: imageUrl,
    );

    var response = await UserService().addUser(user: user);
    if (response == true) {
      showMessage(message: "Successfully Signed Up");
      resetFields();
      Get.offAll(HomePage());
    } else {
      showMessage(message: " Sign Up failed...");
      resetFields();
    }
  }

  void resetFields() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    updateImageFile(null);
  }

  void showMessage({required String message}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    return;
  }

  void updateField() {
    var userController = Get.put(UserController());
    nameController.text = userController.user.name ?? "";
    phoneController.text = userController.user.phone ?? "";
  }

  void updateProfile() async{
    if(name.isEmpty || phone.isEmpty){
      showMessage(message: 'please fill empty fields');
      return;
    }
    updateLoading(true);
    String? imageUrl;
    if (imageFile != null) {
      imageUrl = await _storageService.uploadMedia(
          file: imageFile!, fileName: userId ?? '', type: MediaType.image);
      await FirebaseFirestore.instance.collection('users').doc(AppAuth.userId).update({
        "name":name,
        "phone":phone,
        "profile_image":imageUrl,
      });
    }else{
      await FirebaseFirestore.instance.collection('users').doc(AppAuth.userId).update({
        "name":name,
        "phone":phone,
      });
    }
    updateLoading(false);
    resetFields();
    showMessage(message: 'Profile Updated Successfullly');
    Get.back();

  }
}

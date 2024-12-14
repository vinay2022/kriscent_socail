import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth/login_screen.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Setting Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(),
            ListTile(
              title: const Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                _showLogoutConfirmationDialog(context);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  // Function to show confirmation dialog
  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                // If user confirms, sign out and navigate to login screen
                FirebaseAuth.instance.signOut();
                Get.offAll(() => const LoginScreen());
              },
              child: const Text('Yes', style: TextStyle(fontSize: 18, color: Colors.blue)),
            ),
            TextButton(
              onPressed: () {

                Navigator.pop(context);
              },
              child: const Text('No', style: TextStyle(fontSize: 18, color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

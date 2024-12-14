import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../controllers/auth/auth_controller.dart';
import '../../utils/app_widgets/buttons/custom_button.dart';
import '../../utils/app_widgets/textfields/custom_textfiled.dart';
import '../../utils/colors/colors.dart';
import '../../utils/sizes/size.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Login Screen',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: textBoldFont,color: primaryColor),
          ),
        ),),

      body: SafeArea(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
            SizedBox(height: 60,),
              CustomTextFiled(
                controller: controller.emailController,
                hint: 'Email',
                iconData: Icons.mail,
              ),
              CustomTextFiled(
                controller: controller.passwordController,
                hint: 'Password',
                iconData: Icons.lock,
                toHide: true,
              ),
              const Spacer(
                flex: 5,
              ),
              CustomButton(
                  onPressed: controller.login,
                  isLoading: controller.isLoading,
                  text: 'Login',),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?",
                    style: TextStyle(fontSize: 14),
                  ),
                  TextButton(
                    onPressed: controller.onSignUpTap,
                    child: const Text('Sign Up Here',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                          fontSize: 16),
                    ),
                  ),
                ],
              ),
              const Spacer(
                flex: 1,
              )
            ],
          );
        }),
      ),
    );
  }
}

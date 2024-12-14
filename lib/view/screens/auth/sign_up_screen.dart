import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../utils/app_widgets/buttons/custom_button.dart';
import '../../utils/app_widgets/textfields/custom_textfiled.dart';
import '../../utils/app_widgets/pickers/image_picker_widget.dart';
import '../../utils/sizes/size.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  var controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var sizes = AppSizes(context: context);
    return Scaffold(
      appBar: AppBar(),
      body: Obx(
              () {
            return ListView(
              children: [
                Center(
                  child: ImagePickerWidget(
                    image: controller.imageFile,
                    onImagePicked: (File? pickedImage) {
                      controller.updateImageFile(pickedImage);
                    }, networkUrl: null,
                  ),
                ),
                SizedBox(height: sizes.getHeight * 0.02),
                CustomTextFiled(
                    controller: controller.nameController,
                    iconData: Icons.person_outline_rounded,
                    hint: 'Name'),
                CustomTextFiled(
                    controller: controller.emailController,
                    iconData: Icons.mail,
                    hint: 'Email'),
                CustomTextFiled(
                    controller: controller.passwordController,
                    iconData: Icons.mail_lock_outlined,toHide: true,
                    hint: 'Password'),
                CustomTextFiled(
                    controller: controller.phoneController,
                    iconData: Icons.phone_android,
                    hint: 'Phone'),
                20.height,
                CustomButton(
                    text: 'Sign Up',
                    onPressed: controller.signUp,
                    isLoading:controller.isLoading
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(fontSize: 14),
                    ),
                    TextButton(
                      onPressed: controller.onLoginTap,
                      child: const Text(
                        'Login Here',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                            fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }
      ),
    );
  }
}

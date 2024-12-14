import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';

import '../../../controllers/auth/auth_controller.dart';
import '../../../controllers/profile/user_controller.dart';
import '../../utils/app_widgets/buttons/custom_button.dart';
import '../../utils/app_widgets/textfields/custom_textfiled.dart';
import '../../utils/app_widgets/pickers/image_picker_widget.dart';
import '../../utils/sizes/size.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});
  var controller = Get.put(AuthController());
  var userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    var sizes = AppSizes(context: context);
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile Here'),),
      body: Obx(
              () {
            return ListView(
              children: [
                Center(
                  child:  ImagePickerWidget(
                    image: controller.imageFile,
                    onImagePicked: (File? pickedImage) {
                      controller.updateImageFile(pickedImage);
                    }, networkUrl: userController.user.profileImage,
                  ),
                ),
                SizedBox(height: sizes.getHeight * 0.02),
                CustomTextFiled(
                    controller: controller.nameController,
                    iconData: Icons.drive_file_rename_outline,
                    hint: 'Name'),
                CustomTextFiled(
                    controller: controller.phoneController,
                    iconData: Icons.phone_android,
                    hint: 'Phone'),
                20.height,
                CustomButton(
                    text: 'Update',
                    onPressed: controller.updateProfile,
                    isLoading:controller.isLoading
                ),
              ],
            );
          }
      ),
    );
  }
}

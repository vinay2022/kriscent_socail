import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kriscent_socail/view/screens/home/tabs/photoPickerWidget.dart';
import '../../../controllers/reels/reels_controller.dart';
import '../../utils/app_widgets/pickers/video_picker_widget.dart';
import '../../utils/app_widgets/textfields/custom_textfiled.dart';

class ReelPostScreen extends StatefulWidget {
  const ReelPostScreen({super.key, required this.isPhotoUpload});

  final bool isPhotoUpload;

  @override
  State<ReelPostScreen> createState() => _ReelPostScreenState();
}

class _ReelPostScreenState extends State<ReelPostScreen> {
  var reelController = Get.put(ReelsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'New Post ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          Obx(
                () => TextButton(
              onPressed: () {
                reelController.uploadReel();
              },
              child: reelController.isLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : const Text(
                'POST',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
      body: Obx(
            () => ListView(
          children: [
            Column(
              children: [
                // Conditionally show video picker widget
                if (!widget.isPhotoUpload)
                  VideoPickerWidget(
                    video: reelController.videoFile,
                    onVideoPicked: (pickedVideo) {
                      reelController.updateVideoFile(pickedVideo);
                      reelController.updateVideoController();
                    },
                    videoPlayerController: reelController.videoFile != null
                        ? reelController.fileVideoController
                        : null,
                  ),
                // Conditionally show photo picker widget
                if (widget.isPhotoUpload)
                  PhotoPickerWidget(
                    photo: reelController.photoFile,
                    onPhotoPicked: (pickedPhoto) {
                      reelController.updatePhotoFile(pickedPhoto);
                    },
                  ),

                // Title Text Field
                CustomTextFiled(
                  controller: reelController.titleController,
                  hint: 'Title',
                  iconData: Icons.title,
                ),

                // Caption Text Field
                CustomTextFiled(
                  controller: reelController.captionController,
                  hint: 'Caption',
                  iconData: Icons.title,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';
 import 'package:video_player/video_player.dart';

class VideoPickerWidget extends StatelessWidget {
  VideoPickerWidget(
      {super.key,
        this.video,
        this.photo,
        required this.onVideoPicked, required this.videoPlayerController,});

  final File? video;
  final VideoPlayerController? videoPlayerController;
  final  Function(File? pickedVideo) onVideoPicked;

  var photo;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        var picker = ImagePicker();
        final XFile? image =
        await picker.pickVideo(source: ImageSource.gallery);
        if (image != null) {
          onVideoPicked(File(image.path));
        } else {
          onVideoPicked(null);
        }
      },
      child: Container(
        width: context.screenWidth * 0.9,
        height: context.screenHeight * 0.4,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: video != null && videoPlayerController != null
              ? videoPlayerController!.value.isInitialized
              ? AspectRatio(
            aspectRatio: videoPlayerController!.value.aspectRatio,
            child: VideoPlayer(videoPlayerController!),
          )
              : Container()
              : Container(
            height: context.screenWidth * 0.12,
            width: context.screenHeight * 0.12,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
            child: Icon(
              Icons.videocam_outlined,
              size: context.screenHeight * 0.06,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

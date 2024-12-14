import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';
 import 'package:video_player/video_player.dart';

class GridVideoItem extends StatelessWidget {
  const GridVideoItem({super.key, required this.videoController, required this.onItemTap});

  final VideoPlayerController videoController;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
        ),
        child: Center(
          child: videoController.value.isInitialized
              ? InkWell(
            onTap: onItemTap,
            child: ClipRRect(
              borderRadius: 5.borderRadius,
              child: AspectRatio(
                aspectRatio: 0.6,
                child: VideoPlayer(videoController),
              ),
            ),
          )
              : CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

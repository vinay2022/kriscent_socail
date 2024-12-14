import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';
 import 'package:video_player/video_player.dart';
import '../../../../controllers/profile/user_controller.dart';
import '../../../../controllers/reels/reels_controller.dart';
import '../../../../models/reels/reel_model.dart';
import '../../../../models/profile/user_model.dart';
import '../../../../services/app_auth_service.dart';

class ReelItemWidget extends StatefulWidget {
  const ReelItemWidget(
      {super.key,
        required this.videoController,
        required this.reelController,
        required this.currentReel,
        required this.onCommentTap, required this.userController});

  final VideoPlayerController videoController;
  final ReelsController reelController;
  final UserController userController;
  final ReelModel currentReel;
  final VoidCallback onCommentTap;

  @override
  State<ReelItemWidget> createState() => _ReelItemWidgetState();
}

class _ReelItemWidgetState extends State<ReelItemWidget> {
  @override
  void initState() {
    widget.videoController.setLooping(true);
    widget.videoController.play();
    super.initState();
  }

  @override
  void dispose() {
    widget.videoController.setLooping(false);
    widget.videoController.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Container(
            height: context.screenHeight * 0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[400],
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: widget.videoController.value.isInitialized
                      ? InkWell(
                    onTap: () {
                      if (widget.videoController.value.isPlaying) {
                        widget.videoController.pause();
                      } else {
                        widget.videoController.play();
                      }
                    },
                    child: ClipRRect(
                      borderRadius: 5.borderRadius,
                      child: AspectRatio(
                        aspectRatio: widget.videoController.value.aspectRatio,
                        child: VideoPlayer(widget.videoController),
                      ),
                    ),
                  )
                      : const Center(child: CupertinoActivityIndicator()),
                ),
                Positioned(
                  bottom: 100,
                  right: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            widget.reelController.manageReelLike(widget.currentReel);
                          },
                          icon: Column(
                            children: [
                              widget.reelController
                                  .isReelLikedWidget(widget.currentReel.likesIds),
                              Text(
                                '${widget.currentReel.likesIds?.length}',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          )),
                      IconButton(
                        onPressed: widget.onCommentTap,
                        icon: Column(
                          children: [
                            const Icon(
                              Icons.comment_outlined,
                              color: Colors.white,
                            ),
                            Text(
                              '${widget.currentReel.comments?.length ?? 0}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<UserModel>(
                        stream: widget.reelController.reelAuthorData(widget.currentReel.authorId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          var author = snapshot.data;
                          bool isFollowing = author?.followers?.contains(AppAuth.userId) == true;
                          return Row(
                            children: [
                              PhysicalModel(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl: author?.profileImage ?? '',
                                      width: 55,
                                      height: 55,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '${author?.name}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              isFollowing
                                  ? OutlinedButton(
                                onPressed: () {
                                  widget.userController.removeFollowing(widget.currentReel.authorId);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blueAccent,
                                  side: BorderSide(
                                      color: Colors.black.withOpacity(0.2)),
                                ),
                                child: const Text(
                                  'following',
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              )
                                  : OutlinedButton(
                                onPressed: () {
                                  widget.userController
                                      .addNewFollowing(widget.currentReel.authorId);
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                      color: Colors.white.withOpacity(0.92)),
                                ),
                                child: const Text('Follow'),
                              ),
                            ],
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("${widget.currentReel.caption}",style: TextStyle(color: Colors.white),),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

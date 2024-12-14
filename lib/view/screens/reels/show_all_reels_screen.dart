import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';
import 'package:video_player/video_player.dart';
import '../../../controllers/profile/user_controller.dart';
import '../../../controllers/reels/reels_controller.dart';
import '../../../models/reels/reel_model.dart';
import '../../../models/profile/user_model.dart';
import '../../utils/app_widgets/reels/reel_item_widget.dart';
import '../../utils/app_widgets/textfields/custom_textfiled.dart';

class ShowAllReelPostsScreen extends StatefulWidget {
  const ShowAllReelPostsScreen({
    super.key,
    required this.reelsList,
    required this.pageController,
    required this.title,
    required this.videoControllers,
  });

  final String title;
  final List<ReelModel> reelsList;
  final PageController pageController;
  final Map<int, VideoPlayerController> videoControllers;

  @override
  State<ShowAllReelPostsScreen> createState() => _ShowAllReelPostsScreenState();
}

class _ShowAllReelPostsScreenState extends State<ShowAllReelPostsScreen> {
  ReelsController reelController = Get.put(ReelsController());
  UserController userController = Get.put(UserController());

  List<ReelModel> get reelsList => widget.reelsList;

  Map<int, VideoPlayerController> get _videoControllers =>
      widget.videoControllers;

  PageController get pageController => widget.pageController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Obx(() {
        if (reelsList.isEmpty) {
          return const Center(
            child: Text('No Reels Availavle'),
          );
        }
        return PageView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          controller: pageController,
          itemCount: reelsList.length,
          itemBuilder: (context, index) {
            var currentReel = reelsList[index];
            if (!_videoControllers.containsKey(index)) {
              _videoControllers[index] =
              VideoPlayerController.network(currentReel.video ?? '')
                ..initialize().then((_) {
                  setState(() {});
                });
            }
            VideoPlayerController videoController = _videoControllers[index]!;

            return ReelItemWidget(
                videoController: videoController,
                reelController: reelController,
                currentReel: currentReel,
                onCommentTap: () {
                  openCommentDialog(context: context, reel: currentReel);
                },
                userController: userController);
          },
        );
      }),
    );
  }

  void openCommentDialog(
      {required BuildContext context, required ReelModel reel}) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      enableDrag: true,
      backgroundColor: const Color(0xfff2f2f2),
      scrollControlDisabledMaxHeightRatio: 3 / 4,
      constraints: BoxConstraints(
        minHeight: 400,
        maxHeight: context.screenHeight,
        minWidth: context.screenWidth,
      ),
      builder: (context) {
        return Obx(
              () => Column(
            children: [
              const PhysicalModel(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 18.0),
                      child: Text("Comments"),
                    ),
                    CloseButton(
                      color: Colors.red,
                    )
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child: reel.comments?.isEmpty == true
                    ? const Center(
                  child: Text("No Comments Available"),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 20),
                  shrinkWrap: true,
                  itemCount: reel.comments?.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    var currentComment =
                    reel.comments?.reversed.toList()[index];

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StreamBuilder<UserModel>(
                          stream: reelController.reelAuthorData(
                              currentComment?.commentAuthorId),
                          builder: (context, snapshot) {
                            var author = snapshot.data;
                            return ListTile(
                              shape: 10.shapeBorderRadius,
                              leading: PhysicalModel(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(50),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                      author?.profileImage ?? '',
                                      width: 45,
                                      height: 45,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                      errorWidget:
                                          (context, url, error) =>
                                      const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                "${author?.name}",
                                style: const TextStyle(fontSize: 12),
                              ),
                              subtitle: Text("${currentComment?.text}"),
                            );
                          }),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomTextFiled(
                            controller: reelController.commentController,
                            iconData: Icons.comment,
                            hint: 'Enter Comment here')),
                    IconButton(
                        onPressed: () async {
                          reelController.uploadComment(reel);
                        },
                        icon: reelController.isCommentLoading
                            ? const Center(child: CupertinoActivityIndicator())
                            : const Icon(
                          CupertinoIcons.arrow_right_circle_fill,
                          size: 45,
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: context.mediaQuery.viewInsets.bottom,
                width: context.width,
              )
            ],
          ),
        );
      },
    );
  }
}

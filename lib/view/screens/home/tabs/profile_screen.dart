import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';

import 'package:video_player/video_player.dart';

import '../../../../controllers/auth/auth_controller.dart';
import '../../../../controllers/profile/user_controller.dart';
import '../../../../controllers/reels/reels_controller.dart';
import '../../../utils/app_widgets/reels/grid_reel_widget.dart';
import '../../../utils/sizes/size.dart';
import '../../followers/all_followers_screen.dart';
import '../../followings/all_followings_screen.dart';
import '../../profile/edit_profile_screen.dart';
import '../../profile/profile_setting_screen.dart';
import '../../reels/reel_upload_screen.dart';
import '../../reels/show_all_reels_screen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController userController = Get.put(UserController());
  AuthController authController = Get.put(AuthController());

  ReelsController reelController = Get.put(ReelsController());

  Map<int, VideoPlayerController> _videoControllers = {};

  @override
  Widget build(BuildContext context) {
    var sizes = AppSizes(context: context);
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: userController.user.name == null
                ? const CircularProgressIndicator()
                : Text(
              userController.user.name ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
            ),
          );
        }),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Text("Upload",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                // Show bottom sheet to choose upload type
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text('Upload Photo'),
                            onTap: () {
                              Navigator.pop(context); // Close the sheet
                              Get.to(() => ReelPostScreen(isPhotoUpload: true));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.videocam),
                            title: const Text('Upload Video'),
                            onTap: () {
                              Navigator.pop(context); // Close the sheet
                              Get.to(() => ReelPostScreen(isPhotoUpload: false));
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              icon: Padding(
                padding: const EdgeInsets.only(top: 7),
                child: const Icon(Icons.add_box_outlined, size: 30),
              ),
            ),
          ),

        ],
      ),
      body: Obx(() {
        if (userController.user.name == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: sizes.getHeight * 0.02),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage:
                        userController.user.profileImage?.isNotEmpty == true
                            ? NetworkImage(
                            userController.user.profileImage ?? '')
                            : null,
                        child: userController.user.profileImage?.isEmpty == true
                            ? const Icon(Icons.person, size: 40)
                            : null,
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "${reelController.currentUserReels.length}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        const Text(
                          "posts",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(()=>AllFollowersScreen());
                      },
                      child: Column(
                        children: [
                          Text(
                            "${userController.user.followers?.length}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const Text(
                            "followers",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(()=>AllFollowingsScreen());
                      },
                      child: Column(
                        children: [
                          Text(
                            "${userController.user.following?.length}",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const Text(
                            "Following",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      authController.updateField();
                      Get.to(()=>const ProfileSettingScreen());
                    },
                    child: const Text('Account Setting'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      authController.updateField();
                      Get.to(()=> EditProfileScreen());
                    },
                    child: const Text('Edit profile'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black,
                      side: BorderSide(color: Colors.black.withOpacity(0.5)),
                    ),
                  ),
                ],
              ),
              20.height,
              Divider(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 15),
                        child: Text(
                          "Posts",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      Expanded(
                        child: reelController.currentUserReels.isEmpty
                            ? const Center(
                          child: Text("No Reels Available"),
                        )
                            : GridView.builder(
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 0.6,
                            crossAxisSpacing: 2,
                          ),
                          itemCount:
                          reelController.currentUserReels.length,
                          itemBuilder: (BuildContext context, int index) {
                            var currentReel =
                            reelController.currentUserReels[index];
                            if (!_videoControllers.containsKey(index)) {
                              _videoControllers[index] =
                              VideoPlayerController.network(
                                  currentReel.video ?? '')
                                ..initialize().then((_) {
                                  setState(() {});
                                });
                            }
                            VideoPlayerController videoController =
                            _videoControllers[index]!;
                            return GridVideoItem(videoController: videoController, onItemTap: () {
                              Get.to(() =>
                                  ShowAllReelPostsScreen(
                                    reelsList: reelController
                                        .currentUserReels,
                                    pageController:
                                    PageController(
                                        initialPage:
                                        index),
                                    title: 'My Reels',
                                    videoControllers:
                                    _videoControllers,
                                  ));
                            },);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }
}


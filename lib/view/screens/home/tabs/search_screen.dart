import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../../../controllers/reels/reels_controller.dart';
import '../../../utils/app_widgets/reels/grid_reel_widget.dart';
import '../../../utils/app_widgets/textfields/custom_textfiled.dart';
import '../../../utils/sizes/size.dart';
import '../../reels/show_all_reels_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ReelsController reelsController = Get.put(ReelsController());
  Map<int, VideoPlayerController> _videoControllers = {};

  @override
  Widget build(BuildContext context) {
    var sizes = AppSizes(context: context);
    return Scaffold(
      body: SafeArea(
        child: Obx(
              () => Column(
            children: [
              CustomTextFiled(
                  onChanged: (text) {
                    reelsController.performSearch(text);
                  },
                  controller: reelsController.reelSearchController,
                  hint: 'Search..',
                  iconData: Icons.search),
              SizedBox(
                height: sizes.getHeight * 0.02,
              ),
              Expanded(
                child: reelsController.searchedReelsList.isEmpty
                    ? const Center(
                  child: Text("No Reels Available"),
                )
                    : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.6,
                      crossAxisSpacing: 2
                  ),
                  itemCount: reelsController.searchedReelsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    var currentReel =
                    reelsController.searchedReelsList[index];
                    if (!_videoControllers.containsKey(index)) {
                      _videoControllers[index] = VideoPlayerController
                          .network(currentReel.video ?? '')
                        ..initialize().then((_) {
                          setState(() {}); // Rebuild to show video player
                          // _videoControllers[index]!.play();
                        });
                    }
                    VideoPlayerController videoController =
                    _videoControllers[index]!;

                    return GridVideoItem(videoController: videoController, onItemTap: () {
                      Get.to(()=>ShowAllReelPostsScreen(reelsList: reelsController.searchedReelsList, pageController: PageController(initialPage: index), title: 'Searched Reels', videoControllers: _videoControllers,));
                    },);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kriscent_socail/view/utils/extensions/app_extensions.dart';


import '../../../controllers/profile/user_controller.dart';
import '../../../models/profile/user_model.dart';

class AllFollowingsScreen extends StatelessWidget {
  AllFollowingsScreen({super.key});
  var userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Following"),
      ),
      body: Obx(() {
        if (userController.user.following?.isEmpty == true ||
            userController.user.following == null) {
          return Center(
            child: Text("No Following Available"),
          );
        }
        return ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: userController.user.following!.length,
          itemBuilder: (context, index) {
            var followerId = userController.user.following![index];
            return StreamBuilder<UserModel>(
                stream: userController.getFollowingData(followerId),
                builder: (context, snapshot) {
                  var followerData = snapshot.data;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      shape: 10.shapeBorderRadius,
                      leading: PhysicalModel(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: CachedNetworkImage(
                              imageUrl: followerData?.profileImage ?? '',
                              width: 45,
                              height: 45,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        "${followerData?.name}", style: const TextStyle(fontWeight: FontWeight.bold),),
                      subtitle: const Text("Following"),
                      trailing: IconButton(icon: const Icon(Icons.delete,color: Colors.red,), onPressed: () {
                        userController.removeFollowing(followerData?.id);
                      },),
                    ),
                  );
                });
          },
        );
      }),
    );
  }
}

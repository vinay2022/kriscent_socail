import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/bottom_nav/bottom_nav_controller.dart';


class HomePage extends StatelessWidget {
  HomePage({super.key});
  BottomNavController controller = Get.put(BottomNavController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>controller.selectedTab),
      bottomNavigationBar: Obx(() =>
          BottomNavigationBar(
            currentIndex: controller.selectedTabIndex,
            onTap: controller.changeTabIndex,
            unselectedItemColor: Colors.black,
            selectedItemColor: Colors.blue,
            showUnselectedLabels: true,
            showSelectedLabels: true,
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.video_library), label: 'Reels'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), label: 'Search'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ],
          )),
    );
  }
}


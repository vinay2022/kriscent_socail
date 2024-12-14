import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../view/screens/home/tabs/profile_screen.dart';
import '../../view/screens/home/tabs/reels_screens.dart';
import '../../view/screens/home/tabs/search_screen.dart';
class BottomNavController extends GetxController {
  final List<Widget> _allScreens = [
    ReelPageView(),
    SearchScreen(),
    ProfileScreen(),
  ];
  RxInt _selectedTabIndex = 0.obs;

  int get selectedTabIndex => _selectedTabIndex.value;

  Widget get selectedTab => _allScreens[selectedTabIndex];

  void changeTabIndex(int index) => _selectedTabIndex.value = index;
}

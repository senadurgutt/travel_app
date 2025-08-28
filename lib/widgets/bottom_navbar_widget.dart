import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/navbar_controller.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  final NavbarController navController = Get.find<NavbarController>();

  // 🔑 MainPage’de kullandığımızla aynı keyler
  final pageKeys = ["favorites", "home", "profile"];

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: (index) => navController.changeTab(index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite),
              label: pageKeys[0].tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: pageKeys[1].tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: pageKeys[2].tr,
            ),
          ],
        ));
  }
}

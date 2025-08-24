import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/navbar_controller.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  final NavbarController navController = Get.find<NavbarController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => BottomNavigationBar(
          currentIndex: navController.currentIndex.value,
          onTap: (index) => navController.changeTab(index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: "Favoriler",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profil",
            ),
          ],
        ));
  }
}

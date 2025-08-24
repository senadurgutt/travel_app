import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/navbar_controller.dart';
import 'package:travel_app/views/Favorites/favorites_page.dart';
import 'package:travel_app/widgets/bottom_navbar_widget.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final NavbarController navController = Get.put(NavbarController());

  final pages = [
    FavoritesPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
            index: navController.currentIndex.value,
            children: pages,
          )),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}

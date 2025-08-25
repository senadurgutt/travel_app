import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/navbar_controller.dart';
import 'package:travel_app/utils/colors.dart';
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
  final pageTitles = [
    "Favoriler",
    "Ana Sayfa",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final currentIndex = navController.currentIndex.value;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BAŞLIK
              Padding(
                
                padding: EdgeInsetsGeometry.only(top: 20.0 , left: 20),
                child: Text(
                  pageTitles[currentIndex],
                  style: TextStyle(
                    color: AppColors.primaryText,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // BORDER İÇİNDE SAYFALAR
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IndexedStack(
                    index: currentIndex,
                    children: pages,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
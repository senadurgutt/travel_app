import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/auth_controller.dart';
import 'package:travel_app/controllers/navbar_controller.dart';
import 'package:travel_app/controllers/travel_controller.dart';
import 'package:travel_app/utils/colors.dart';
import 'package:travel_app/views/Favorites/favorites_page.dart';
import 'package:travel_app/views/Login/pages/login_page.dart';
import 'package:travel_app/widgets/bottom_navbar_widget.dart';
import 'home_page.dart';
import 'profile_page.dart';

class MainPage extends StatelessWidget {
  MainPage({super.key});

  final NavbarController navController = Get.put(NavbarController());
  final AuthController authController = Get.find<AuthController>();

  final pages = [FavoritesPage(), HomePage(), ProfilePage()];
  final pageKeys = ["favorites", "home", "profile"]; // translations keyleri

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
              // ÜST BAŞLIK
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: SizedBox(
                  height: 48,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dinamik sayfa başlığı
                      Text(
                        pageKeys[currentIndex].tr,
                        style: TextStyle(
                          color: AppColors.primaryText,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Sağ ikonlar
                      if (currentIndex == 1) // Home
                        IconButton(
                          icon: Icon(Icons.settings),
                          tooltip: "settings".tr,
                          onPressed: () {
                            _showLanguageDialog(context);
                          },
                        ),
                      if (currentIndex == 2) // Profile
                        IconButton(
                          icon: Icon(Icons.logout),
                          tooltip: "logout".tr,
                          onPressed: () async {
                            await authController.signOut();
                            Get.offAll(() => LoginPage());
                          },
                        ),
                    ],
                  ),
                ),
              ),

              // ALT İÇERİK
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  child: Material(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                          child: IndexedStack(
                            index: currentIndex,
                            children: pages,
                          ),
                        ),
                        BottomNavBar(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // Dil seçimi dialogu

  void _showLanguageDialog(BuildContext context) {
    final travelController = Get.find<TravelController>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("language".tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("turkish".tr),
                onTap: () {
                  travelController.changeLang("tr");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("german".tr),
                onTap: () {
                  travelController.changeLang("de");
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text("english".tr),
                onTap: () {
                  travelController.changeLang("en");
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

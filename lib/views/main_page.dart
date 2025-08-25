import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/auth_controller.dart';
import 'package:travel_app/controllers/navbar_controller.dart';
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
  final pageTitles = ["Favoriler", "Ana Sayfa", "Profil"];

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
              // BAŞLIK + Çıkış
              Padding(
                padding: EdgeInsets.only(top: 20.0, left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Sol taraf: Sayfa başlığı
                    Text(
                      pageTitles[currentIndex],
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    // settings ikonu sadece home sayfasında
                    if (currentIndex == 1)
                      IconButton(
        icon: Icon(Icons.settings, color: Colors.white),
        onPressed: () {
          _showLanguageDialog(context);
        },
      ),
                      // Logout ikonu sadece Profil sayfasında
                    if (currentIndex == 2)
                      IconButton(
                        icon: Icon(Icons.logout, color: AppColors.primaryText),
                        onPressed: () async {
                          await authController.signOut();
                              Get.offAll(LoginPage());
                        },
                      ),
                  ],
                ),
              ),

              // BORDER İÇİNDE SAYFALAR
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    border: Border.all(color: Colors.grey.shade300, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IndexedStack(index: currentIndex, children: pages),
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

void _showLanguageDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("Diller"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Türkçe (TR)"),
              onTap: () {
                Get.updateLocale(Locale('tr'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Almanca (DE)"),
              onTap: () {
                Get.updateLocale(Locale('de'));
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("İngilizce (EN)"),
              onTap: () {
                Get.updateLocale(Locale('en'));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}

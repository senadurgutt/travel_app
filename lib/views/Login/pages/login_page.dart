import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/auth_controller.dart';
import 'package:travel_app/utils/colors.dart';
import 'package:travel_app/views/main_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Obx(() {
          final user = authController.user.value;

          if (user != null) {
            Future.microtask(() {
              Get.offAll(() => MainPage());
            });
            return const CircularProgressIndicator();
          }

          return Stack(
            children: [
              // Arka plan görseli
              Positioned.fill(
                child: Image.asset(
                  "lib/utils/images/login.jpg",
                  fit: BoxFit.cover,
                ),
              ),

              // Üstteki başlık
              Positioned(
                top: height * 0.25,
                left: 0,
                right: 0,
                child: Text(
"Bist du bereit für eine neue Route?",                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Pacifico",
                    fontSize: 28,
                    color: AppColors.primaryText,
                    shadows: [
                      Shadow(
                        color: AppColors.background,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: height * 0.40,
                left: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => authController.signInWithGoogle(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Google ikonu
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryText,
                              blurRadius: 15,
                              offset: Offset(2, 5),
                            ),
                          ],
                        ),
                        child: Image.asset(
                          "lib/utils/images/google.png",
                          width: 40,
                          height: 40,
                        ),
                      ),

                      SizedBox(height: 15),

                      Text(
                        "Mit Google anmelden",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryText,
                          shadows: [
                            Shadow(
                              color: AppColors.background,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}

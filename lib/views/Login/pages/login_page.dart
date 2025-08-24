import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/auth_controller.dart';
import 'package:travel_app/views/main_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade400, Colors.purple.shade300],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Obx(() {
            final user = authController.user.value;

            if (user != null) {
              // Kullanıcı giriş yaptı MainPage → HomePage

              Future.microtask(() {
                Get.offAll(() => MainPage());
              });

              // Geçiş yapılırken boş bir container gösterebilirsin
              return const Center(child: CircularProgressIndicator());
            }

            // Kullanıcı giriş yapmamış
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hoşgeldiniz",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 50),

                //  Login Button
                GestureDetector(
                  onTap: () => authController.signInWithGoogle(),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Image.network(
                      "https://upload.wikimedia.org/wikipedia/commons/5/53/Google_%22G%22_Logo.svg",
                      width: 30,
                      height: 30,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Google ile giriş yap",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

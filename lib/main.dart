import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:travel_app/controllers/travel_controller.dart';
import 'package:travel_app/services/translation_service.dart';
import 'package:travel_app/views/Login/pages/login_page.dart';
import 'controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AppTranslations.init();

  //await ImportService().importTravels();

  Get.put(AuthController());
  Get.put(TravelController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: Locale('de', 'DE'), // varsayılan
      fallbackLocale: Locale('en', 'US'),
      home: LoginPage(),
    );
  }
}

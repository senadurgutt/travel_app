/*
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/navbar_controller.dart';
import 'package:travel_app/utils/colors.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  final NavbarController navController = Get.find<NavbarController>();
  final pageKeys = ["favorites", "home", "profile"];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Icon
              GestureDetector(
                onTap: () => navController.changeTab(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: navController.currentIndex.value == 0
                          ? const Color.fromARGB(255, 69, 67, 67)
                          : Colors.grey,
                      size: 25,
                    ),
                    Text(
                      pageKeys[0].tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: navController.currentIndex.value == 0
                            ? const Color.fromARGB(255, 69, 67, 67)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              // Home Icon
              GestureDetector(
                onTap: () => navController.changeTab(1),
                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryText,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryText,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),

              // Right Icon
              GestureDetector(
                onTap: () => navController.changeTab(2),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person,
                      color: navController.currentIndex.value == 2
                          ? Color.fromARGB(255, 69, 67, 67)
                          : Colors.grey,
                      size: 25,
                    ),
                    Text(
                      pageKeys[2].tr,
                      style: TextStyle(
                        fontSize: 12,
                        color: navController.currentIndex.value == 2
                            ? const Color.fromARGB(255, 69, 67, 67)
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/navbar_controller.dart';
import 'package:travel_app/utils/colors.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key}) : super(key: key);

  final NavbarController navController = Get.find<NavbarController>();
  final pageKeys = ["favorites", "home", "profile"];

  @override
  Widget build(BuildContext context) {
    return Obx(() => SizedBox(
          height: 80,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryText,
                        blurRadius: 10,
                      ),
                    ],
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Sol ikon
                      GestureDetector(
                        onTap: () => navController.changeTab(0),
                        child: Transform.translate(
                          offset: Offset(0, 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.favorite,
                                color: navController.currentIndex.value == 0
                                    ? Color.fromARGB(255, 69, 67, 67)
                                    : Colors.grey,
                                size: 22,
                              ),
                              Text(
                                pageKeys[0].tr,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: navController.currentIndex.value == 0
                                      ? const Color.fromARGB(255, 69, 67, 67)
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 60),

                      // Sağ ikon
                      GestureDetector(
                        onTap: () => navController.changeTab(2),
                        child: Transform.translate(
                          offset: Offset(0, 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.person,
                                color: navController.currentIndex.value == 2
                                    ? Color.fromARGB(255, 69, 67, 67)
                                    : Colors.grey,
                                size: 22,
                              ),
                              Text(
                                pageKeys[2].tr,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: navController.currentIndex.value == 2
                                      ? Color.fromARGB(255, 69, 67, 67)
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Orta Home İkonu (çıkıntılı)
              Positioned(
                top: -10,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () => navController.changeTab(1),
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        color: AppColors.primaryText,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryText.withOpacity(0.6),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

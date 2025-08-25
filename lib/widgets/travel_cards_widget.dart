import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/controllers/travel_controller.dart';
import 'package:travel_app/utils/colors.dart';

class TravelCard extends StatelessWidget {
  final Map<String, dynamic> travel;

  const TravelCard({super.key, required this.travel});

  @override
  Widget build(BuildContext context) {
    final DateTime startDate = (travel['startDate'] as Timestamp).toDate();
    final DateTime endDate = (travel['endDate'] as Timestamp).toDate();

    final String formattedStart = DateFormat("dd MMM yyyy").format(startDate);
    final String formattedEnd = DateFormat("dd MMM yyyy").format(endDate);

    final controller = Get.find<TravelController>();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: SizedBox(
        width: 300,
        height: 200,
        child: Card(
          color: AppColors.primaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(16, 36, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      travel['title'] ?? '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "$formattedStart - $formattedEnd",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.background,
                      ),
                    ),
                    SizedBox(height: 18),
                    Text(
                      travel['description'] ?? '',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),

              // Favori butonu
              Positioned(
                right: 8,
                top: 4,
                child: Obx(() {
                  final isFav = controller.favorites.contains(travel['id']);
                  return IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      controller.toggleFavorite(travel['id']);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

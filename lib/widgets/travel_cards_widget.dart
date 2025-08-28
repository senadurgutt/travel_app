import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/travel_controller.dart';
import 'package:travel_app/utils/colors.dart';

class TravelCard extends StatelessWidget {
  final Map<String, dynamic> travel;

  const TravelCard({super.key, required this.travel});

  DateTime parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    if (value is Timestamp) return value.toDate();
    return DateTime.now();
  }

  String formatDateNumeric(DateTime date) {
  final day = date.day.toString().padLeft(2, '0'); 
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();

  return "$day/$month/$year";
}

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TravelController>();

    final startDate = parseDate(travel['startDate']);
    final endDate = parseDate(travel['endDate']);

    final formattedStart = formatDateNumeric(startDate);
final formattedEnd = formatDateNumeric(endDate);

    // Çok dilli veriler
    String getField(Map<String, dynamic> map) {
      final lang = controller.lang.value;
      if (map[lang] != null && map[lang] is String) return map[lang];
      return '';
    }

    final title = travel['title'] is Map
        ? getField(travel['title'])
        : travel['title'] ?? '';

    final description = travel['description'] is Map
        ? getField(travel['description'])
        : travel['description'] ?? '';

    final country = travel['country'] is Map
        ? getField(travel['country'])
        : travel['country'] ?? '';

    final region = travel['region'] is Map
        ? getField(travel['region'])
        : travel['region'] ?? '';

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
                    // Başlık
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.background,
                      ),
                    ),
                    SizedBox(height: 4),
                    // Tarihler
                    Text(
                      "$formattedStart  -  $formattedEnd",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.background,
                      ),
                    ),
                    SizedBox(height: 8),
                    // Country ve Region
                    Text(
                      "$country • $region",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.background.withOpacity(0.7),
                      ),
                    ),
                    SizedBox(height: 12),
                    // Açıklama
                    Text(
                      description,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
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
                      size: 24,
                    ),
                    onPressed: () => controller.toggleFavorite(travel['id']),
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

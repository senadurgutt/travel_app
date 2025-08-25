import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/controllers/travel_controller.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(travel['title'] ?? '',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    "$formattedStart - $formattedEnd",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    travel['description'] ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),

            // Favori butonu
            Positioned(
              right: 8,
              top: 8,
              child: Obx(() {
                // favori seti reactive
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
    );
  }
}

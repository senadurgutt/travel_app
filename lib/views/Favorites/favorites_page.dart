import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:travel_app/controllers/travel_controller.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TravelController>();

    return Obx(() {
      final categories = controller.categories;

      if (categories.isEmpty) {
        return Center(child: Text("Hiç favori bulunamadı."));
      }
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 24),
        children: categories.map((category) {
          final favTravels = controller.travels.where((t) =>
              t["category"] == category &&
              controller.favorites.contains(t["id"]));

          if (favTravels.isEmpty) return SizedBox();

          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              trailing: SizedBox.shrink(),
              title: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
              children: favTravels.map((travel) {
                final startDate =
                    (travel['startDate'] as Timestamp).toDate();
                final endDate = (travel['endDate'] as Timestamp).toDate();
                final formattedStart =
                    DateFormat("dd MMM yyyy").format(startDate);
                final formattedEnd =
                    DateFormat("dd MMM yyyy").format(endDate);

                return ListTile(
                  title: Text("${travel['title']} - ${travel['country']}"),
                  subtitle: Text("$formattedStart - $formattedEnd"),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite,
                        color: Colors.red, size: 17),
                    onPressed: () {
                      controller.toggleFavorite(travel['id']);
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      );
    });
  }
}

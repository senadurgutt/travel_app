import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/travel_controller.dart';
import 'package:travel_app/utils/date_format.dart';

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
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 24),
        children: categories.map((category) {
          final favTravels = controller.travels.where((t) {
            final cat = t["category"];
            final itemCategory = cat is Map
                ? cat[controller.lang.value] ?? cat.values.first
                : cat;

            return itemCategory == category.key &&
                controller.favorites.contains(t["id"]);
          });

          if (favTravels.isEmpty) return const SizedBox();

          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              trailing: SizedBox.shrink(),
              title: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category.value,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
              children: favTravels.map((travel) {
                final startDate = travel['startDate'] as DateTime?;
                final endDate = travel['endDate'] as DateTime?;

                final formattedStart = formatDateNumeric(startDate);
                final formattedEnd = formatDateNumeric(endDate);

                final title = (travel['title'] is Map)
                    ? travel['title'][controller.lang.value] ?? ''
                    : travel['title'] ?? '';

                final country = (travel['country'] is Map)
                    ? travel['country'][controller.lang.value] ?? ''
                    : travel['country'] ?? '';

                return ListTile(
                  title: Text("$title - $country"),
                  subtitle: Text("$formattedStart - $formattedEnd"),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 17,
                    ),
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

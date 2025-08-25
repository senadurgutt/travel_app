import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/travel_controller.dart';
import 'package:travel_app/widgets/travel_cards_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TravelController travelController = Get.put(TravelController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
          child: Column(
            children: [
              SizedBox(height: 12),

              // Kategori Dropdown
              Obx(() => _buildDropdown(
                    value: travelController.selectedCategory.value,
                    hint: "Kategori seçiniz",
                    items: travelController.categories,
                    onChanged: (val) {
                      travelController.selectedCategory.value = val;
                      // Dependent filtreleri sıfırla
                      travelController.selectedCountry.value = null;
                      travelController.selectedRegion.value = null;
                    },
                  )),

              SizedBox(height: 12),

              // Ülke Dropdown
              Obx(() {
                final canPickCountry =
                    travelController.selectedCategory.value != null;
                final countryItems = canPickCountry
                    ? travelController.countries
                    : <String>[];

                return _buildDropdown(
                  value: travelController.selectedCountry.value,
                  hint: "Ülke seçiniz",
                  items: countryItems,
                  onChanged: canPickCountry
                      ? (val) {
                          travelController.selectedCountry.value = val;
                          // Bölgeyi sıfırla
                          travelController.selectedRegion.value = null;
                        }
                      : null,
                );
              }),

              SizedBox(height: 12),

              // Bölge Dropdown
              Obx(() {
                final canPickRegion =
                    travelController.selectedCategory.value != null &&
                        travelController.selectedCountry.value != null;

                final regionItems = canPickRegion
                    ? travelController.regions
                    : <String>[];

                return _buildDropdown(
                  value: travelController.selectedRegion.value,
                  hint: "Bölge seçiniz",
                  items: regionItems,
                  onChanged: canPickRegion
                      ? (val) {
                          travelController.selectedRegion.value = val;
                        }
                      : null,
                );
              }),

              SizedBox(height: 16),

              // Kart Listesi
              Expanded(
                child: Obx(() {
                  final travels = travelController.filteredTravels;

                  if (travels.isEmpty) {
                    return Center(
                        child: Text(
                            "Seçilen filtrelere uygun bir seyahat bulunamadı"));
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: travels.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: TravelCard(travel: travels[index]),
                      );
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

  // Tekrarlayan dropdown widget
  Widget _buildDropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required void Function(String?)? onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(border: InputBorder.none),
        hint: Text(hint),
        items: items
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

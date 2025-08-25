import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:travel_app/controllers/travel_controller.dart';
import 'package:travel_app/widgets/travel_cards_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TravelController travelController = Get.put(TravelController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // KATEGORİ
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => DropdownButtonFormField<String>(
                  value: travelController.selectedCategory.value,
                  hint: const Text("Kategori seçiniz"),
                  items: travelController.categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (val) {
                    travelController.selectedCategory.value = val;
                    // alt seçimleri sıfırla
                    travelController.selectedCountry.value = null;
                    travelController.selectedRegion.value = null;
                  },
                ),
              ),
            ),

            // ÜLKE
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                final canPickCountry =
                    travelController.selectedCategory.value != null;
                final countryItems = canPickCountry
                    ? travelController.countries
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList()
                    : <DropdownMenuItem<String>>[];

                return DropdownButtonFormField<String>(
                  value: travelController.selectedCountry.value,
                  hint: const Text("Ülke seçiniz"),
                  items: countryItems,
                  onChanged: canPickCountry
                      ? (val) {
                          travelController.selectedCountry.value = val;
                          // bölgeyi sıfırla
                          travelController.selectedRegion.value = null;
                        }
                      : null,
                );
              }),
            ),

            // BÖLGE
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                final canPickRegion =
                    travelController.selectedCategory.value != null &&
                    travelController.selectedCountry.value != null;

                final regionItems = canPickRegion
                    ? travelController.regions
                          .map(
                            (r) => DropdownMenuItem(value: r, child: Text(r)),
                          )
                          .toList()
                    : <DropdownMenuItem<String>>[];

                return DropdownButtonFormField<String>(
                  value: travelController.selectedRegion.value,
                  hint: const Text("Bölge seçiniz"),
                  items: regionItems,
                  onChanged: canPickRegion
                      ? (val) {
                          travelController.selectedRegion.value = val;
                        }
                      : null,
                );
              }),
            ),

            // KART LİSTESİ
            Expanded(
              child: Obx(() {
                final travels = travelController.filteredTravels;

                if (travels.isEmpty) {
                  return const Center(child: Text("Henüz veri yok"));
                }

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,

                  itemCount: travels.length,
                  itemBuilder: (context, index) {
                    return TravelCard(travel: travels[index]);
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:travel_app/controllers/travel_controller.dart';
import 'package:travel_app/utils/colors.dart';
import 'package:travel_app/widgets/travel_cards_widget.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TravelController travelController = Get.put(TravelController());
  final PageController _pageController = PageController();

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
              Obx(() => _buildCategoryDropdown()),

              SizedBox(height: 12),

              // Ülke Dropdown
              Obx(() {
                final canPickCountry =
                    travelController.selectedCategory.value != null;
                final countryItems = canPickCountry
                    ? travelController.countries
                    : <String>[];

                return _buildDropdown(
                  value: countryItems.contains(
                          travelController.selectedCountry.value)
                      ? travelController.selectedCountry.value
                      : null,
                  hint: "select_country".tr,
                  items: countryItems,
                  onChanged: canPickCountry
                      ? (val) {
                          travelController.selectedCountry.value = val;
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
                final regionItems =
                    canPickRegion ? travelController.regions : <String>[];

                return _buildDropdown(
                  value: regionItems.contains(
                          travelController.selectedRegion.value)
                      ? travelController.selectedRegion.value
                      : null,
                  hint: "select_region".tr,
                  items: regionItems,
                  onChanged: canPickRegion
                      ? (val) {
                          travelController.selectedRegion.value = val;
                        }
                      : null,
                );
              }),

              SizedBox(height: 16),

              // Kart Listesi ve Indicator
              Obx(() {
                final travels = travelController.filteredTravels;

                if (travels.isEmpty) {
                  return Expanded(
                    child: Center(child: Text("no_travel_found".tr)),
                  );
                }

                return Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: travels.length,
                          itemBuilder: (context, index) {
                            final travel = travels[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 12),
                              child: TravelCard(travel: travel),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 10),

                      Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: travels.length,
                          effect: WormEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            spacing: 6,
                            activeDotColor: AppColors.primaryText,
                            dotColor: AppColors.background,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<String>(
        value: travelController.selectedCategory.value,
        decoration: InputDecoration(border: InputBorder.none),
        hint: Text("select_category".tr),
        items: travelController.categories.map((categoryEntry) {
          return DropdownMenuItem<String>(
            value: categoryEntry.key, // Key'i value olarak kullan
            child: Text(categoryEntry.value), // Value'yu görüntüle
          );
        }).toList(),
        onChanged: (selectedKey) {
          if (selectedKey != null) {
            travelController.selectedCategory.value = selectedKey;
            travelController.selectedCountry.value = null;
            travelController.selectedRegion.value = null;
          }
        },
      ),
    );
  }

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
            .map((e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

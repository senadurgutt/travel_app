import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final selectedCategory = RxnString();
  final selectedRegion = RxnString();
  final selectedCountry = RxnString();

  // Örnek dropdown verileri (ileride Firestore’dan gelecek)
  final categories = ["Kültür", "Doğa", "Macera"];
  final regions = ["Berlin", "Viyana", "Zürih"];
  final countries = ["Almanya", "Avusturya", "İsviçre"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => DropdownButtonFormField<String>(
                value: selectedCategory.value,
                hint: Text("Kategori seçiniz"),
                items: categories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(c),
                )).toList(),
                onChanged: (val) {
                  selectedCategory.value = val;
                  selectedRegion.value = null;
                  selectedCountry.value = null;
                },
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => DropdownButtonFormField<String>(
                value: selectedRegion.value,
                hint: Text("Bölge seçiniz"),
                items: selectedCategory.value == null
                    ? []
                    : regions.map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r),
                      )).toList(),
                onChanged: (val) {
                  selectedRegion.value = val;
                  selectedCountry.value = null;
                },
              )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => DropdownButtonFormField<String>(
                value: selectedCountry.value,
                hint: Text("Ülke seçiniz"),
                items: selectedRegion.value == null
                    ? []
                    : countries.map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r),
                      )).toList(),
                onChanged: (val) {
                  selectedCountry.value = val;
                },
              )),
            ),

// Travel Cards
            Expanded(
              child: PageView.builder(
                itemCount: 5, // firestore’dan gelecek
                controller: PageController(viewportFraction: 0.8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Berlin Yaz Tatili",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 4),
                                Text("15 Temmuz 2025 - 25 Temmuz 2025"),
                                SizedBox(height: 8),
                                Text(
                                  "Berlin'de müzeler, tarihi bölgeler ve kültürel etkinlikler...",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: IconButton(
                              icon: Icon(Icons.favorite_border),
                              onPressed: () {
                                // favorilere ekleme işlemi
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

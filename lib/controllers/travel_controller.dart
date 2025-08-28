/*
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Örnek JSON yapısı: assets/translations/tr-TR.json, en-US.json, de-DE.json
const Map<String, Map<String, String>> categoryJson = {
  "tr": {
    "Festival": "Festival",
    "Tarih": "Tarih",
    "Sanat": "Sanat",
    "Doğa": "Doğa",
    "Kültür": "Kültür",
    "Gastronomi": "Gastronomi",
    "Macera": "Macera"
  },
  "en": {
    "Festival": "Festival",
    "Tarih": "History",
    "Sanat": "Art",
    "Doğa": "Nature",
    "Kültür": "Culture",
    "Gastronomi": "Gastronomy",
    "Macera": "Adventure"
  },
  "de": {
    "Festival": "Festival",
    "Tarih": "Geschichte",
    "Sanat": "Kunst",
    "Doğa": "Natur",
    "Kültür": "Kultur",
    "Gastronomi": "Gastronomie",
    "Macera": "Abenteuer"
  },
};

const Map<String, Map<String, String>> regionsJson = {
  "tr": {
    "Sachsen": "Sachsen",
    "Bern": "Bern",
    "Tirol": "Tirol",
    "Hessen": "Hessen",
    "Wien": "Viyana",
    "Zürich": "Zürih",
    "Vorarlberg": "Vorarlberg",
    "Berlin": "Berlin",
    "Bayern": "Bavyera",
    "Genève": "Cenevre",
    "Luzern": "Luzern",
    "Hamburg": "Hamburg",
    "Steiermark": "Steiermark",
    "Valais": "Valais",
    "Salzburg": "Salzburg"
  },
  "en": {
    "Sachsen": "Saxony",
    "Bern": "Bern",
    "Tirol": "Tyrol",
    "Hessen": "Hesse",
    "Wien": "Vienna",
    "Zürich": "Zurich",
    "Vorarlberg": "Vorarlberg",
    "Berlin": "Berlin",
    "Bayern": "Bavaria",
    "Genève": "Geneva",
    "Luzern": "Lucerne",
    "Hamburg": "Hamburg",
    "Steiermark": "Styria",
    "Valais": "Valais",
    "Salzburg": "Salzburg"
  },
  "de": {
    "Sachsen": "Sachsen",
    "Bern": "Bern",
    "Tirol": "Tirol",
    "Hessen": "Hessen",
    "Wien": "Wien",
    "Zürich": "Zürich",
    "Vorarlberg": "Vorarlberg",
    "Berlin": "Berlin",
    "Bayern": "Bayern",
    "Genève": "Genf",
    "Luzern": "Luzern",
    "Hamburg": "Hamburg",
    "Steiermark": "Steiermark",
    "Valais": "Wallis",
    "Salzburg": "Salzburg"
  },
};

class TravelController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var travels = <Map<String, dynamic>>[].obs;
  var favorites = RxSet<String>();

Rx<String?> selectedCategory = Rx<String?>(null);
  var selectedRegion = RxnString();
  var selectedCountry = RxnString();
  var lang = "tr".obs;

  // ---------------- Tarih normalizasyon ----------------
  Map<String, dynamic> normalizeTravelData(String id, Map<String, dynamic> travel) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return {
      ...travel,
      "id": id,
      "startDate": parseDate(travel["startDate"]),
      "endDate": parseDate(travel["endDate"]),
    };
  }

  @override
  void onInit() {
    super.onInit();

    _db.collection('travels').snapshots().listen((snapshot) {
      travels.value = snapshot.docs.map((doc) {
        return normalizeTravelData(doc.id, doc.data());
      }).toList();

      _loadInitialFavorites();
    });

    _loadUserFavorites();
  }

  void _loadInitialFavorites() {
    for (var t in travels) {
      if (t['isFavorite'] == true) {
        favorites.add(t['id']);
      }
    }
  }

  void _loadUserFavorites() {
    final user = _auth.currentUser;
    if (user == null) return;

    _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
      favorites.value = snapshot.docs.map((doc) => doc.id).toSet();
    });
  }

  Future<void> toggleFavorite(String travelId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(travelId);

    if (favorites.contains(travelId)) {
      favorites.remove(travelId);
      await favRef.delete();
    } else {
      favorites.add(travelId);
      await favRef.set({"addedAt": FieldValue.serverTimestamp()});
    }
  }

  // ---------------- Çok dilli getterlar ----------------

  // Kategoriler (JSON üzerinden)
  List<MapEntry<String, String>> get categories {
  final map = categoryJson[lang.value] ?? {};
  var entries = map.entries.toList();
  entries.sort((a, b) => a.value.compareTo(b.value));
  return entries;
}

  // Ülkeler (Firestore + seçilen kategori)
  List<String> get countries {
  if (selectedCategory.value == null) return [];

  final Set<String> countrySet = {};

  for (var t in travels) {
    final cat = t["category"];
    final selectedCat = selectedCategory.value;

    // Category eşleşmesi (map veya string)
    final matchCat = cat is Map
        ? (cat[lang.value] ?? cat.values.first) == selectedCat
        : cat == selectedCat;

    if (!matchCat) continue;

    // Country alımı
    final c = t["country"];
    String? countryName;

    if (c is Map) {
      countryName = c[lang.value] ?? c.values.first; // seçilen dil yoksa fallback
    } else if (c is String) {
      countryName = c;
    }

    if (countryName != null) countrySet.add(countryName);
  }

  final all = countrySet.toList()..sort();
  return all;
}


  // Regionlar (JSON üzerinden, kategori + country filtreli)
  List<String> get regions {
    if (selectedCategory.value == null || selectedCountry.value == null) return [];

    final Set<String> regionSet = {};

    for (var t in travels) {
      final cat = t["category"];
      final country = t["country"];
      final selectedCat = selectedCategory.value;
      final selectedCountryVal = selectedCountry.value;

      final matchCat = cat is Map
          ? (cat[lang.value] ?? cat.values.first) == selectedCat
          : cat == selectedCat;
      final matchCountry = country is Map
          ? (country[lang.value] ?? country.values.first) == selectedCountryVal
          : country == selectedCountryVal;

      if (!matchCat || !matchCountry) continue;

      final r = t["region"];
      String? regionName;
      if (r is Map) {
        regionName = regionsJson[lang.value]?[r.keys.first] ?? r.values.first;
      } else if (r is String) {
        regionName = regionsJson[lang.value]?[r] ?? r;
      }

      if (regionName != null) regionSet.add(regionName);
    }

    return regionSet.toList()..sort();
  }

  // Filtrelenmiş travel listesi
  List<Map<String, dynamic>> get filteredTravels {
  final list = travels.where((t) {
    // Category filtreleme - KEY ile karşılaştır
    bool matchCategory = selectedCategory.value == null;
    if (selectedCategory.value != null) {
      if (t["category"] is Map) {
        // Multi-language category - key'in varlığını kontrol et
        Map<String, dynamic> categoryMap = t["category"];
        matchCategory = categoryMap.containsKey(selectedCategory.value);
      } else {
        // String category - direkt key ile karşılaştır
        matchCategory = t["category"] == selectedCategory.value;
      }
    }
    
    // Country filtreleme - VALUE ile karşılaştır (eskisi gibi)
    String? ctry = t["country"] is Map 
        ? t["country"][lang.value] 
        : t["country"]?.toString();
    final matchCountry = selectedCountry.value == null || ctry == selectedCountry.value;
    
    // Region filtreleme - VALUE ile karşılaştır (eskisi gibi)
    String? reg = t["region"] is Map 
        ? t["region"][lang.value] 
        : t["region"]?.toString();
    final matchRegion = selectedRegion.value == null || reg == selectedRegion.value;
    
    return matchCategory && matchCountry && matchRegion;
  }).toList();
  
  list.sort((a, b) {
    final startA = a['startDate'] as DateTime? ?? DateTime.now();
    final startB = b['startDate'] as DateTime? ?? DateTime.now();
    return startA.compareTo(startB);
  });
  

return list;
}

  // Favoriler
  List<Map<String, dynamic>> get favoriteTravels {
    return travels.where((t) => favorites.contains(t['id'])).toList();
  }

  // Dil değiştirme
  void changeLang(String newLang) {
    lang.value = newLang;
  }
}
*/
import 'dart:ui';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const Map<String, Map<String, String>> categoryJson = {
  "tr": {
    "Festival": "Festival",
    "Tarih": "Tarih",
    "Sanat": "Sanat",
    "Doğa": "Doğa",
    "Kültür": "Kültür",
    "Gastronomi": "Gastronomi",
    "Macera": "Macera",
  },
  "en": {
    "Festival": "Festival",
    "Tarih": "History",
    "Sanat": "Art",
    "Doğa": "Nature",
    "Kültür": "Culture",
    "Gastronomi": "Gastronomy",
    "Macera": "Adventure",
  },
  "de": {
    "Festival": "Festival",
    "Tarih": "Geschichte",
    "Sanat": "Kunst",
    "Doğa": "Natur",
    "Kültür": "Kultur",
    "Gastronomi": "Gastronomie",
    "Macera": "Abenteuer",
  },
};

const Map<String, Map<String, String>> regionsJson = {
  "tr": {
    "Sachsen": "Sachsen",
    "Bern": "Bern",
    "Tirol": "Tirol",
    "Hessen": "Hessen",
    "Wien": "Viyana",
    "Zürich": "Zürih",
    "Vorarlberg": "Vorarlberg",
    "Berlin": "Berlin",
    "Bayern": "Bavyera",
    "Genève": "Cenevre",
    "Luzern": "Luzern",
    "Hamburg": "Hamburg",
    "Steiermark": "Steiermark",
    "Valais": "Valais",
    "Salzburg": "Salzburg",
  },
  "en": {
    "Sachsen": "Saxony",
    "Bern": "Bern",
    "Tirol": "Tyrol",
    "Hessen": "Hesse",
    "Wien": "Vienna",
    "Zürich": "Zurich",
    "Vorarlberg": "Vorarlberg",
    "Berlin": "Berlin",
    "Bayern": "Bavaria",
    "Genève": "Geneva",
    "Luzern": "Lucerne",
    "Hamburg": "Hamburg",
    "Steiermark": "Styria",
    "Valais": "Valais",
    "Salzburg": "Salzburg",
  },
  "de": {
    "Sachsen": "Sachsen",
    "Bern": "Bern",
    "Tirol": "Tirol",
    "Hessen": "Hessen",
    "Wien": "Wien",
    "Zürich": "Zürich",
    "Vorarlberg": "Vorarlberg",
    "Berlin": "Berlin",
    "Bayern": "Bayern",
    "Genève": "Genf",
    "Luzern": "Luzern",
    "Hamburg": "Hamburg",
    "Steiermark": "Steiermark",
    "Valais": "Wallis",
    "Salzburg": "Salzburg",
  },
};

class TravelController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var travels = <Map<String, dynamic>>[].obs;
  var favorites = RxSet<String>();

  Rx<String?> selectedCategory = Rx<String?>(null);
  var selectedRegion = RxnString();
  var selectedCountry = RxnString();
  var lang = "de".obs;

  Map<String, dynamic> normalizeTravelData(
    String id,
    Map<String, dynamic> travel,
  ) {
    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    return {
      ...travel,
      "id": id,
      "startDate": parseDate(travel["startDate"]),
      "endDate": parseDate(travel["endDate"]),
    };
  }

  @override
  void onInit() {
    super.onInit();

    lang.value = Get.locale?.languageCode ?? "de";

  _db.collection('travels').snapshots().listen((snapshot) {
    travels.value = snapshot.docs.map((doc) {
      return normalizeTravelData(doc.id, doc.data());
    }).toList();

    _loadInitialFavorites();
  });

  _loadUserFavorites();
}

  void _loadInitialFavorites() {
    for (var t in travels) {
      if (t['isFavorite'] == true) {
        favorites.add(t['id']);
      }
    }
  }

  void _loadUserFavorites() {
    final user = _auth.currentUser;
    if (user == null) return;

    _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .listen((snapshot) {
          favorites.value = snapshot.docs.map((doc) => doc.id).toSet();
        });
  }

  Future<void> toggleFavorite(String travelId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef = _db
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .doc(travelId);

    if (favorites.contains(travelId)) {
      favorites.remove(travelId);
      await favRef.delete();
    } else {
      favorites.add(travelId);
      await favRef.set({"addedAt": FieldValue.serverTimestamp()});
    }
  }

  // Kategoriler JSON
  List<MapEntry<String, String>> get categories {
    final map = categoryJson[lang.value] ?? {};
    var entries = map.entries.toList();
    entries.sort((a, b) => a.value.compareTo(b.value));
    return entries;
  }

  // Ülkeler
  List<String> get countries {
    if (selectedCategory.value == null) return [];

    final Set<String> countrySet = {};

    for (var t in travels) {
      final cat = t["category"];
      final selectedCat = selectedCategory.value;

      // Category eşleşmesi
      final matchCat = cat is Map
          ? (cat[lang.value] ?? cat.values.first) == selectedCat
          : cat == selectedCat;

      if (!matchCat) continue;
      final c = t["country"];
      String? countryName;

      if (c is Map) {
        countryName =
            c[lang.value] ?? c.values.first; // seçilen dil yoksa fallback
      } else if (c is String) {
        countryName = c;
      }

      if (countryName != null) countrySet.add(countryName);
    }

    final all = countrySet.toList()..sort();
    return all;
  }

  // Regionlar
  List<String> get regions {
    if (selectedCategory.value == null || selectedCountry.value == null)
      return [];

    final Set<String> regionSet = {};

    for (var t in travels) {
      final cat = t["category"];
      final country = t["country"];
      final selectedCat = selectedCategory.value;
      final selectedCountryVal = selectedCountry.value;

      final matchCat = cat is Map
          ? (cat[lang.value] ?? cat.values.first) == selectedCat
          : cat == selectedCat;
      final matchCountry = country is Map
          ? (country[lang.value] ?? country.values.first) == selectedCountryVal
          : country == selectedCountryVal;

      if (!matchCat || !matchCountry) continue;

      final r = t["region"];
      String? regionName;
      if (r is Map) {
        regionName = regionsJson[lang.value]?[r.keys.first] ?? r.values.first;
      } else if (r is String) {
        regionName = regionsJson[lang.value]?[r] ?? r;
      }

      if (regionName != null) regionSet.add(regionName);
    }

    return regionSet.toList()..sort();
  }

  // Filtrelenmiş travel listesi
  List<Map<String, dynamic>> get filteredTravels {
    final String curLang = lang.value;

    String? _categoryKeyFromItem(dynamic cat) {
      if (cat == null) return null;

      if (cat is Map) {
        final map = Map<String, dynamic>.from(cat);
        final localized =
            map[curLang]?.toString() ?? map.values.first.toString();
        final locMap = categoryJson[curLang] ?? const <String, String>{};
        for (final entry in locMap.entries) {
          if (entry.value == localized) return entry.key;
        }
        return localized;
      }

      final s = cat.toString();
      final locMap = categoryJson[curLang] ?? const <String, String>{};
      if (locMap.containsKey(s)) return s;
      for (final entry in locMap.entries) {
        if (entry.value == s) return entry.key;
      }
      return s;
    }

    String? _countryLabelFromItem(dynamic ctry) {
      if (ctry == null) return null;
      if (ctry is Map)
        return ctry[curLang]?.toString() ?? ctry.values.first.toString();
      return ctry.toString();
    }

    String? _regionLabelFromItem(dynamic reg) {
      if (reg == null) return null;
      if (reg is Map) {
        // Travel içinde bölge dil haritası ise doğrudan aktif dil metnini kullan
        final map = Map<String, dynamic>.from(reg);
        return map[curLang]?.toString() ?? map.values.first.toString();
      } else {
        final raw = reg.toString();
        final locMap = regionsJson[curLang] ?? const <String, String>{};
        return locMap[raw] ?? raw;
      }
    }

    final list = travels.where((t) {
      // CATEGORY
      bool matchCategory = true;
      if (selectedCategory.value != null) {
        final itemCatKey = _categoryKeyFromItem(t["category"]);
        matchCategory = itemCatKey == selectedCategory.value;
      }

      // COUNTRY
      final itemCountryLabel = _countryLabelFromItem(t["country"]);
      final bool matchCountry =
          selectedCountry.value == null ||
          itemCountryLabel == selectedCountry.value;

      // REGION
      final itemRegionLabel = _regionLabelFromItem(t["region"]);
      final bool matchRegion =
          selectedRegion.value == null ||
          itemRegionLabel == selectedRegion.value;
      return matchCategory && matchCountry && matchRegion;
    }).toList();

    // tarih sıralaması
    list.sort((a, b) {
      final startA = a['startDate'] as DateTime?;
      final startB = b['startDate'] as DateTime?;
      if (startA == null && startB == null) return 0;
      if (startA == null) return 1;
      if (startB == null) return -1;
      return startA.compareTo(startB);
    });

    return list;
  }

  // Favoriler
  List<Map<String, dynamic>> get favoriteTravels {
    return travels.where((t) => favorites.contains(t['id'])).toList();
  }

  // Dil değiştirme
void changeLang(String newLang) {
  lang.value = newLang;

  // Seçili değerler yeni dile göre artık geçersiz olabilir, sıfırla
  selectedCountry.value = null;
  selectedRegion.value = null;

  // GetX güncellemesi
  if (newLang == "tr") {
    Get.updateLocale(Locale("tr", "TR"));
  } else if (newLang == "en") {
    Get.updateLocale(Locale("en", "US"));
  } else if (newLang == "de") {
    Get.updateLocale(Locale("de", "DE"));
  }
}


}

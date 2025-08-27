import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TravelController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var travels = <Map<String, dynamic>>[].obs;
  var favorites = RxSet<String>();

  var selectedCategory = RxnString();
  var selectedRegion = RxnString();
  var selectedCountry = RxnString();
  var lang = "tr".obs;

  // Tarih normalizasyon
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

    // Firestore'dan travels verilerini normalize(birim düzelterek) listele
    _db.collection('travels').snapshots().listen((snapshot) {
      travels.value = snapshot.docs.map((doc) {
        return normalizeTravelData(doc.id, doc.data());
      }).toList();

      _loadInitialFavorites();
    });

    // Kullanıcının favorilerini Firestore’dan çek
    _loadUserFavorites();
  }

  // Firestore’dan başlangıç favorilerini ekle
  void _loadInitialFavorites() {
    for (var t in travels) {
      if (t['isFavorite'] == true) {
        favorites.add(t['id']);
      }
    }
  }

  // Kullanıcı favorilerini Firestore’dan yükle
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

  // Fav ekle/çıkar
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

  // Kategoriler map
  List<String> get categories {
    final all = travels
        .map((t) {
          final cat = t["category"];
          if (cat is Map) {
            return cat[lang.value] as String?;
          }
          return cat as String?;
        })
        .whereType<String>()
        .toSet()
        .toList();
    all.sort();
    return all;
  }

  // Ülkeler map
  List<String> get countries {
    if (selectedCategory.value == null) return [];

    final all = travels
        .where((t) {
          final cat = t["category"];
          final selected = selectedCategory.value;

          if (cat is Map) {
            return cat[lang.value] == selected;
          }
          return cat == selected;
        })
        .map((t) {
          final c = t["country"];
          if (c is Map) return c[lang.value] as String?;
          return c as String?;
        })
        .whereType<String>()
        .toSet()
        .toList();

    all.sort();
    return all;
  }

  // Bölgeler map
  List<String> get regions {
    if (selectedCategory.value == null || selectedCountry.value == null) {
      return [];
    }
    final all = travels
        .where((t) {
          final cat = t["category"];
          final country = t["country"];
          final selectedCat = selectedCategory.value;
          final selectedCountryVal = selectedCountry.value;

          final matchCat = cat is Map
              ? cat[lang.value] == selectedCat
              : cat == selectedCat;
          final matchCountry = country is Map
              ? country[lang.value] == selectedCountryVal
              : country == selectedCountryVal;

          return matchCat && matchCountry;
        })
        .map((t) {
          final r = t["region"];
          if (r is Map) return r[lang.value] as String?;
          return r as String?;
        })
        .whereType<String>()
        .toSet() // tekrarları kaldır
        .toList();
    all.sort();
    return all;
  }

  // Filtrelenmiş travel listesi
  List<Map<String, dynamic>> get filteredTravels {
    final list = travels.where((t) {
      String? cat;
      if (t["category"] is Map) {
        cat = t["category"][lang.value];
      } else {
        cat = t["category"]?.toString();
      }

      String? ctry;
      if (t["country"] is Map) {
        ctry = t["country"][lang.value];
      } else {
        ctry = t["country"]?.toString();
      }

      String? reg;
      if (t["region"] is Map) {
        reg = t["region"][lang.value];
      } else {
        reg = t["region"]?.toString();
      }

      final matchCategory =
          selectedCategory.value == null || cat == selectedCategory.value;
      final matchCountry =
          selectedCountry.value == null || ctry == selectedCountry.value;
      final matchRegion =
          selectedRegion.value == null || reg == selectedRegion.value;

      return matchCategory && matchCountry && matchRegion;
    }).toList();

    // Tarih bazlı sıralama
    list.sort((a, b) {
      final startA = a['startDate'] is DateTime
          ? a['startDate'] as DateTime
          : a['startDate'] is String
          ? DateTime.tryParse(a['startDate']) ?? DateTime.now()
          : DateTime.now();

      final startB = b['startDate'] is DateTime
          ? b['startDate'] as DateTime
          : b['startDate'] is String
          ? DateTime.tryParse(b['startDate']) ?? DateTime.now()
          : DateTime.now();

      return startA.compareTo(startB);
    });

    return list;
  }

  // Favori sayfası için getter
  List<Map<String, dynamic>> get favoriteTravels {
    return travels.where((t) => favorites.contains(t['id'])).toList();
  }

  // JSON dosya isimlerini maplemek için
  final Map<String, String> langMap = {
    "tr": "tr-TR",
    "de": "de-DE",
    "en": "en-US",
  };
  void changeLang(String newLang) {
    lang.value = newLang;
  }
}

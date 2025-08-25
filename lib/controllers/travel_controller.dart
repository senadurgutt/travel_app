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

  @override
  void onInit() {
    super.onInit();

    _db.collection('travels').snapshots().listen((snapshot) {
      travels.value = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data(),
        };
      }).toList();
    });

    // Kullanıcının favorileri
    _loadUserFavorites();
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

  // Kullanıcı favorilemiş mi
  bool isFavorite(String travelId) {
    return favorites.contains(travelId);
  }

  // Favori ekle/çıkar
  Future<void> toggleFavorite(String travelId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef =
        _db.collection('users').doc(user.uid).collection('favorites').doc(travelId);

    if (favorites.contains(travelId)) {
      await favRef.delete();
    } else {
      await favRef.set({"addedAt": FieldValue.serverTimestamp()});
    }
  }

  //  Mevcut travels’tan kategorileri çıkar
  List<String> get categories {
    final all = travels
        .map((t) => t["category"] as String?)
        .whereType<String>()
        .toSet()
        .toList();
    all.sort();
    return all;
  }

  // ÜLKELER
  List<String> get countries {
    if (selectedCategory.value == null) return [];
    final all = travels
        .where((t) => t["category"] == selectedCategory.value)
        .map((t) => t["country"] as String?)
        .whereType<String>()
        .toSet()
        .toList();
    all.sort();
    return all;
  }

  // KATEGORİ 
  List<String> get regions {
    if (selectedCategory.value == null || selectedCountry.value == null) return [];
    final all = travels
        .where((t) =>
            t["category"] == selectedCategory.value &&
            t["country"] == selectedCountry.value)
        .map((t) => t["region"] as String?)
        .whereType<String>()
        .toSet()
        .toList();
    all.sort();
    return all;
  }

  // filtrelere UYGUN travel listesi
  List<Map<String, dynamic>> get filteredTravels {
    return travels.where((t) {
      final matchCategory =
          selectedCategory.value == null || t["category"] == selectedCategory.value;
      final matchRegion =
          selectedRegion.value == null || t["region"] == selectedRegion.value;
      final matchCountry =
          selectedCountry.value == null || t["country"] == selectedCountry.value;
      return matchCategory && matchRegion && matchCountry;
    }).toList();
  }
}

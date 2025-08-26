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

    // Firestore'dan travels çek
    _db.collection('travels').snapshots().listen((snapshot) {
      travels.value = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data(),
        };
      }).toList();

      _loadInitialFavorites();
    });

    // Kullanıcının favorilerini Firestore’dan çek
    _loadUserFavorites();
  }

  //Firestore’dan gelen başlangıç favorilerini yükle
  void _loadInitialFavorites() {
    for (var t in travels) {
      if (t['isFavorite'] == true) {
        favorites.add(t['id']);
      }
    }
  }

  // Kullanıcı favorileirni firestıre yükler
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

  // Fav ekle/çıkar
  Future<void> toggleFavorite(String travelId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final favRef =
        _db.collection('users').doc(user.uid).collection('favorites').doc(travelId);

    if (favorites.contains(travelId)) {
      favorites.remove(travelId);
      await favRef.delete();
    } else {
      favorites.add(travelId);
      await favRef.set({"addedAt": FieldValue.serverTimestamp()});
    }
  }

  // kategoriler
  List<String> get categories {
    final all = travels
        .map((t) => t["category"] as String?)
        .whereType<String>()
        .toSet()
        .toList();
    all.sort();
    return all;
  }

  // Ülkeler
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

  // Bölgeler
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

  // Filtrelenmiş travel listesi
  List<Map<String, dynamic>> get filteredTravels {
    final list = travels.where((t) {
      final category = t["category"]?.toString();
      final country = t["country"]?.toString();
      final region = t["region"]?.toString();

      final matchCategory = selectedCategory.value == null ||
          category == selectedCategory.value;
      final matchCountry = selectedCountry.value == null ||
          country == selectedCountry.value;
      final matchRegion = selectedRegion.value == null ||
          region == selectedRegion.value;

      return matchCategory && matchCountry && matchRegion;
    }).toList();

    // Tarih bazlı sıralama (en yakın tarih önde)
    list.sort((a, b) {
      final dateA = (a['startDate'] as Timestamp).toDate();
      final dateB = (b['startDate'] as Timestamp).toDate();
      return dateA.compareTo(dateB);
    });

    return list;
  }

  // FAVORİ SAYFASI İÇİN GETTER
  List<Map<String, dynamic>> get favoriteTravels {
    return travels.where((t) => favorites.contains(t['id'])).toList();
  }
}

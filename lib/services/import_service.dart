import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> importTravels() async {
    // JSON dosyasını oku
    final String jsonString =
        await rootBundle.loadString('assets/data/travels.json');
    final List<dynamic> travels = json.decode(jsonString);


    // Firestore'a ekle
    for (var travel in travels) {
      final String id = travel['id']; // JSON'daki id'yi kullan

      await _db.collection('travels').doc(id).set({
        'title': travel['title'],
        'country': travel['country'],
        'region': travel['region'],
        'startDate': DateTime.parse(travel['startDate']),
        'endDate': DateTime.parse(travel['endDate']),
        'category': travel['category'],
        'description': travel['description'],
        'isFavorite': travel['isFavorite'] ?? false,
      }, SetOptions(merge: true));

    }
  } 
}
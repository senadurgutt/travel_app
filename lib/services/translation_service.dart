import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AppTranslations extends Translations {
  static Map<String, Map<String, dynamic>> _translations = {};

  static Future<void> init() async {
    _translations['tr_TR'] = json.decode(await rootBundle.loadString('assets/translations/tr-TR.json'));
    _translations['en_US'] = json.decode(await rootBundle.loadString('assets/translations/en-US.json'));
    _translations['de_DE'] = json.decode(await rootBundle.loadString('assets/translations/de-DE.json'));
  }

  @override
  Map<String, Map<String, String>> get keys {
    // Flatten nested values sadece string olanları al
    final Map<String, Map<String, String>> flat = {};
    _translations.forEach((locale, map) {
      flat[locale] = {};
      map.forEach((key, value) {
        if (value is String) {
          flat[locale]![key] = value;
        }
        // nested map'ler (categories, regions) burada atlanır
      });
    });
    return flat;
  }

  // Nested key'lere erişim için helper
  static Map<String, String> getNested(String key) {
    final locale = Get.locale.toString();
    final map = _translations[locale]?[key];
    if (map != null && map is Map) {
      return Map<String, String>.from(map);
    }
    return {};
  }
}

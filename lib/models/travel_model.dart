class TravelModel {
  final String id;
  final String title;
  final String country;
  final String region;
  final DateTime startDate;
  final DateTime endDate;
  final String category;
  final String description;
  bool isFavorite; // Firestore'dan kontrol edilecek
  TravelModel({
    required this.id,
    required this.title,
    required this.country,
    required this.region,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.description,
    this.isFavorite = false,
  });

  factory TravelModel.fromJson(Map<String, dynamic> json) {
    return TravelModel(
      id: json['id'],
      title: json['title'],
      country: json['country'],
      region: json['region'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      category: json['category'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "country": country,
      "region": region,
      "startDate": startDate.toIso8601String(),
      "endDate": endDate.toIso8601String(),
      "category": category,
      "description": description,
    };
  }
}

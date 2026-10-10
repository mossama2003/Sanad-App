class CityModel {
  final String id;
  final String governorateId;
  final String nameAr;
  final String nameEn;

  CityModel({
    required this.id,
    required this.governorateId,
    required this.nameAr,
    required this.nameEn,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'].toString(),
      governorateId: json['governorate_id'].toString(),
      nameAr: json['city_name_ar'] ?? '',
      nameEn: json['city_name_en'] ?? '',
    );
  }
}

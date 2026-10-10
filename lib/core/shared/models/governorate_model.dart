class GovernorateModel {
  final String id;
  final String nameAr;
  final String nameEn;

  GovernorateModel({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      id: json['id'].toString(),
      nameAr: json['governorate_name_ar'] ?? '',
      nameEn: json['governorate_name_en'] ?? '',
    );
  }
}
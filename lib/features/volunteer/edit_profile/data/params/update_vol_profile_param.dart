import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class UpdateVolAccountParam {
  UpdateVolAccountParam({
    required this.email,
    required this.lastName,
    required this.phone,
    this.avatar,
  });

  final String email;
  final String lastName;
  final String phone;
  final File? avatar;

  Future<FormData> toFormData() async {
    return FormData.fromMap({
      'email': email,
      'last_name': lastName,
      'phone': phone,
      if (avatar != null)
        'avatar': await MultipartFile.fromFile(
          avatar!.path,
          filename: p.basename(avatar!.path),
        ),
    });
  }
}

class UpdateVolProfileParam {
  UpdateVolProfileParam({
    this.profession,
    this.bloodGroup,
    this.emergencyExperience,
    this.ownVehicle,
    this.country,
    this.state,
    this.city,
    this.address,
    this.languages = const [],
    this.skills = const [],
  });

  final String? profession;
  final String? bloodGroup;
  final int? emergencyExperience;
  final bool? ownVehicle;
  final String? country;
  final String? state;
  final String? city;
  final String? address;
  final List<String> languages;
  final List<String> skills;

  Map<String, dynamic> toJson() {
    return {
      if (profession != null) 'profession': profession,
      if (bloodGroup != null) 'blood_group': bloodGroup,
      if (emergencyExperience != null)
        'emergencey_experience': emergencyExperience,
      if (ownVehicle != null) 'own_vehicle': ownVehicle,
      if (country != null) 'country': country,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (address != null) 'address': address,

      // مهم جدًا
      'languages': languages,
      'skills': skills,
    };
  }
}

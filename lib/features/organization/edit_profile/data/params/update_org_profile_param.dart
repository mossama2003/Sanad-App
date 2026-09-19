import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path/path.dart' as p;

class UpdateOrgAccountParam {
  UpdateOrgAccountParam({
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

class UpdateOrgProfileParam {
  UpdateOrgProfileParam({
    this.website,
    this.state,
    this.city,
    this.headquarters,
    this.bio,
    this.organizationType,
    this.registerationNo,
    this.branches = const [],
    this.facebook,
    this.linkedin,
    this.twitter,
    this.instagram,
  });

  final String? website;
  final String? state;
  final String? city;
  final String? headquarters;
  final String? bio;
  final String? organizationType;
  final String? registerationNo;
  final List<String> branches;
  final String? facebook;
  final String? linkedin;
  final String? twitter;
  final String? instagram;

  FormData toFormData() {
    final formData = FormData.fromMap({
      if (website != null) 'website': website,
      if (state != null) 'state': state,
      if (city != null) 'city': city,
      if (headquarters != null) 'headquarters': headquarters,
      if (bio != null) 'bio': bio,
      if (organizationType != null) 'organization_type': organizationType,
      if (registerationNo != null) 'registeration_no': registerationNo,

      if (facebook != null) 'social_media_links[facebook]': facebook,

      if (twitter != null) 'social_media_links[twitter]': twitter,

      if (instagram != null) 'social_media_links[instagram]': instagram,

      if (linkedin != null) 'social_media_links[linkedin]': linkedin,
    });

    for (final branch in branches) {
      formData.fields.add(MapEntry('branches', branch));
    }

    return formData;
  }
}

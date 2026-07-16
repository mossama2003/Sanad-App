import 'dart:io';

import 'package:dio/dio.dart';

class VolunteerParam {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String gender;
  final String bloodGroup;
  final String dob;
  final String nid;
  final String country;
  final String state;
  final String city;
  final String address;
  final List<int> interests;
  final File? avatar;
  final List<File> attachments;

  VolunteerParam({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.gender,
    required this.bloodGroup,
    required this.dob,
    required this.nid,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.interests,
    required this.attachments,
    required this.avatar,
  });

  Future<Map<String, dynamic>> toJson() async {
    return {
      'creator[name]': name,
      'creator[email]': email,
      'creator[phone]': phone,
      'creator[password]': password,
      'gender': gender,
      'blood_group': bloodGroup,
      'dob': dob,
      'nid': nid,
      'country': country,
      'city': city,
      'state': state,
      'address': address,

      for (int i = 0; i < interests.length; i++) 'interests[$i]': interests[i],

      if (avatar != null)
        'creator[avatar]': await MultipartFile.fromFile(
          avatar!.path,
          filename: avatar!.path.split('/').last,
        ),

      for (int i = 0; i < attachments.length; i++)
        'creator[attachments][$i]': await MultipartFile.fromFile(
          attachments[i].path,
          filename: attachments[i].path.split('/').last,
        ),
    };
  }
}

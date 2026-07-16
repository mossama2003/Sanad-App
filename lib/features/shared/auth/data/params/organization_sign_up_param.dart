import 'dart:io';

class OrganizationParam {
  final String name;
  final String email;
  final String password;
  final String phone;

  final File avatar;
  final List<File> attachments;

  final String website;
  final String headquarters;
  final String state;

  OrganizationParam({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.avatar,
    required this.attachments,
    required this.website,
    required this.state,
    required this.headquarters,
  });

  Map<String, dynamic> toJson() {
    return {
      'creator[name]': name,
      'creator[email]': email,
      'creator[password]': password,
      'creator[phone]': phone,
      'website': website,
      'state': state,
      'headquarters': headquarters,
    };
  }
}

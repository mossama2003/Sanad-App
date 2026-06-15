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
  final String address;

  final List<String> branches;

  OrganizationParam({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.avatar,
    required this.attachments,
    required this.website,
    required this.headquarters,
    required this.address,
    required this.branches,
  });

  Map<String, dynamic> toJson() {
    return {
      'creator[name]': name,
      'creator[email]': email,
      'creator[password]': password,
      'creator[phone]': phone,

      'website': website,
      'headquarters': headquarters,
      'address': address,

      // branches list
      for (int i = 0; i < branches.length; i++)
        'branches[$i]': branches[i],
    };
  }
}
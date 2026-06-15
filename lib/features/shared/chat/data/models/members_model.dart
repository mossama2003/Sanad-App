import 'dart:ui';

import '../enums/member_role_enum.dart';

class MembersModel {
  final String name;
  final String? subtitle;
  final bool isOnline;
  final Color avatarColor;
  final MemberRoleEnum role;

  const MembersModel({
    required this.name,
    this.subtitle,
    this.isOnline = false,
    required this.avatarColor,
    required this.role,
  });

  String get avatarLetter => name[0].toUpperCase();

  String get statusText => subtitle ?? (isOnline ? 'Online now' : 'Offline');
}

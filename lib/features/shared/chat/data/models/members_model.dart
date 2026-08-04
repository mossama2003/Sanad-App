import '../enums/member_role_enum.dart';

class MemberModel {
  final int id;
  final String volunteerName;
  final String role;

  const MemberModel({
    required this.id,
    required this.volunteerName,
    required this.role,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] ?? 0,
      volunteerName: json['volunteer'] ?? '',
      role: (json['role'] ?? '').toString(),
    );
  }

  MemberRoleEnum get roleEnum {
    switch (role.trim().toLowerCase()) {
      case 'admin':
        return MemberRoleEnum.admin;
      case 'organization':
      case 'organizer':
        return MemberRoleEnum.organizer;
      default:
        return MemberRoleEnum.volunteer;
    }
  }

  String get avatarLetter => volunteerName.trim().isNotEmpty
      ? volunteerName.trim()[0].toUpperCase()
      : '?';
}

class PaginatedMembersModel {
  final int count;
  final int maxPages;
  final String? next;
  final String? previous;
  final List<MemberModel> results;

  const PaginatedMembersModel({
    required this.count,
    required this.maxPages,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedMembersModel.fromJson(Map<String, dynamic> json) {
    return PaginatedMembersModel(
      count: json['count'] ?? 0,
      maxPages: json['max_pages'] ?? 1,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => MemberModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get hasMore => next != null;
}

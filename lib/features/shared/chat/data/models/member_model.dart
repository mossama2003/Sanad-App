import '../enums/member_role_enum.dart';

class MemberModel {
  final int id;
  final int userId;
  final String volunteerName;
  final String role;

  const MemberModel({
    required this.id,
    required this.userId,
    required this.volunteerName,
    required this.role,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      volunteerName: json['volunteer'] ?? '',
      role: (json['role'] ?? '').toString(),
    );
  }

  MemberModel copyWith({String? role}) {
    return MemberModel(
      id: id,
      userId: userId,
      volunteerName: volunteerName,
      role: role ?? this.role,
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

class PaginatedMemberModel {
  final int count;
  final int maxPages;
  final String? next;
  final String? previous;
  final List<MemberModel> results;

  const PaginatedMemberModel({
    required this.count,
    required this.maxPages,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedMemberModel.fromJson(Map<String, dynamic> json) {
    return PaginatedMemberModel(
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

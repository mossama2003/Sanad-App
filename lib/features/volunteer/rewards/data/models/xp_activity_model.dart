import 'dart:ui';

import '../../../../../core/style/app_colors.dart';

class XpActivityModel {
  final int? id;
  final String title;
  final String description;
  final int xp;
  final String createdAt;
  final String icon;
  final Color iconColor;
  final Color iconBgColor;

  const XpActivityModel({
    this.id,
    required this.title,
    required this.description,
    required this.xp,
    required this.createdAt,
    required this.icon,
    this.iconColor = AppColors.primary,
    this.iconBgColor = const Color(0x1F6750A4),
  });

  factory XpActivityModel.fromJson(Map<String, dynamic> json) {
    return XpActivityModel(
      id: _toIntOrNull(json['id']),
      title: (json['title'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      xp: _toInt(json['xp'] ?? json['points'] ?? json['amount']),
      createdAt:
      (json['created'] ?? json['created_at'] ?? json['timestamp'] ?? '')
          .toString(),
      icon: (json['icon'] ?? '').toString(),
    );
  }
}

class LeaderboardModel {
  final int rank;
  final String name;
  final int xp;

  const LeaderboardModel({
    required this.rank,
    required this.name,
    required this.xp,
  });

  factory LeaderboardModel.fromJson(
    Map<String, dynamic> json, {
    required int rank,
  }) {
    final volunteer = json['volunteer'];

    String name;

    if (volunteer is Map) {
      name =
          (volunteer['name'] ??
                  '${volunteer['first_name'] ?? ''} '
                      '${volunteer['last_name'] ?? ''}')
              .toString()
              .trim();
    } else {
      name = (volunteer ?? json['name'] ?? '').toString();
    }

    return LeaderboardModel(rank: rank, name: name, xp: _toInt(json['xp']));
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();

  return int.tryParse(value?.toString() ?? '') ?? 0;
}

int? _toIntOrNull(dynamic value) {
  if (value == null) return null;
  return _toInt(value);
}

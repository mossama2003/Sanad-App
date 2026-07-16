import 'dart:ui';

class XpActivityModel {
  final String icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String time;
  final int xp;

  const XpActivityModel({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.time,
    required this.xp,
  });
}
import 'package:flutter/cupertino.dart';

class ChatModel {
  final String senderName;
  final String? badge;
  final Color? badgeColor;
  final String? badgeIcon;
  final String text;
  final String time;
  final Color avatarColor;
  final String avatarLetter;
  String? reactionEmoji;
  int reactionCount;

  ChatModel({
    required this.senderName,
    this.badge,
    this.badgeColor,
    this.badgeIcon,
    required this.text,
    required this.time,
    required this.avatarColor,
    required this.avatarLetter,
    this.reactionEmoji,
    this.reactionCount = 0,
  });
}

class PinnedMessage {
  final String title;
  final String body;
  final String icon;
  final Color color;

  const PinnedMessage({
    required this.title,
    required this.body,
    required this.icon,
    required this.color,
  });
}

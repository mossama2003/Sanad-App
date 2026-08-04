import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../organization/events/data/models/organization_event_details_model.dart';
import '../../../../volunteer/events/data/models/volunteer_event_details_model.dart';
import '../enums/member_role_enum.dart';

import 'package:hive/hive.dart';

part 'chat_model.g.dart';

enum ChatMessageStatus { sending, sent, failed }

class ChatModel {
  final int? id;
  final String? localId;
  final String senderName;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeTextColor;
  final String? badgeIcon;
  final String text;
  final String time;
  final DateTime createdAt;
  final Color avatarColor;
  final String avatarLetter;
  String? reactionEmoji;
  int reactionCount;
  final ChatMessageStatus status;
  final bool isEdited;

  ChatModel({
    this.id,
    this.localId,
    required this.senderName,
    this.badge,
    this.badgeColor,
    this.badgeIcon,
    this.badgeTextColor,
    required this.text,
    required this.time,
    required this.createdAt,
    required this.avatarColor,
    required this.avatarLetter,
    this.reactionEmoji,
    this.reactionCount = 0,
    this.status = ChatMessageStatus.sent,
    this.isEdited = false,
  });

  ChatModel copyWith({
    int? id,
    ChatMessageStatus? status,
    String? text,
    bool? isEdited,
  }) {
    return ChatModel(
      id: id ?? this.id,
      localId: localId,
      senderName: senderName,
      badge: badge,
      badgeColor: badgeColor,
      badgeIcon: badgeIcon,
      badgeTextColor: badgeTextColor,
      text: text ?? this.text,
      time: time,
      createdAt: createdAt,
      avatarColor: avatarColor,
      avatarLetter: avatarLetter,
      reactionEmoji: reactionEmoji,
      reactionCount: reactionCount,
      status: status ?? this.status,
      isEdited: isEdited ?? this.isEdited,
    );
  }
}

class ChatEventModel {
  final int id;
  final String name;
  final DateTime date;
  final String? cover;
  final String status;
  final int organizerId;
  final String organizerName;
  final String? organizerAvatar;

  const ChatEventModel({
    required this.id,
    required this.name,
    required this.date,
    this.cover,
    required this.status,
    required this.organizerId,
    required this.organizerName,
    this.organizerAvatar,
  });
}

class ChatTokenModel {
  final String keyName;
  final String clientId;
  final int timestamp;
  final String nonce;
  final String mac;
  final int ttl;
  final String capability;

  ChatTokenModel({
    required this.keyName,
    required this.clientId,
    required this.timestamp,
    required this.nonce,
    required this.mac,
    required this.ttl,
    required this.capability,
  });

  factory ChatTokenModel.fromJson(Map<String, dynamic> json) {
    return ChatTokenModel(
      keyName: json['keyName'] ?? '',
      clientId: json['clientId'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      nonce: json['nonce'] ?? '',
      mac: json['mac'] ?? '',
      ttl: json['ttl'] ?? 0,
      capability: json['capability'] ?? '',
    );
  }
}

class SendChatMessageModel {
  final int id;
  final int event;
  final DateTime created;
  final DateTime modified;
  final String message;

  SendChatMessageModel({
    required this.id,
    required this.event,
    required this.created,
    required this.modified,
    required this.message,
  });

  factory SendChatMessageModel.fromJson(Map<String, dynamic> json) {
    return SendChatMessageModel(
      id: json['id'] ?? 0,
      event: json['event'] ?? 0,
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
      modified: DateTime.tryParse(json['modified'] ?? '') ?? DateTime.now(),
      message: json['message'] ?? '',
    );
  }
}

@HiveType(typeId: 6)
class EventChatCreatorModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? avatar;

  @HiveField(3)
  final String role;

  EventChatCreatorModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.role,
  });

  factory EventChatCreatorModel.fromJson(Map<String, dynamic> json) {
    return EventChatCreatorModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['full_name'] ?? '',
      avatar: json['avatar'] ?? json['image'],
      role: (json['role'] ?? '').toString(),
    );
  }
}

@HiveType(typeId: 7)
class EventChatDetailModel extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final EventChatCreatorModel creator;
  @HiveField(2)
  final String role; // "admin" | "organizer" | "volunteer"
  @HiveField(3)
  final DateTime created;
  @HiveField(4)
  final DateTime modified;
  @HiveField(5)
  final String message;
  @HiveField(6)
  final bool isEdited;

  EventChatDetailModel({
    required this.id,
    required this.creator,
    required this.role,
    required this.created,
    required this.modified,
    required this.message,
    this.isEdited = false,
  });

  factory EventChatDetailModel.fromJson(Map<String, dynamic> json) {
    return EventChatDetailModel(
      id: json['id'] ?? 0,
      creator: EventChatCreatorModel.fromJson(json['creator'] ?? {}),
      role: (json['role'] ?? '').toString(),
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
      modified: DateTime.tryParse(json['modified'] ?? '') ?? DateTime.now(),
      message: json['message'] ?? '',
      isEdited: false,
    );
  }

  MemberRoleEnum get roleEnum {
    switch (creator.role.trim().toLowerCase()) {
      case 'admin':
        return MemberRoleEnum.admin;

      case 'organization':
      case 'organizer':
        return MemberRoleEnum.organizer;

      default:
        return MemberRoleEnum.volunteer;
    }
  }

  ChatModel toUiModel({required int currentUserId}) {
    final isMe = creator.id == currentUserId;

    return ChatModel(
      id: id,
      senderName: isMe ? 'You' : creator.name,
      badge: roleEnum == MemberRoleEnum.admin
          ? 'Sanad Admin'
          : roleEnum == MemberRoleEnum.organizer
          ? 'Organizer'
          : null,

      badgeColor: roleEnum == MemberRoleEnum.admin
          ? AppColors.primary
          : roleEnum == MemberRoleEnum.organizer
          ? AppColors.secondary400.withValues(alpha: 0.1)
          : null,

      badgeTextColor: roleEnum == MemberRoleEnum.admin
          ? AppColors.white
          : roleEnum == MemberRoleEnum.organizer
          ? AppColors.secondary400
          : null,

      badgeIcon: roleEnum == MemberRoleEnum.admin
          ? AppIcons.check
          : roleEnum == MemberRoleEnum.organizer
          ? AppIcons.crown
          : null,
      text: message,
      time: DateFormat('h:mm a').format(created.toLocal()),
      createdAt: created.toLocal(),
      avatarColor: _avatarColorFor(creator.id),
      avatarLetter: creator.name.isNotEmpty
          ? creator.name[0].toUpperCase()
          : '?',
      status: ChatMessageStatus.sent,
      isEdited: isEdited,
    );
  }

  Color _avatarColorFor(int id) {
    const colors = [AppColors.primary, AppColors.bronze, AppColors.laserBlue];
    return colors[id % colors.length];
  }
}

class PaginatedEventChatModel {
  final int count;
  final String? next;
  final String? previous;
  final List<EventChatDetailModel> results;

  PaginatedEventChatModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PaginatedEventChatModel.fromJson(Map<String, dynamic> json) {
    return PaginatedEventChatModel(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>? ?? [])
          .map((e) => EventChatDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  bool get hasMore => next != null;
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

extension VolunteerEventChatMapper on VolunteerEventDetailsModel {
  ChatEventModel toChatEvent() {
    final creatorMap = creator;

    return ChatEventModel(
      id: id,
      name: name,
      date: date,
      cover: cover,
      status: status,
      organizerId: creatorMap?['id'] is int ? creatorMap!['id'] as int : 0,
      organizerName: (creatorMap?['name'] ?? '').toString(),
      organizerAvatar: creatorMap?['avatar']?.toString(),
    );
  }
}

extension OrganizationEventChatMapper on OrganizationEventDetailsModel {
  ChatEventModel toChatEvent() {
    final creatorMap = creator;

    return ChatEventModel(
      id: id,
      name: name,
      date: date,
      cover: cover,
      status: status,
      organizerId: creatorMap?['id'] is int ? creatorMap!['id'] as int : 0,
      organizerName: (creatorMap?['name'] ?? '').toString(),
      organizerAvatar: creatorMap?['avatar']?.toString(),
    );
  }
}

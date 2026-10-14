enum NotificationEnums { badge, xp, urgentCase, event, general }

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final DateTime timestamp;
  final String level;
  final bool isRead;
  final Map<String, dynamic> data;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    required this.level,
    required this.isRead,
    this.data = const {},
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    return NotificationModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      body: (json['message'] ?? json['body'])?.toString() ?? '',
      timestamp:
          DateTime.tryParse(
            (json['timestamp'] ?? json['created_at'])?.toString() ?? '',
          ) ??
          DateTime.now(),
      level: json['level']?.toString() ?? 'info',
      isRead: json['unread'] is bool
          ? !(json['unread'] as bool)
          : json['is_read'] is bool
          ? json['is_read'] as bool
          : false,
      data: rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{},
    );
  }

  NotificationEnums get type {
    final category =
        (data['category'] ?? data['type'] ?? data['notification_type'])
            .toString()
            .toLowerCase();

    switch (category) {
      case 'reward':
      case 'badge':
        return NotificationEnums.badge;

      case 'xp':
        return NotificationEnums.xp;

      case 'emergency':
      case 'urgent_case':
        return NotificationEnums.urgentCase;

      case 'event':
        return NotificationEnums.event;

      default:
        return NotificationEnums.general;
    }
  }

  int? get xpAmount {
    final value = data['xp'] ?? data['xp_amount'];
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '');
  }

  String get relativeTime {
    final difference = DateTime.now().difference(timestamp.toLocal());

    if (difference.inSeconds < 60) return 'Just now';
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    }
    if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${timestamp.toLocal().day}/'
        '${timestamp.toLocal().month}/'
        '${timestamp.toLocal().year}';
  }

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      body: body,
      timestamp: timestamp,
      level: level,
      isRead: isRead ?? this.isRead,
      data: data,
    );
  }
}

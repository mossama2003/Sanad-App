import '../enums/notification_enums.dart';

class NotificationModel {
  final NotificationEnums type;
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final int? xpAmount;

  const NotificationModel({
    required this.type,
    required this.title,
    required this.body,
    required this.time,
    this.isRead = false,
    this.xpAmount,
  });

  NotificationModel copyWith({
    NotificationEnums? type,
    String? title,
    String? body,
    String? time,
    bool? isRead,
    int? xpAmount,
  }) {
    return NotificationModel(
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
      xpAmount: xpAmount ?? this.xpAmount,
    );
  }
}

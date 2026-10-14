part of 'notification_cubit.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsSuccess extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationsSuccess(this.notifications);
}

class NotificationsError extends NotificationsState {
  final String message;

  NotificationsError(this.message);
}
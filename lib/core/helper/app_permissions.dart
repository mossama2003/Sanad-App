import 'package:permission_handler/permission_handler.dart';

Future<bool> checkNotificationPermission() async {
  final notificationPermission = await Permission.notification.status;
  return notificationPermission == PermissionStatus.granted;
}

Future<void> requestNotificationPermission() async {
  final notificationPermission = await Permission.notification.status;

  if (notificationPermission != PermissionStatus.granted) {
    await Permission.notification.request();
  }
}

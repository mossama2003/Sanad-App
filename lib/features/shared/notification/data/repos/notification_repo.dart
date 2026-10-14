import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../models/notification_model.dart';

part 'notification_repo_impel.dart';

abstract class NotificationsRepo {
  Future<Either<Failure, List<NotificationModel>>> getAllNotifications({
    int page = 1,
    int size = 20,
    String? category,
    bool? unread,
    String? search,
    String? ordering,
  });

  Future<Either<Failure, void>> registerDevice({
    required String registrationId,
    required String type,
    String? deviceId,
    String? name,
  });
}

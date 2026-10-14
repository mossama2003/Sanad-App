part of 'notification_repo.dart';

class NotificationsRepoImpel implements NotificationsRepo {
  @override
  Future<Either<Failure, List<NotificationModel>>> getAllNotifications({
    int page = 1,
    int size = 20,
    String? category,
    bool? unread,
    String? search,
    String? ordering,
  }) async {
    try {
      final allNotifications = <NotificationModel>[];
      var currentPage = page;
      var maxPages = page;

      do {
        final response = await DioHelper.get(
          url: GET_NOTIFICATIONS,
          query: {
            'page': currentPage,
            'size': size,
            if (category != null && category.isNotEmpty) 'category': category,
            if (unread != null) 'unread': unread,
            if (search != null && search.isNotEmpty) 'search': search,
            if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
          },
        );

        final data = Map<String, dynamic>.from(response.data);

        final results = data['results'] as List<dynamic>? ?? [];

        allNotifications.addAll(
          results.map(
            (json) => NotificationModel.fromJson(
              Map<String, dynamic>.from(json as Map),
            ),
          ),
        );

        maxPages = (data['max_pages'] as num?)?.toInt() ?? currentPage;

        currentPage++;
      } while (currentPage <= maxPages);

      return Right(allNotifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> registerDevice({
    required String registrationId,
    required String type,
    String? deviceId,
    String? name,
  }) async {
    try {
      await DioHelper.post(
        url: REGISTER_FCM_DEVICE,
        data: {
          'registration_id': registrationId,
          'type': type,
          'active': true,
          if (deviceId != null) 'device_id': deviceId,
          if (name != null) 'name': name,
        },
      );

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

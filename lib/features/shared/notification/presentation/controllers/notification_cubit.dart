import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/notification_model.dart';
import '../../data/repos/notification_repo.dart';

part 'notification_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this.repo) : super(NotificationsInitial());

  final NotificationsRepo repo;

  List<NotificationModel> notifications = [];

  int totalCount = 0;
  int currentPage = 1;
  int pageSize = 20;

  String? searchQuery;
  String? ordering;

  bool isLoading = false;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get filteredNotifications {
    switch (_selectedTab) {
      case 1:
        return notifications.where((n) => !n.isRead).toList();

      case 2:
        return notifications
            .where(
              (n) =>
                  n.type == NotificationEnums.badge ||
                  n.type == NotificationEnums.xp,
            )
            .toList();

      case 3:
        return notifications
            .where((n) => n.type == NotificationEnums.event)
            .toList();

      default:
        return notifications;
    }
  }

  int _selectedTab = 0;

  int get selectedTab => _selectedTab;

  void changeTab(int index) {
    _selectedTab = index;
    emit(NotificationsSuccess(List.of(notifications)));
  }

  Future<void> getAllNotifications({
    int page = 1,
    int size = 20,
    String? search,
    String? ordering,
  }) async {
    if (isLoading) return;

    isLoading = true;
    emit(NotificationsLoading());

    currentPage = page;
    pageSize = size;
    searchQuery = search;
    this.ordering = ordering;

    try {
      final result = await repo.getAllNotifications(
        page: page,
        size: size,
        search: search,
        ordering: ordering,
      );

      result.fold(
        (failure) {
          emit(NotificationsError(failure.errMessage));
        },
        (data) {
          notifications = data;
          totalCount = data.length;
          emit(NotificationsSuccess(List.of(notifications)));
        },
      );
    } catch (e) {
      emit(NotificationsError(e.toString()));
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshNotifications() async {
    await getAllNotifications(
      page: 1,
      size: pageSize,
      search: searchQuery,
      ordering: ordering,
    );
  }

  // لا نغيّر حالة القراءة محليًا قبل معرفة endpoint
  // الخاص بتعليم الإشعارات كمقروءة في Django.
}

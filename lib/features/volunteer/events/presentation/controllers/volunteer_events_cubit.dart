import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../data/models/volunteer_event_details_model.dart';
import '../../data/params/get_volunteer_events_param.dart';
import '../../data/repos/volunteer_events_repo.dart';
import '../../../../../core/helper/app_toast.dart';

part 'volunteer_events_state.dart';

class VolunteerEventsCubit extends Cubit<VolunteerEventsState> {
  VolunteerEventsCubit(this.repo) : super(EventsInitial());

  final VolunteerEventsRepo repo;

  static VolunteerEventsCubit get(BuildContext context) =>
      BlocProvider.of<VolunteerEventsCubit>(context);

  static const String _eventsLastUpdatedKey = 'volunteer_events_last_updated';

  String? selectedStatus;

  // ===================== Events =====================

  final List<VolunteerEventDetailsModel> events = [];

  int currentPage = 1;

  String? nextPage;

  bool isLoadingMore = false;

  // ===================== Hive Refresh Events =====================l
  bool shouldRefreshEvents() {
    final lastUpdated = HiveBoxes.cacheInfoBox.get(_eventsLastUpdatedKey);

    if (lastUpdated == null) {
      return true;
    }

    final difference = DateTime.now().difference(lastUpdated);

    return difference.inMinutes > 10;
  }

  // ===================== Hive Cache =====================

  Future<void> _saveEventsToCache() async {
    final box = HiveBoxes.volunteerEventsBox;

    await box.clear();

    await box.addAll(events);
  }

  void loadEventsFromCache() {
    final box = HiveBoxes.volunteerEventsBox;

    if (box.isEmpty) return;

    events
      ..clear()
      ..addAll(box.values);

    emit(Success());
  }

  // ===================== Get Organization Events =====================

  Future<void> getVolunteerEvents({
    bool refresh = false,
    String? status,
  }) async {
    if (refresh) {
      currentPage = 1;
      selectedStatus = status;
    }

    // Load Cache First
    if (!refresh && events.isEmpty) {
      loadEventsFromCache();

      if (!shouldRefreshEvents() && events.isNotEmpty) {
        return;
      }
    }

    final result = await repo.getVolunteerEvents(
      GetVolunteerEventsParam(
        page: currentPage,
        size: 10,
        status: selectedStatus == null ? null : [selectedStatus!],
      ),
    );

    result.fold(
      (l) {
        if (events.isEmpty) {
          emit(Error());
        }

        AppToast.error(l.errMessage);
      },

      (r) async {
        events
          ..clear()
          ..addAll(r.results);

        nextPage = r.next;

        await _saveEventsToCache();

        await HiveBoxes.cacheInfoBox.put(_eventsLastUpdatedKey, DateTime.now());

        emit(Success());
      },
    );
  }

  // ===================== Load More =====================

  Future<void> loadMoreVolunteerEvents() async {
    if (isLoadingMore || nextPage == null) {
      return;
    }

    isLoadingMore = true;

    final result = await repo.getVolunteerEvents(
      GetVolunteerEventsParam(
        page: currentPage + 1,
        size: 10,
        status: selectedStatus == null ? null : [selectedStatus!],
      ),
    );

    result.fold(
      (failure) {
        AppToast.error(failure.errMessage);
      },

      (response) async {
        currentPage++;

        events.addAll(response.results);

        nextPage = response.next;

        await _saveEventsToCache();

        emit(Success());
      },
    );

    isLoadingMore = false;
  }

  @override
  Future<void> close() {
    return super.close();
  }
}

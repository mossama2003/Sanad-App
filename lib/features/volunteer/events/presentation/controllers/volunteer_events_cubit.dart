import 'package:easy_localization/easy_localization.dart';
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

  // ===================== Events Category =====================

  String? selectedCategory;

  final List<String> eventCategories = [
    'Education',
    'Healthcare',
    'Environment',
    'Community Service',
    'Food Distribution',
    'Fundraising',
    'Blood Donation',
    'Elderly Care',
    'Children Support',
    'Animal Welfare',
    'Sports',
    'Arts & Culture',
    'Technology',
    'Career Development',
    'Emergency Relief',
    'Other',
  ];

  bool get isOtherSelected => selectedCategory == 'Other';

  bool isKnownCategory(String? category) {
    if (category == null) return false;

    return eventCategories.where((e) => e != 'Other').contains(category);
  }

  List<VolunteerEventDetailsModel> get filteredEvents {
    if (selectedCategory == null) {
      return events;
    }

    if (selectedCategory == 'Other') {
      return events.where((e) => !isKnownCategory(e.category)).toList();
    }

    return events.where((e) => e.category == selectedCategory).toList();
  }

  final Map<String, String> categoryTranslations = {
    'Education': 'volunteer.events.filter.education'.tr(),
    'Healthcare': 'volunteer.events.filter.healthcare'.tr(),
    'Environment': 'volunteer.events.filter.environment'.tr(),
    'Community Service': 'volunteer.events.filter.community_service'.tr(),
    'Food Distribution': 'volunteer.events.filter.food_distribution'.tr(),
    'Fundraising': 'volunteer.events.filter.fundraising'.tr(),
    'Blood Donation': 'volunteer.events.filter.blood_donation'.tr(),
    'Elderly Care': 'volunteer.events.filter.elderly_care'.tr(),
    'Children Support': 'volunteer.events.filter.children_support'.tr(),
    'Animal Welfare': 'volunteer.events.filter.animal_welfare'.tr(),
    'Sports': 'volunteer.events.filter.sports'.tr(),
    'Arts & Culture': 'volunteer.events.filter.arts_culture'.tr(),
    'Technology': 'volunteer.events.filter.technology'.tr(),
    'Career Development': 'volunteer.events.filter.career_development'.tr(),
    'Emergency Relief': 'volunteer.events.filter.emergency_relief'.tr(),
    'Other': 'volunteer.events.filter.other'.tr(),
  };

  String? getCategoryKey(String translatedCategory) {
    try {
      return categoryTranslations.entries
          .firstWhere((e) => e.value == translatedCategory)
          .key;
    } catch (_) {
      return null;
    }
  }

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
    String? category,
  }) async {
    if (refresh) {
      currentPage = 1;
      selectedStatus = status;
      selectedCategory = category;
    }

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
        category: selectedCategory == 'Other' ? null : selectedCategory,
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

  // ===================== Join Event =====================

  Future<void> joinEvent(int eventId) async {
    final result = await repo.joinEvent(eventId);

    result.fold(
      (failure) {
        AppToast.error(failure.errMessage);
      },
      (_) async {
        final index = events.indexWhere((e) => e.id == eventId);

        if (index != -1) {
          final event = events[index];

          events[index] = event.copyWith(
            attendees: event.attendees + 1,
            spots: event.spots > 0 ? event.spots - 1 : 0,
            joined: true,
            joiners: event.joiners + 1,
          );

          await _saveEventsToCache();
        }

        AppToast.success('volunteer.events.successfully_joined_event'.tr());

        emit(Success());
      },
    );
  }

  // ===================== Leave Event =====================

  Future<void> leaveEvent(int eventId) async {
    final result = await repo.leaveEvent(eventId);

    result.fold(
      (failure) {
        AppToast.error(failure.errMessage);
      },

      (_) async {
        final index = events.indexWhere((event) => event.id == eventId);

        if (index != -1) {
          final event = events[index];

          final updatedEvent = VolunteerEventDetailsModel(
            id: event.id,
            creator: event.creator,
            location: event.location,

            joiners: event.joiners > 0 ? event.joiners - 1 : 0,

            attendees: event.attendees,

            spots: event.spots + 1,

            joined: false,

            avgRating: event.avgRating,

            unreadChatMessages: event.unreadChatMessages,

            latestMessage: event.latestMessage,

            cover: event.cover,

            name: event.name,

            description: event.description,

            category: event.category,

            date: event.date,

            due: event.due,

            skills: event.skills,

            status: event.status,

            qr: event.qr,

            created: event.created,

            modified: event.modified,
          );

          events[index] = updatedEvent;

          await _saveEventsToCache();
        }

        AppToast.success('volunteer.events.successfully_left_event'.tr());

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
        category: selectedCategory == 'Other' ? null : selectedCategory,
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
}

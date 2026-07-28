import 'dart:async';

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

  bool nearBy = false;

  bool thisWeek = false;

  DateTime? dateAfter;

  DateTime? dateBefore;

  String sortType = 'soonest';

  bool? mostAvailableSpots;

  // ===================== Events Search =====================

  final TextEditingController searchController = TextEditingController();

  Timer? debounce;

  String? search;

  void onSearchChanged(String value) {
    debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      search = value;
      _refreshWithCurrentFilters();
    });
  }

  // ===================== Sort =====================

  void setSort(String type) {
    sortType = type;
    _refreshWithCurrentFilters();
  }

  // ===================== QUICK Filter =====================

  void updateQuickFilters({bool? nearMe, bool? thisWeekFilter}) {
    if (nearMe != null) {
      nearBy = nearMe;
    }

    if (thisWeekFilter != null) {
      thisWeek = thisWeekFilter;
    }

    // ================= This Week =================

    if (thisWeek) {
      final now = DateTime.now();

      dateAfter = DateTime(now.year, now.month, now.day);

      dateBefore = dateAfter!.add(const Duration(days: 6));
    } else {
      dateAfter = null;
      dateBefore = null;
    }

    _refreshWithCurrentFilters();
  }

  // ===================== Events Category =====================

  final Set<String> selectedCategories = {};

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

  bool get isOtherSelected => selectedCategories.contains('Other');

  bool isKnownCategory(String? category) {
    if (category == null) return false;

    return eventCategories.where((e) => e != 'Other').contains(category);
  }

  void toggleCategory(String category) {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }

    _refreshWithCurrentFilters();
  }

  List<VolunteerEventDetailsModel> get filteredEvents {
    if (selectedCategories.isEmpty) {
      return events;
    }

    return events.where((event) {
      if (selectedCategories.contains('Other')) {
        if (!isKnownCategory(event.category)) {
          return true;
        }
      }

      return selectedCategories.contains(event.category);
    }).toList();
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

    await HiveBoxes.cacheInfoBox.put(_eventsLastUpdatedKey, DateTime.now());
  }

  void loadEventsFromCache() {
    final box = HiveBoxes.volunteerEventsBox;

    if (box.isEmpty) return;

    events
      ..clear()
      ..addAll(box.values);

    emit(Success());
  }

  Future<void> _refreshWithCurrentFilters() {
    mostAvailableSpots = sortType == 'available'
        ? true
        : sortType == 'popular'
        ? false
        : null;

    return getVolunteerEvents(
      refresh: true,
      status: selectedStatus,
      categories: Set<String>.from(selectedCategories),
      nearByFilter: nearBy,
      startDate: dateAfter,
      endDate: dateBefore,
      searchText: search,
      mostAvailableSpots: mostAvailableSpots,
    );
  }

  // ===================== Get Volunteer Events =====================
  Future<void> getVolunteerEvents({
    bool refresh = false,
    String? status,
    Set<String>? categories,
    bool? nearByFilter,
    DateTime? startDate,
    DateTime? endDate,
    String? searchText,
    String? ordering,
    bool? mostAvailableSpots,
  }) async {
    if (refresh) {
      currentPage = 1;

      selectedStatus = status;

      selectedCategories
        ..clear()
        ..addAll(categories ?? {});

      nearBy = nearByFilter ?? false;

      dateAfter = startDate;
      dateBefore = endDate;

      search = searchText;

      this.mostAvailableSpots = mostAvailableSpots;
    }

    // ================= Cache First =================

    if (!refresh && events.isEmpty) {
      loadEventsFromCache();
    }

    final result = await repo.getVolunteerEvents(
      GetVolunteerEventsParam(
        page: currentPage,
        size: 10,

        // Category comma separated
        category: selectedCategories.isEmpty
            ? null
            : selectedCategories.toList(),

        status: selectedStatus == null ? null : [selectedStatus!],

        // send only when true
        nearBy: nearBy ? true : null,

        // send only true/false when selected from filter
        mostAvailableSpots: this.mostAvailableSpots,

        ordering: null,

        dateAfter: dateAfter == null
            ? null
            : DateFormat('yyyy-MM-dd', 'en_US').format(dateAfter!),

        dateBefore: dateBefore == null
            ? null
            : DateFormat('yyyy-MM-dd', 'en_US').format(dateBefore!),

        search: search?.trim().isEmpty ?? true ? null : search,
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

          events[index] = event.copyWith(
            joined: false,
            joiners: event.joiners > 0 ? event.joiners - 1 : 0,
          );

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

        category: selectedCategories.isEmpty
            ? null
            : selectedCategories.toList(),

        status: selectedStatus == null ? null : [selectedStatus!],

        nearBy: nearBy ? true : null,

        mostAvailableSpots: mostAvailableSpots,

        ordering: null,

        dateAfter: dateAfter == null
            ? null
            : DateFormat('yyyy-MM-dd', 'en_US').format(dateAfter!),

        dateBefore: dateBefore == null
            ? null
            : DateFormat('yyyy-MM-dd', 'en_US').format(dateBefore!),

        search: search,
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
    debounce?.cancel();
    searchController.dispose();
    return super.close();
  }
}

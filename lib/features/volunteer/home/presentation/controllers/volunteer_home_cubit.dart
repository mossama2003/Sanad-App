import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../../../shared/donations/presentation/screens/donations_screen.dart';
import '../../../events/data/repos/volunteer_events_repo.dart';
import '../../../events/presentation/screens/volunteer_events_screen.dart';
import '../../../../shared/cases/presentation/screens/cases_screen.dart';
import '../../../events/data/models/volunteer_event_details_model.dart';
import '../../../community/presentation/screens/community_screen.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../data/enums/volunteer_home_navbar_enum.dart';
import '../../data/repos/volunteer_home_repo.dart';
import '../screens/volunteer_home_screen.dart';

part 'volunteer_home_state.dart';

class VolunteerHomeCubit extends Cubit<VolunteerHomeState> {
  VolunteerHomeCubit(this.repo) : super(HomeInitial());

  final VolunteerHomeRepo repo;

  static VolunteerHomeCubit get(BuildContext context) =>
      BlocProvider.of(context);

  final VolunteerEventsRepo _eventsRepo = VolunteerEventsRepoImpel();

  final Box<VolunteerEventDetailsModel> _eventsBox =
      HiveBoxes.volunteerEventsBox;

  List<VolunteerEventDetailsModel> joinedEvents = [];

  VolunteerHomeNavbarItem selectedItem = VolunteerHomeNavbarItem.home;

  Widget get currentScreen => _screens[selectedItem]!;

  final Map<VolunteerHomeNavbarItem, Widget> _screens = {
    VolunteerHomeNavbarItem.home: const VolunteerHomeScreen(),
    VolunteerHomeNavbarItem.events: const VolunteerEventsScreen(),
    VolunteerHomeNavbarItem.community: const CommunityScreen(),
    VolunteerHomeNavbarItem.donations: const DonationsScreen(),
    VolunteerHomeNavbarItem.cases: const CasesScreen(),
  };

  void loadJoinedEvents() {
    joinedEvents = _eventsBox.values.where((e) => e.joined).toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    emit(Success());
  }

  Future<void> joinEvent(int eventId) async {
    final result = await _eventsRepo.joinEvent(eventId);

    result.fold((failure) => AppToast.error(failure.errMessage), (_) async {
      final index = _eventsBox.values.toList().indexWhere(
        (e) => e.id == eventId,
      );

      if (index != -1) {
        final event = _eventsBox.getAt(index)!;

        await _eventsBox.putAt(
          index,
          event.copyWith(
            joined: true,
            joiners: event.joiners + 1,
            attendees: event.attendees + 1,
            spots: event.spots > 0 ? event.spots - 1 : 0,
          ),
        );
      }

      loadJoinedEvents();

      AppToast.success('volunteer.events.successfully_joined_event'.tr());
    });
  }

  Future<void> leaveEvent(int eventId) async {
    final result = await _eventsRepo.leaveEvent(eventId);

    result.fold((failure) => AppToast.error(failure.errMessage), (_) async {
      final index = _eventsBox.values.toList().indexWhere(
        (e) => e.id == eventId,
      );

      if (index != -1) {
        final event = _eventsBox.getAt(index)!;

        await _eventsBox.putAt(
          index,
          event.copyWith(
            joined: false,
            joiners: event.joiners > 0 ? event.joiners - 1 : 0,
            spots: event.spots + 1,
          ),
        );
      }

      loadJoinedEvents();

      AppToast.success('volunteer.events.successfully_left_event'.tr());
    });
  }

  void updateSelectedNavbarItem(VolunteerHomeNavbarItem item) {
    selectedItem = item;
    emit(BottomNavChange());
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../shared/cases/data/repos/cases_repo.dart';
import '../../../../shared/cases/presentation/controllers/case_cubit.dart';
import '../../../../shared/cases/presentation/screens/cases_screen.dart';
import '../../../../shared/donations/presentation/screens/donations_screen.dart';
import '../../../events/presentation/screens/volunteer_events_screen.dart';
import '../../../community/presentation/screens/volunteer_community_screen.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../data/enums/volunteer_home_navbar_enum.dart';
import '../../data/models/volunteer_home_model.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../data/repos/volunteer_home_repo.dart';
import '../screens/volunteer_home_screen.dart';

part 'volunteer_home_state.dart';

class VolunteerHomeCubit extends Cubit<VolunteerHomeState> {
  VolunteerHomeCubit(this.repo) : super(HomeInitial()) {
    casesCubit = CasesCubit(CasesRepoImpel());

    final user = AppCubit.get(AppNavigator.context).user;

    casesCubit.initCasesScreen(isOrg: false, currentUserId: user?.id);
  }

  final VolunteerHomeRepo repo;

  static VolunteerHomeCubit get(BuildContext context) =>
      BlocProvider.of(context);

  VolunteerHomeModel? home;

  VolunteerHomeNavbarItem selectedItem = VolunteerHomeNavbarItem.home;

  final _homeBox = HiveBoxes.volunteerHomeBox;

  late final CasesCubit casesCubit;

  Widget get currentScreen {
    switch (selectedItem) {
      case VolunteerHomeNavbarItem.home:
        return const VolunteerHomeScreen();
      case VolunteerHomeNavbarItem.events:
        return const VolunteerEventsScreen();
      case VolunteerHomeNavbarItem.cases:
        return CasesScreen(casesCubit: casesCubit, isOrg: false);
      case VolunteerHomeNavbarItem.community:
        return const VolunteerCommunityScreen();
      case VolunteerHomeNavbarItem.donations:
        return const DonationsScreen();
    }
  }

  // ===================== Get Home =====================

  Future<void> getVolunteerHome() async {
    final cachedHome = _homeBox.get('home');

    if (cachedHome != null) {
      home = cachedHome;
      emit(Success());
    } else {
      emit(Loading());
    }

    final result = await repo.getVolunteerHome();

    result.fold(
          (failure) {
        if (home == null) {
          emit(Error());
        }

        AppToast.error(failure.errMessage);
      },
          (data) async {
        home = data;

        await _homeBox.put('home', data);

        emit(Success());
      },
    );
  }

  Future<void> joinEvent(int eventId) async {
    final result = await repo.joinEvent(eventId);

    result.fold(
          (failure) {
        AppToast.error(failure.errMessage);
      },
          (_) async {
        _updateEventJoinStatus(eventId, joined: true);

        await _saveHomeCache();

        AppToast.success('volunteer.events.successfully_joined_event'.tr());

        emit(Success());
      },
    );
  }

  Future<void> leaveEvent(int eventId) async {
    final result = await repo.leaveEvent(eventId);

    result.fold(
          (failure) {
        AppToast.error(failure.errMessage);
      },
          (_) async {
        _updateEventJoinStatus(eventId, joined: false);

        await _saveHomeCache();

        AppToast.success('volunteer.events.successfully_left_event'.tr());

        emit(Success());
      },
    );
  }

  void updateSelectedNavbarItem(VolunteerHomeNavbarItem item) {
    selectedItem = item;
    emit(BottomNavChange());
  }

  void _updateEventJoinStatus(int eventId, {required bool joined}) {
    if (home == null) return;

    final index = home!.activeEvents.indexWhere((event) => event.id == eventId);

    if (index == -1) return;

    final event = home!.activeEvents[index];

    home!.activeEvents[index] = event.copyWith(
      joined: joined,

      joiners: joined
          ? event.joiners + 1
          : event.joiners > 0
          ? event.joiners - 1
          : 0,

      attendees: joined
          ? event.attendees + 1
          : event.attendees > 0
          ? event.attendees - 1
          : 0,

      spots: joined
          ? event.spots > 0
          ? event.spots - 1
          : 0
          : event.spots + 1,
    );
  }

  Future<void> _saveHomeCache() async {
    if (home == null) return;

    await _homeBox.put('home', home!);
  }

  @override
  Future<void> close() async {
    await casesCubit.close();
    return super.close();
  }
}

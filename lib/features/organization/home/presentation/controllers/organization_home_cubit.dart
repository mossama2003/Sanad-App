import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../../../coming_soon_screen.dart';
import '../../../../shared/donations/presentation/screens/donations_screen.dart';
import '../../../../shared/cases/presentation/screens/cases_screen.dart';
import '../../../events/data/models/organization_event_details_model.dart';
import '../../../events/data/params/organization_event_update_param.dart';
import '../../../events/data/repos/organization_events_repo.dart';
import '../../../events/presentation/controllers/organization_events_cubit.dart';
import '../../../events/presentation/screens/organization_event_form_screen.dart';
import '../../../events/presentation/screens/organization_events_screen.dart';
import '../../data/enums/organization_home_navbar_enum.dart';
import '../../data/models/organization_home_model.dart';
import '../../data/repos/organization_home_repo.dart';
import '../screens/organization_home_screen.dart';

part 'organization_home_state.dart';

class OrganizationHomeCubit extends Cubit<OrganizationHomeState> {
  OrganizationHomeCubit(this.repo) : super(HomeInitial()) {
    eventsCubit = OrganizationEventsCubit(
      OrganizationEventsRepoImpel(),
      homeCubit: this,
    );

    _screens = {
      OrganizationHomeNavbarItem.home: const OrganizationHomeScreen(),
      OrganizationHomeNavbarItem.events: BlocProvider.value(
        value: eventsCubit,
        child: const OrganizationEventsScreen(),
      ),
      OrganizationHomeNavbarItem.dashboard: const ComingSoonScreen(),
      OrganizationHomeNavbarItem.donations: const DonationsScreen(),
      OrganizationHomeNavbarItem.cases: const CasesScreen(),
    };
  }

  final OrganizationHomeRepo repo;

  static OrganizationHomeCubit get(BuildContext context) =>
      BlocProvider.of(context);

  late final OrganizationEventsCubit eventsCubit;

  final _homeBox = HiveBoxes.organizationHomeBox;

  OrganizationHomeModel? home;

  late final Map<OrganizationHomeNavbarItem, Widget> _screens;

  OrganizationHomeNavbarItem selectedItem = OrganizationHomeNavbarItem.home;

  Widget get currentScreen => _screens[selectedItem]!;

  // ===================== Get Home =====================

  Future<void> getOrganizationHome() async {
    final cachedHome = _homeBox.get('home');

    if (cachedHome != null) {
      home = cachedHome;
      emit(Success());
    } else {
      emit(Loading());
    }

    final result = await repo.getOrganizationHome();

    result.fold(
          (failure) {
        if (home == null) {
          emit(Error());
        }

        AppToast.error(failure.errMessage);
      },
          (data) async {
        home = data;

        await _saveHome();

        emit(Success());
      },
    );
  }

  // ===================== Save Home =====================

  Future<void> _saveHome() async {
    if (home != null) {
      await _homeBox.put('home', home!);
    }
  }

  // ===================== Insert Event (Optimistic Create) =====================

  Future<void> insertHomeEvent(OrganizationEventDetailsModel event) async {
    if (home == null) return;

    home = home!.copyWith(
      activeEventsCount: home!.activeEventsCount + 1,
      activeEvents: [event, ...home!.activeEvents],
    );

    await _saveHome();

    emit(HomeUpdated());
  }

  // ===================== Replace Event (After API Confirms Creation) =====================

  Future<void> replaceHomeEvent(
      int oldId,
      OrganizationEventDetailsModel newEvent,
      ) async {
    if (home == null) return;

    final activeEvents = home!.activeEvents.map((e) {
      return e.id == oldId ? newEvent : e;
    }).toList();

    home = home!.copyWith(activeEvents: activeEvents);

    await _saveHome();

    emit(HomeUpdated());
  }

  // ===================== Remove Event (Rollback On Failure) =====================

  Future<void> removeHomeEvent(int id) async {
    if (home == null) return;

    final wasPresent = home!.activeEvents.any((e) => e.id == id);

    if (!wasPresent) return;

    home = home!.copyWith(
      activeEventsCount: (home!.activeEventsCount - 1).clamp(0, 999999),
      activeEvents: home!.activeEvents.where((e) => e.id != id).toList(),
    );

    await _saveHome();

    emit(HomeUpdated());
  }

  // ===================== Update Event In Home =====================

  Future<void> updateHomeEvent(
      OrganizationEventDetailsModel updatedEvent,
      ) async {
    if (home == null) return;

    bool updated = false;

    final activeEvents = home!.activeEvents.map((event) {
      if (event.id == updatedEvent.id) {
        updated = true;
        return updatedEvent;
      }
      return event;
    }).toList();

    final recentCompletedEvents = home!.recentCompletedEvents.map((event) {
      if (event.id == updatedEvent.id) {
        updated = true;
        return updatedEvent;
      }
      return event;
    }).toList();

    if (!updated) {
      return;
    }

    home = home!.copyWith(
      activeEvents: activeEvents,
      recentCompletedEvents: recentCompletedEvents,
    );

    await _saveHome();

    emit(HomeUpdated());
  }

  // ===================== Delete Event =====================

  Future<bool> deleteOrganizationEvent({required int id}) async {
    final result = await repo.deleteOrganizationEvent(id);

    return result.fold(
          (failure) {
        emit(Error());

        AppToast.error(failure.errMessage);

        return false;
      },
          (_) async {
        if (home != null) {
          home = home!.copyWith(
            activeEventsCount: (home!.activeEventsCount - 1).clamp(0, 999999),

            activeEvents: home!.activeEvents
                .where((event) => event.id != id)
                .toList(),
          );

          await _saveHome();
        }

        await HiveBoxes.organizationEventsBox.delete(id);

        emit(Success());

        AppToast.success('organization.events.event_deleted_successfully'.tr());

        return true;
      },
    );
  }

  // ===================== Publish Event =====================

  Future<void> publishOrganizationEvent({
    required int id,
    required DateTime date,
  }) async {
    final result = await repo.updateOrganizationEvent(
      OrganizationEventUpdateParam(id: id, date: date, status: 'upcoming'),
    );

    result.fold(
          (failure) {
        AppToast.error(failure.errMessage);
      },
          (_) async {
        final event = home?.activeEvents.where((e) => e.id == id).firstOrNull;

        if (event != null) {
          await updateHomeEvent(event.copyWith(date: date, status: 'upcoming'));
        }

        AppToast.success(
          'organization.events.event_published_successfully'.tr(),
        );
      },
    );
  }

  // ===================== Bottom Navigation =====================

  void updateSelectedNavbarItem(OrganizationHomeNavbarItem item) {
    selectedItem = item;

    emit(BottomNavChange());
  }

  // ===================== Open Form =====================

  void openEventForm(OrganizationEventDetailsModel? event) {
    if (event == null) {
      eventsCubit.resetForm();
    }

    AppNavigator.push(
      BlocProvider.value(
        value: eventsCubit,
        child: OrganizationEventFormScreen(event: event),
      ),
    );
  }

  @override
  Future<void> close() {
    eventsCubit.close();

    return super.close();
  }
}

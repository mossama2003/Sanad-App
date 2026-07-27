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
    eventsCubit = OrganizationEventsCubit(OrganizationEventsRepoImpel());

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

  OrganizationHomeNavbarItem selectedItem = OrganizationHomeNavbarItem.home;

  Widget get currentScreen => _screens[selectedItem]!;

  final _homeBox = HiveBoxes.organizationHomeBox;

  OrganizationHomeModel? home;

  late final Map<OrganizationHomeNavbarItem, Widget> _screens;

  // ============= get Organization Event =================
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

        await _homeBox.put('home', data);

        emit(Success());
      },
    );
  }

  // ============= Delete Organization Event =================
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
          home = OrganizationHomeModel(
            activeEventsCount: home!.activeEventsCount - 1,
            completedEventsCount: home!.completedEventsCount,
            attendanceCount: home!.attendanceCount,
            organizationName: home!.organizationName,

            activeEvents: home!.activeEvents
                .where((event) => event.id != id)
                .toList(),

            recentCompletedEvents: home!.recentCompletedEvents,
          );

          await _homeBox.put('home', home!);
        }

        final box = HiveBoxes.organizationEventsBox;

        if (box.isNotEmpty) {
          await box.delete(id);
        }

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
      OrganizationEventUpdateParam(id: id, date: date, status: "upcoming"),
    );

    result.fold(
          (failure) {
        AppToast.error(failure.errMessage);
      },

          (_) async {
        // Update home cache
        if (home != null) {
          home = home!.copyWith(
            activeEvents: home!.activeEvents.map((event) {
              if (event.id == id) {
                return event.copyWith(date: date, status: "upcoming");
              }

              return event;
            }).toList(),
          );

          await _homeBox.put('home', home!);
        }

        emit(Success());

        AppToast.success(
          'organization.events.event_published_successfully'.tr(),
        );
      },
    );
  }

  void updateSelectedNavbarItem(OrganizationHomeNavbarItem item) {
    selectedItem = item;
    emit(BottomNavChange());
  }

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

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_navigator.dart';
import '../../../../coming_soon_screen.dart';
import '../../../../shared/donations/presentation/screens/donations_screen.dart';
import '../../../../shared/cases/presentation/screens/cases_screen.dart';
import '../../../events/data/models/organization_event_details_model.dart';
import '../../../events/data/repos/organization_events_repo.dart';
import '../../../events/presentation/controllers/organization_events_cubit.dart';
import '../../../events/presentation/screens/organization_event_form_screen.dart';
import '../../../events/presentation/screens/organization_events_screen.dart';
import '../../data/enums/organization_home_navbar_enum.dart';
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

  late final Map<OrganizationHomeNavbarItem, Widget> _screens;

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

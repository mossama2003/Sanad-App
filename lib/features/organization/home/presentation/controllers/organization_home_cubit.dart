import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../coming_soon_screen.dart';
import '../../../../shared/donations/presentation/screens/donations_screen.dart';
import '../../../../shared/cases/presentation/screens/cases_screen.dart';
import '../../../events/presentation/screens/organization_events_screen.dart';
import '../../data/enums/organization_home_navbar_enum.dart';
import '../../data/repos/organization_home_repo.dart';
import '../screens/organization_home_screen.dart';

part 'organization_home_state.dart';

class OrganizationHomeCubit extends Cubit<OrganizationHomeState> {
  OrganizationHomeCubit(this.repo) : super(HomeInitial());

  final OrganizationHomeRepo repo;

  static OrganizationHomeCubit get(BuildContext context) =>
      BlocProvider.of(context);

  // HomeModel? homeDetails;
  // UserModel? user;

  OrganizationHomeNavbarItem selectedItem = OrganizationHomeNavbarItem.home;

  Widget get currentScreen => _screens[selectedItem]!;

  final Map<OrganizationHomeNavbarItem, Widget> _screens = {
    OrganizationHomeNavbarItem.home: const OrganizationHomeScreen(),
    OrganizationHomeNavbarItem.events: const OrganizationEventsScreen(),
    OrganizationHomeNavbarItem.dashboard: const ComingSoonScreen(),
    OrganizationHomeNavbarItem.donations: const DonationsScreen(),
    OrganizationHomeNavbarItem.cases: const CasesScreen(),
  };

  void updateSelectedNavbarItem(OrganizationHomeNavbarItem item) {
    selectedItem = item;
    emit(BottomNavChange());
  }
}

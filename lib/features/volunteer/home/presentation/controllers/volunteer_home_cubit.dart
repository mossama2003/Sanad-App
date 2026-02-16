import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../shared/donations/presentation/screens/donations_screen.dart';
import '../../../../shared/cases/presentation/screens/cases_screen.dart';
import '../../../community/presentation/screens/community_screen.dart';
import '../../../events/presentation/screens/events_screen.dart';
import '../../data/enums/volunteer_home_navbar_enum.dart';
import '../../data/repos/volunteer_home_repo.dart';
import '../screens/volunteer_home_screen.dart';

part 'volunteer_home_state.dart';

class VolunteerHomeCubit extends Cubit<VolunteerHomeState> {
  VolunteerHomeCubit(this.repo) : super(HomeInitial());

  final VolunteerHomeRepo repo;

  static VolunteerHomeCubit get(BuildContext context) => BlocProvider.of(context);

  // HomeModel? homeDetails;
  // UserModel? user;

  VolunteerHomeNavbarItem selectedItem = VolunteerHomeNavbarItem.home;

  Widget get currentScreen => _screens[selectedItem]!;

  final Map<VolunteerHomeNavbarItem, Widget> _screens = {
    VolunteerHomeNavbarItem.home: const VolunteerHomeScreen(),
    VolunteerHomeNavbarItem.events: const EventsScreen(),
    VolunteerHomeNavbarItem.community: const CommunityScreen(),
    VolunteerHomeNavbarItem.donations: const DonationsScreen(),
    VolunteerHomeNavbarItem.cases: const CasesScreen(),
  };

  void updateSelectedNavbarItem(VolunteerHomeNavbarItem item) {
    selectedItem = item;
    emit(BottomNavChange());
  }
}

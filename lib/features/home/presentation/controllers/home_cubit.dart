import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/features/events/presentation/screens/events_screen.dart';

import '../../../coming_soon_screen.dart';
import '../../../community/presentation/screens/community_screen.dart';
import '../../../donations/presentation/screens/donations_screen.dart';
import '../../data/enums/home_navbar_enum.dart';
import '../../data/repos/home_repo.dart';
import '../screens/home_screen.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this.repo) : super(HomeInitial());

  final HomeRepo repo;

  static HomeCubit get(BuildContext context) => BlocProvider.of(context);

  // HomeModel? homeDetails;
  // UserModel? user;

  HomeNavbarItem selectedItem = HomeNavbarItem.home;

  Widget get currentScreen => _screens[selectedItem]!;

  final Map<HomeNavbarItem, Widget> _screens = {
    HomeNavbarItem.home: const HomeScreen(),
    HomeNavbarItem.events: const EventsScreen(),
    HomeNavbarItem.community: const CommunityScreen(),
    HomeNavbarItem.donations: const DonationsScreen(),
    HomeNavbarItem.cases: const ComingSoonScreen(),
  };

  void updateSelectedNavbarItem(HomeNavbarItem item) {
    selectedItem = item;
    emit(BottomNavChange());
  }
}

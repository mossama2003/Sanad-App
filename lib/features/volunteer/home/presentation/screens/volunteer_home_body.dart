import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controllers/volunteer_home_cubit.dart';

import '../widgets/volunteer_home_appbar_widget.dart';
import '../widgets/volunteer_home_navbar_widget.dart';

class VolunteerHomeBody extends StatelessWidget {
  const VolunteerHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VolunteerHomeCubit, VolunteerHomeState>(
      builder: (context, state) {
        final cubit = VolunteerHomeCubit.get(context);

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                /// Fixed AppBar
                const VolunteerHomeAppbarWidget(),

                /// Screen Content
                Expanded(child: cubit.currentScreen),
              ],
            ),
          ),
          bottomNavigationBar: VolunteerHomeNavbarWidget(
            selected: cubit.selectedItem,
            onTap: cubit.updateSelectedNavbarItem,
          ),
        );
      },
    );
  }
}

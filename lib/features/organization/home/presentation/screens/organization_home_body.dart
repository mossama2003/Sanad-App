import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/cases/presentation/screens/submit_case_screen.dart';
import '../../../events/presentation/screens/organization_event_form_screen.dart';
import '../../data/enums/organization_home_navbar_enum.dart';
import '../controllers/organization_home_cubit.dart';

import '../widgets/organization_home_appbar_widget.dart';
import '../widgets/organization_home_navbar_widget.dart';

class OrganizationHomeBody extends StatelessWidget {
  const OrganizationHomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationHomeCubit, OrganizationHomeState>(
      builder: (context, state) {
        final cubit = OrganizationHomeCubit.get(context);

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                /// Fixed AppBar
                const OrganizationHomeAppbarWidget(),

                /// Screen Content
                Expanded(child: cubit.currentScreen),
              ],
            ),
          ),

          floatingActionButton:
              cubit.selectedItem == OrganizationHomeNavbarItem.events
              ? FloatingActionButton(
                  heroTag: 'organization_events_fab',
                  onPressed: () => cubit.openEventForm(null),
                  backgroundColor: AppColors.primary,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomIcon(
                    icon: AppIcons.add,
                    color: AppColors.white,
                    width: AppSize.getSize(28),
                    height: AppSize.getSize(28),
                  ),
                )
              : cubit.selectedItem == OrganizationHomeNavbarItem.cases
              ? FloatingActionButton(
                  heroTag: 'organization_cases_fab',
                  onPressed: () {
                    AppNavigator.push(SubmitCaseScreen());
                  },
                  backgroundColor: AppColors.laserBlue,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomIcon(
                    icon: AppIcons.add,
                    color: AppColors.white,
                    width: AppSize.getSize(28),
                    height: AppSize.getSize(28),
                  ),
                )
              : null,

          bottomNavigationBar: OrganizationHomeNavbarWidget(
            selected: cubit.selectedItem,
            onTap: cubit.updateSelectedNavbarItem,
          ),
        );
      },
    );
  }
}

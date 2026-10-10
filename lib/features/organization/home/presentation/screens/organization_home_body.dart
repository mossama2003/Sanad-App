import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/cases/data/repos/cases_repo.dart';
import '../../../../shared/cases/presentation/controllers/case_cubit.dart';
import '../../../../shared/cases/presentation/screens/cases_screen.dart';
import '../../../../shared/cases/presentation/screens/submit_case_screen.dart';
import '../../data/enums/organization_home_navbar_enum.dart';
import '../controllers/organization_home_cubit.dart';

import '../widgets/organization_home_appbar_widget.dart';
import '../widgets/organization_home_navbar_widget.dart';

class OrganizationHomeBody extends StatefulWidget {
  const OrganizationHomeBody({super.key});

  @override
  State<OrganizationHomeBody> createState() => _OrganizationHomeBodyState();
}

class _OrganizationHomeBodyState extends State<OrganizationHomeBody> {
  late final CasesCubit casesCubit;

  @override
  void initState() {
    super.initState();

    casesCubit = CasesCubit(CasesRepoImpel());

    final user = AppCubit.get(context).user;

    final isOrg = user?.role == 'organization';

    debugPrint(
      'HOME BODY INIT => '
      'casesCubit=${identityHashCode(casesCubit)}',
    );

    casesCubit.initCasesScreen(isOrg: isOrg, currentUserId: user?.id);
  }

  @override
  void dispose() {
    debugPrint(
      'HOME BODY DISPOSE => '
      'casesCubit=${identityHashCode(casesCubit)}',
    );

    casesCubit.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrganizationHomeCubit, OrganizationHomeState>(
      builder: (context, state) {
        final cubit = OrganizationHomeCubit.get(context);

        final isCases = cubit.selectedItem == OrganizationHomeNavbarItem.cases;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const OrganizationHomeAppbarWidget(),

                Expanded(
                  child: isCases
                      ? BlocProvider.value(
                          value: casesCubit,
                          child: CasesScreen(
                            casesCubit: casesCubit,
                            isOrg: true,
                          ),
                        )
                      : cubit.currentScreen,
                ),
              ],
            ),
          ),

          // ======================================================
          // Floating Action Button
          // ======================================================
          floatingActionButton:
              cubit.selectedItem == OrganizationHomeNavbarItem.events
              ? FloatingActionButton(
                  heroTag: 'organization_events_fab',

                  onPressed: () {
                    cubit.openEventForm(null);
                  },

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
                    debugPrint(
                      'CASES FAB => '
                      'cubit=${identityHashCode(casesCubit)}',
                    );

                    AppNavigator.push(
                      BlocProvider.value(
                        value: casesCubit,
                        child: SubmitCaseScreen(casesCubit: casesCubit),
                      ),
                    );
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

          // ======================================================
          // Bottom Navigation
          // ======================================================
          bottomNavigationBar: OrganizationHomeNavbarWidget(
            selected: cubit.selectedItem,
            onTap: cubit.updateSelectedNavbarItem,
          ),
        );
      },
    );
  }
}

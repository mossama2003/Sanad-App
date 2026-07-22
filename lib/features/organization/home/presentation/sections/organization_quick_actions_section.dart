import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/features/organization/events/presentation/screens/organization_event_form_screen.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../events/data/repos/organization_events_repo.dart';
import '../../../events/presentation/controllers/organization_events_cubit.dart';

class OrganizationQuickActionsSection extends StatelessWidget {
  const OrganizationQuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'organization.home.quick_actions.title'.tr(),

          style: TextStyle(
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: AppSize.getHeight(12)),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,

                onTap: () {
                  AppNavigator.push(
                    BlocProvider(
                      create: (_) => OrganizationEventsCubit(
                        OrganizationEventsRepoImpel(),
                      ),

                      child: const OrganizationEventFormScreen(),
                    ),
                  );
                },

                icon: AppIcons.events,

                iconColor: AppColors.white,

                bgColor: AppColors.primary,

                label: 'organization.home.quick_actions.create_event'.tr(),
              ),
            ),

            SizedBox(width: AppSize.getWidth(12)),

            Expanded(
              child: _buildActionCard(
                context,

                onTap: () {},

                icon: AppIcons.donations,

                iconColor: AppColors.white,

                bgColor: AppColors.brand600,

                label: 'organization.home.quick_actions.donation_campaign'.tr(),
              ),
            ),
          ],
        ),

        SizedBox(height: AppSize.getHeight(12)),

        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,

                onTap: () {},

                icon: AppIcons.file,

                iconColor: AppColors.white,

                bgColor: AppColors.gold,

                label: 'organization.home.quick_actions.create_case'.tr(),
              ),
            ),

            SizedBox(width: AppSize.getWidth(12)),

            Expanded(
              child: _buildActionCard(
                context,

                onTap: () {},

                icon: AppIcons.cases,

                iconColor: AppColors.white,

                bgColor: AppColors.red,

                label: 'organization.home.quick_actions.emergencies'.tr(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String icon,
    required Color iconColor,
    required Color bgColor,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: AppSize.getHeight(110),

        padding: AppSize.padding(vertical: 16),

        decoration: BoxDecoration(
          color: theme.cardColor,

          borderRadius: BorderRadius.circular(30),

          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(
              alpha: isDark ? .12 : .10,
            ),
          ),

          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 2),

              color: Colors.black.withValues(alpha: isDark ? .35 : .15),

              blurRadius: 8,
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              width: AppSize.getWidth(44),

              height: AppSize.getHeight(44),

              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),

              child: Center(
                child: CustomIcon(
                  icon: icon,

                  color: iconColor,

                  width: AppSize.getSize(22),

                  height: AppSize.getSize(22),
                ),
              ),
            ),

            SizedBox(height: AppSize.getHeight(10)),

            Text(
              label,

              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: AppSize.font(13),

                fontWeight: FontWeight.w500,

                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

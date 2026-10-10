import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../shared/notification/presentation/screens/notification_screen.dart';
import '../../../profile/presentation/screens/volunteer_profile_screen.dart';

class VolunteerHomeAppbarWidget extends StatelessWidget {
  const VolunteerHomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appCubit = AppCubit.get(context);

    final volunteerName = appCubit.user?.name?.trim() ?? '';

    final firstLetter = volunteerName.isNotEmpty
        ? volunteerName[0].toUpperCase()
        : 'V';

    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,

      padding: AppSize.padding(horizontal: 15),

      height: AppSize.getHeight(60),

      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,

        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1.5),

            color: Colors.black.withValues(alpha: isDark ? .4 : .12),

            blurRadius: 3,
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          Container(
            width: AppSize.getSize(35),

            height: AppSize.getSize(35),

            decoration: BoxDecoration(
              color: AppColors.primary,

              shape: BoxShape.circle,
            ),

            child: Center(
              child: CustomIcon(
                onTap: () => AppNavigator.push(NotificationsScreen()),

                icon: AppIcons.profile,

                width: AppSize.getSize(25),

                height: AppSize.getSize(25),

                color: AppColors.white,
              ),
            ),
          ),

          SizedBox(width: AppSize.getWidth(10)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Text(
                  volunteerName,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: TextStyle(
                    fontSize: AppSize.font(20),

                    fontWeight: FontWeight.w700,

                    color: theme.colorScheme.onSurface,

                    letterSpacing: -0.3,
                  ),
                ),

                Text(
                  'volunteer.volunteer'.tr(),

                  style: TextStyle(
                    fontSize: AppSize.font(12),

                    fontWeight: FontWeight.w300,

                    color: theme.colorScheme.onSurface.withValues(alpha: .6),

                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),

          CustomIcon(
            onTap: () => AppNavigator.push(NotificationsScreen()),

            icon: AppIcons.notification,

            width: AppSize.getSize(25),

            height: AppSize.getSize(25),

            color: theme.colorScheme.onSurface,
          ),

          SizedBox(width: AppSize.getWidth(10)),

          GestureDetector(
            onTap: () => AppNavigator.push(const VolunteerProfileScreen()),

            child: Container(
              width: AppSize.getSize(35),

              height: AppSize.getSize(35),

              decoration: BoxDecoration(
                color: AppColors.primary,

                shape: BoxShape.circle,

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .5 : .15),

                    blurRadius: 3,
                  ),
                ],
              ),

              child: Center(
                child: Text(
                  firstLetter,

                  style: TextStyle(
                    fontSize: AppSize.font(20),

                    fontWeight: FontWeight.w500,

                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

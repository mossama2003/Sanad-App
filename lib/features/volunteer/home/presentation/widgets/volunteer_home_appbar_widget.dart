import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/style/app_colors.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../shared/notification/presentation/screens/notification_screen.dart';
import '../../../profile/presentation/screens/volunteer_profile_screen.dart';

class VolunteerHomeAppbarWidget extends StatelessWidget {
  const VolunteerHomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: AppSize.padding(horizontal: 15),
      width: double.infinity,
      height: AppSize.getHeight(60),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1.5),
            color: isDark
                ? Colors.black.withValues(alpha: .35)
                : AppColors.grey.withValues(alpha: .25),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Sanad',
            style: TextStyle(
              fontSize: AppSize.font(22),
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: -.3,
            ),
          ),

          const Spacer(),

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
                    color: isDark
                        ? Colors.black.withValues(alpha: .35)
                        : AppColors.grey.withValues(alpha: .25),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'A',
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

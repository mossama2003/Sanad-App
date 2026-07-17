import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/style/app_colors.dart';
import '../../../../shared/notification/presentation/screens/notification_screen.dart';

class OrganizationHomeAppbarWidget extends StatelessWidget {
  const OrganizationHomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
            color: isDark
                ? Colors.black.withValues(alpha: 0.4)
                : AppColors.grey.withValues(alpha: 0.35),
            blurRadius: 3,
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
              letterSpacing: -0.3,
            ),
          ),

          const Spacer(),

          CustomIcon(
            onTap: () => AppNavigator.push(NotificationsScreen()),
            icon: AppIcons.notification,
            width: AppSize.getSize(25),
            height: AppSize.getSize(25),
            color: isDark ? AppColors.white : AppColors.black,
          ),

          SizedBox(width: AppSize.getWidth(10)),

          GestureDetector(
            child: Container(
              width: AppSize.getSize(35),
              height: AppSize.getSize(35),
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? Colors.black.withValues(alpha: 0.5)
                        : AppColors.grey.withValues(alpha: 0.35),
                    blurRadius: 3,
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

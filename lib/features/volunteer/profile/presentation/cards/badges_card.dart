import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';
import '../../../../shared/badges/presentation/screens/badges_screen.dart';

class BadgesCard extends StatelessWidget {
  final List<VolunteerBadgeModel> badges;

  const BadgesCard({
    super.key,
    required this.badges,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: textColor.withValues(alpha: .15),
          width: .7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? .3 : .05,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppSize.padding(all: 15),
      child: Column(
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.badge,
                color: AppColors.secondary400,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
              SizedBox(width: AppSize.getWidth(5)),
              Text(
                'volunteer.profile.badges'.tr(),
                style: TextStyle(
                  color: textColor,
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  AppNavigator.push(
                    const BadgesScreen(),
                  );
                },
                style: TextButton.styleFrom(
                  tapTargetSize:
                  MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'volunteer.profile.view_all'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: theme.colorScheme.onSurface
                        .withValues(alpha: .5),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(16)),

          if (badges.isEmpty)
            Padding(
              padding: AppSize.padding(vertical: 10),
              child: Text(
                'volunteer.profile.no_badges'.tr(),
                style: TextStyle(
                  color: textColor.withValues(alpha: .5),
                  fontSize: AppSize.font(13),
                ),
              ),
            )
          else
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceAround,
              children: badges.take(6).map((badge) {
                return Container(
                  width: AppSize.getWidth(40),
                  height: AppSize.getWidth(40),
                  decoration: BoxDecoration(
                    color:
                    theme.scaffoldBackgroundColor,
                    borderRadius:
                    BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    badge.icon?.isNotEmpty == true
                        ? badge.icon!
                        : '🏅',
                    style: TextStyle(
                      fontSize: AppSize.font(22),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

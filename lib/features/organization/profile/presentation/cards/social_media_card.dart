import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class SocialMediaCard extends StatelessWidget {
  const SocialMediaCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final cardColor = theme.colorScheme.surface;

    final textColor = theme.colorScheme.onSurface;

    return Container(
      width: double.infinity,

      padding: AppSize.padding(all: 16),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: textColor.withValues(alpha: isDark ? .12 : .15),
          width: .7,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .35 : .05),

            blurRadius: 8,

            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            'organization.profile.social_media'.tr(),

            style: TextStyle(
              fontSize: AppSize.font(16),

              fontWeight: FontWeight.w700,

              color: textColor,
            ),
          ),

          SizedBox(height: AppSize.getHeight(14)),

          Row(
            children: [
              _buildSocialIcon(context, Icons.facebook_outlined),

              SizedBox(width: AppSize.getWidth(10)),

              _buildSocialIcon(context, Icons.snapchat),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(BuildContext context, IconData icon) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: AppSize.getWidth(40),

      height: AppSize.getHeight(40),

      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: isDark ? .18 : .12),

        shape: BoxShape.circle,
      ),

      child: Icon(icon, color: AppColors.primary, size: AppSize.font(18)),
    );
  }
}

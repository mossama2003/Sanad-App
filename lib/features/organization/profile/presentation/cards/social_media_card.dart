import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class SocialMediaCard extends StatelessWidget {
  final Map<String, dynamic> socialMediaLinks;

  const SocialMediaCard({super.key, required this.socialMediaLinks});

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

          Wrap(
            spacing: AppSize.getWidth(10),
            runSpacing: AppSize.getHeight(10),
            children: socialMediaLinks.entries.map((entry) {
              final url = entry.value?.toString();

              if (url == null || url.isEmpty) {
                return const SizedBox.shrink();
              }

              return _buildSocialIcon(context, platform: entry.key, url: url);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(
    BuildContext context, {
    required String platform,
    required String url,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () async {
        final uri = Uri.tryParse(url);

        if (uri == null) return;

        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      },
      child: Container(
        width: AppSize.getWidth(30),
        height: AppSize.getHeight(30),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: isDark ? .18 : .12),
          shape: BoxShape.circle,
        ),
        child: CustomIcon(
          icon: _getSocialIcon(platform),
          color: AppColors.primary,
          width: AppSize.font(18),
          height: AppSize.font(18),
        ),
      ),
    );
  }

  String _getSocialIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'facebook':
        return AppIcons.facebook;

      case 'instagram':
        return AppIcons.instagram;

      case 'linkedin':
        return AppIcons.linkedin;

      case 'twitter':
      case 'x':
        return AppIcons.twitter;

      case 'snapchat':
        return AppIcons.snapchat;

      case 'website':
        return AppIcons.website;

      default:
        return AppIcons.website;
    }
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../style/app_colors.dart';

import 'package:url_launcher/url_launcher.dart';

class ContactInfoCard extends StatelessWidget {
  final String email;
  final String phone;

  final String? website;
  final String? location;

  const ContactInfoCard({
    super.key,
    required this.email,
    required this.phone,
    this.website,
    this.location,
  });

  bool get isOrganization => website != null || location != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = theme.colorScheme.surface;

    final textColor = theme.colorScheme.onSurface;

    final secondaryTextColor = isDark ? AppColors.grey400 : AppColors.grey600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: textColor.withValues(alpha: .15), width: .7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppSize.padding(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'volunteer.profile.contact_information'.tr(),
            style: TextStyle(
              color: textColor,
              fontSize: AppSize.font(16),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSize.getHeight(14)),

          if (email.trim().isNotEmpty)
            _ContactRow(
              icon: AppIcons.email,
              text: email,
              color: secondaryTextColor,
            ),

          if (email.trim().isNotEmpty && phone.trim().isNotEmpty)
            SizedBox(height: AppSize.getHeight(10)),

          if (phone.trim().isNotEmpty)
            _ContactRow(
              icon: AppIcons.phone,
              text: phone,
              color: secondaryTextColor,
            ),

          if (isOrganization) ...[
            if (location != null && location!.trim().isNotEmpty) ...[
              SizedBox(height: AppSize.getHeight(10)),
              _ContactRow(
                icon: AppIcons.location,
                text: location!,
                color: secondaryTextColor,
              ),
            ],

            if (website != null && website!.trim().isNotEmpty) ...[
              SizedBox(height: AppSize.getHeight(10)),
              _ContactRow(
                icon: AppIcons.website,
                text: website!,
                color: secondaryTextColor,
                onTap: () => _openWebsite(context, website!),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Future<void> _openWebsite(BuildContext context, String website) async {
    var value = website.trim();

    if (value.isEmpty) return;

    if (!value.startsWith('http://') && !value.startsWith('https://')) {
      value = 'https://$value';
    }

    final uri = Uri.tryParse(value);

    if (uri == null) return;

    try {
      final canOpen = await canLaunchUrl(uri);

      if (canOpen) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        return;
      }
    } catch (_) {}

    if (!context.mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Could not open website')));
  }
}

class _ContactRow extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;
  final VoidCallback? onTap;

  const _ContactRow({
    required this.icon,
    required this.text,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomIcon(
          icon: icon,
          color: AppColors.primary,
          width: AppSize.getWidth(18),
          height: AppSize.getHeight(18),
        ),

        SizedBox(width: AppSize.getWidth(10)),

        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: AppSize.font(13),
              color: color,
              decoration: onTap != null
                  ? TextDecoration.underline
                  : TextDecoration.none,
              decorationColor: onTap != null ? color : null,
            ),
          ),
        ),
      ],
    );

    if (onTap == null) {
      return row;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: AppSize.padding(vertical: AppSize.getHeight(2)),
        child: row,
      ),
    );
  }
}

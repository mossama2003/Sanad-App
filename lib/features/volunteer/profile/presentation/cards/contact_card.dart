import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/style/app_colors.dart';

class ContactCard extends StatelessWidget {
  final String email;
  final String phone;

  const ContactCard({super.key, required this.email, required this.phone});

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
          _ContactRow(
            icon: AppIcons.email,
            text: email,
            color: secondaryTextColor,
          ),
          SizedBox(height: AppSize.getHeight(10)),
          _ContactRow(
            icon: AppIcons.phone,
            text: phone,
            color: secondaryTextColor,
          ),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String icon;
  final String text;
  final Color color;

  const _ContactRow({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIcon(
          icon: icon,
          color: color,
          width: AppSize.getWidth(18),
          height: AppSize.getHeight(18),
        ),
        SizedBox(width: AppSize.getHeight(10)),
        Text(
          text,
          style: TextStyle(fontSize: AppSize.font(13), color: color),
        ),
      ],
    );
  }
}

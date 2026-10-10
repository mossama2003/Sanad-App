import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';

class VerifiedInfoCard extends StatelessWidget {
  const VerifiedInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .7);

    final backgroundColor = isDark
        ? const Color(0xFF102A3A)
        : const Color(0xFFE8F6FF);

    final accentColor = const Color(0xFF4A90D9);

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: accentColor.withValues(alpha: isDark ? .35 : .25),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIcon(
            icon: AppIcons.check,
            color: accentColor,
            width: AppSize.getSize(22),
            height: AppSize.getSize(22),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.cases.cases_verification_title'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(14),
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(2)),
                Text(
                  'shared.cases.cases_verification_description'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(12),
                    fontWeight: FontWeight.w300,
                    color: secondaryColor,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

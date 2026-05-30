import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class VerifiedInfoCard extends StatelessWidget {
  const VerifiedInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6FF),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF4A90D9).withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIcon(
            icon: AppIcons.check,
            color: const Color(0xFF4A90D9),
            width: AppSize.getSize(22),
            height: AppSize.getSize(22),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.cases.all_cases_are_verified'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(14),
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(2)),
                Text(
                  'shared.cases.our_team_verifies_every_case'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(12),
                    fontWeight: FontWeight.w300,
                    color: AppColors.black,
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

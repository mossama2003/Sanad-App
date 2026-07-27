import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../cards/cases_card.dart';
import '../cards/verified_info_card.dart';

class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppSize.padding(horizontal: 12, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.cases.title'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(22),
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(3)),

                Text(
                  'shared.cases.desc'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w300,
                    color: AppColors.black.withValues(alpha: 0.7),
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),
                VerifiedInfoCard(),
                SizedBox(height: AppSize.getHeight(15)),

                CasesCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

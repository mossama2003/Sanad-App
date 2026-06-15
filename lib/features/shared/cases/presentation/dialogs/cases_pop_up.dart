import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_size.dart';

import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/style/app_colors.dart';

class CasesPopUp extends StatelessWidget {
  const CasesPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFF5F5F7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: AppSize.padding(all: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'shared.cases_removed.family_displaced_by_fire'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(20),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: AppSize.getHeight(10)),
            Container(
              width: double.infinity,
              padding: AppSize.padding(all: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.grey50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'shared.cases.pop_up.contact_person'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(5)),
                  Text(
                    'shared.cases_removed.mohamed'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(14),
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(10)),
                  Text(
                    'shared.cases.pop_up.phone'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(5)),
                  Text(
                    '+20 123 456 7890',
                    style: TextStyle(
                      fontSize: AppSize.font(15),
                      color: AppColors.laserBlue,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(10)),
                  Text(
                    'shared.cases.pop_up.bank_account'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      color: AppColors.grey700,
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(5)),
                  Text(
                    'shared.cases_removed.national_bank'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(14),
                      color: AppColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSize.getHeight(15)),
            Container(
              width: double.infinity,
              padding: AppSize.padding(all: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: AppColors.laserBlue.withValues(alpha: 0.4),
                ),
                color: AppColors.laserBlue.withValues(alpha: 0.1),
              ),
              child: Center(
                child: Text(
                  'shared.cases.pop_up.you_can_support'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: AppColors.laserBlue,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.getHeight(13)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => AppNavigator.pop(),
                    title: 'shared.cases.pop_up.close'.tr(),
                    textColor: AppColors.black,
                    textSize: AppSize.font(15),
                    height: AppSize.getHeight(45),
                    bgColor: AppColors.grey200,
                  ),
                ),
                SizedBox(width: AppSize.getWidth(10)),
                Expanded(
                  child: CustomButton(
                    title: 'shared.cases.pop_up.call_now'.tr(),
                    textColor: AppColors.white,
                    textSize: AppSize.font(15),
                    height: AppSize.getHeight(45),
                    bgColor: AppColors.laserBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

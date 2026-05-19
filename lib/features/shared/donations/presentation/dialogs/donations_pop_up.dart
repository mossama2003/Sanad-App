import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';

import '../../../../../core/style/app_colors.dart';

class DonationsPopUp extends StatelessWidget {
  const DonationsPopUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: AppSize.padding(all: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'shared.donations_removed.winter_clothing_drive'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(20),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: AppSize.getHeight(10)),
            Text(
              'shared.donations_removed.resala_charity'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w400,
                color: AppColors.black.withValues(alpha: 0.4),
              ),
            ),
            SizedBox(height: AppSize.getHeight(10)),
            CustomFieldText(
              controller: TextEditingController(),
              title: 'shared.donations.pop_up.donation_Amount'.tr(),
              hintText: 'shared.donations.pop_up.enter_amount'.tr(),
            ),
            SizedBox(height: AppSize.getHeight(13)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: AppSize.padding(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.grey100,
                  ),
                  child: Center(child: Text('100 EGP')),
                ),
                Container(
                  padding: AppSize.padding(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.grey100,
                  ),
                  child: Center(child: Text('250 EGP')),
                ),
                Container(
                  padding: AppSize.padding(vertical: 10, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.grey100,
                  ),
                  child: Center(child: Text('500 EGP')),
                ),
              ],
            ),
            SizedBox(height: AppSize.getHeight(13)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => AppNavigator.pop(),
                    title: 'shared.donations.pop_up.cancel'.tr(),
                    textColor: AppColors.black,
                    textSize: AppSize.font(15),
                    height: AppSize.getHeight(45),
                    bgColor: AppColors.grey200,
                  ),
                ),
                SizedBox(width: AppSize.getWidth(10)),
                Expanded(
                  child: CustomButton(
                    title: 'shared.donations.pop_up.confirm'.tr(),
                    textColor: AppColors.white,
                    textSize: AppSize.font(15),
                    height: AppSize.getHeight(45),
                    bgColor: AppColors.magenta,
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

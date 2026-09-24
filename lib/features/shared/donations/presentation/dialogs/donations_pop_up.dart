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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final dialogColor = theme.dialogTheme.backgroundColor ??
        theme.colorScheme.surface;
    final secondaryColor = textColor.withValues(alpha: .45);
    final amountColor = textColor.withValues(alpha: isDark ? .08 : .05);

    return Dialog(
      backgroundColor: dialogColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
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
                color: textColor,
              ),
            ),
            SizedBox(height: AppSize.getHeight(10)),
            Text(
              'shared.donations_removed.resala_charity'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w400,
                color: secondaryColor,
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
                  padding: AppSize.padding(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: amountColor,
                  ),
                  child: Text(
                    '100 EGP',
                    style: TextStyle(color: textColor),
                  ),
                ),
                Container(
                  padding: AppSize.padding(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: amountColor,
                  ),
                  child: Text(
                    '250 EGP',
                    style: TextStyle(color: textColor),
                  ),
                ),
                Container(
                  padding: AppSize.padding(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: amountColor,
                  ),
                  child: Text(
                    '500 EGP',
                    style: TextStyle(color: textColor),
                  ),
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
                    textColor: textColor,
                    textSize: AppSize.font(15),
                    height: AppSize.getHeight(45),
                    bgColor: isDark
                        ? textColor.withValues(alpha: .08)
                        : AppColors.grey200,
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

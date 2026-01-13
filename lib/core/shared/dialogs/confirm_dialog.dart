import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../helper/app_navigator.dart';
import '../../style/app_colors.dart';
import '../widgets/custom_button.dart';
import 'custom_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.title, this.onYes, this.onNo});

  final String title;
  final Function()? onYes;
  final Function()? onNo;

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: AppSize.font(20),
            height: AppSize.fontHeight(20, 28),
            fontWeight: FontWeight.w500,
            color: AppColors.grey800,
          ),
        ),
        SizedBox(height: AppSize.getHeight(24)),
        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: 'core.yes'.tr(),
                textColor: AppColors.white,
                bgColor: AppColors.green500,
                height: AppSize.getHeight(40),
                onTap: () {
                  AppNavigator.pop();
                  if (onYes != null) onYes!();
                },
              ),
            ),
            SizedBox(width: AppSize.getWidth(12)),
            Expanded(
              child: CustomButton(
                title: 'core.no'.tr(),
                bgColor: AppColors.red500,
                textColor: AppColors.white,
                height: AppSize.getHeight(40),
                onTap: () {
                  AppNavigator.pop();
                  if (onNo != null) onNo!();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import '../../style/app_text_style.dart';
import '../widgets/custom_button.dart';
import 'custom_dialog.dart';

class AuthRequiredDialog extends StatelessWidget {
  const AuthRequiredDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      children: [
        Text(
          "auth_required.title".tr(),
          style: TextStyle(color: AppColors.grey800).lg,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSize.getHeight(32)),
        Text(
          "auth_required.desc".tr(),
          style: TextStyle(color: AppColors.grey500).sm,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppSize.getHeight(32)),
        CustomButton(
          title: "auth_required.sign_in".tr(),
          // onTap: () => AppNavigator.push(const SignInScreen()),
        ),
      ],
    );
  }
}

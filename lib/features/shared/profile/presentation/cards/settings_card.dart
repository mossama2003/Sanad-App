import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/features/shared/auth/presentation/sign_in/screens/sign_in_screen.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class SettingsCard extends StatelessWidget {
  const SettingsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.2),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppSize.padding(all: 16),
      child: Column(
        children: [
          _SettingsRow(
            icon: AppIcons.settings,
            label: 'shared.profile.settings.edit_profile'.tr(),
            onTap: () {},
          ),
          SizedBox(height: AppSize.getHeight(15)),
          _SettingsRow(
            icon: AppIcons.helpSupport,
            label: 'shared.profile.settings.help_support'.tr(),
            onTap: () {},
          ),
          SizedBox(height: AppSize.getHeight(15)),
          _SettingsRow(
            icon: AppIcons.privacyPolicy,
            label: 'shared.profile.settings.privacy_policy'.tr(),
            onTap: () {},
          ),
          SizedBox(height: AppSize.getHeight(15)),
          Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.grey.withValues(alpha: 0.3),
          ),
          SizedBox(height: AppSize.getHeight(15)),
          _SettingsRow(
            icon: AppIcons.signOut,
            label: 'shared.profile.settings.sign_out'.tr(),
            onTap: () => AppNavigator.remove(SignInScreen()),
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SettingsRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.red : AppColors.black;

    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          CustomIcon(
            icon: icon,
            color: color,
            width: AppSize.getWidth(18),
            height: AppSize.getHeight(18),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
          if (!isDestructive)
            CustomIcon(
              icon: AppIcons.rightArrow,
              color: AppColors.grey,
              width: AppSize.getSize(20),
              height: AppSize.getSize(20),
            ),
        ],
      ),
    );
  }
}

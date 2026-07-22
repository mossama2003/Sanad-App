import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../helper/app_navigator.dart';
import '../../style/app_colors.dart';
import '../widgets/custom_button.dart';
import 'custom_dialog.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;

    final secondaryTextColor = textColor.withValues(alpha: .6);

    final borderColor = textColor.withValues(alpha: .15);

    return CustomDialog(
      children: [
        Text(
          title,

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSize.font(20),
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),

        SizedBox(height: AppSize.getHeight(12)),

        Text(
          message,

          textAlign: TextAlign.center,

          style: TextStyle(
            fontSize: AppSize.font(14),

            height: AppSize.fontHeight(14, 22),

            color: secondaryTextColor,
          ),
        ),

        SizedBox(height: AppSize.getHeight(24)),

        Row(
          children: [
            Expanded(
              child: CustomButton(
                title: cancelText ?? 'core.cancel'.tr(),

                bgColor: Colors.transparent,

                borderColor: borderColor,

                textColor: textColor,

                height: AppSize.getHeight(40),

                onTap: () {
                  AppNavigator.pop();

                  onCancel?.call();
                },
              ),
            ),

            SizedBox(width: AppSize.getWidth(12)),

            Expanded(
              child: CustomButton(
                title: confirmText ?? 'core.yes'.tr(),

                bgColor: isDestructive ? AppColors.red500 : AppColors.green500,

                textColor: Colors.white,

                height: AppSize.getHeight(40),

                onTap: () {
                  AppNavigator.pop();

                  onConfirm?.call();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

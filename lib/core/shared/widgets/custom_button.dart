import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import 'custom_icon.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.icon,
    this.onTap,
    this.width,
    this.height,
    this.bgColor,
    this.textColor,
    this.iconColored,
    this.textDecoration,
    this.textSize,
    this.borderColor,
    required this.title,
    this.loading = false,
    this.enable = true,
  });

  final String title;
  final bool loading;
  final bool enable;
  final String? icon;
  final double? width;
  final double? height;
  final double? textSize;
  final Color? bgColor;
  final Color? textColor;
  final bool? iconColored;
  final Function()? onTap;
  final Color? borderColor;
  final TextDecoration? textDecoration;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading || !enable ? null : onTap,
      borderRadius: BorderRadius.circular(AppSize.getHeight(12)),
      child: Container(
        width: width ?? double.infinity,
        height: height ?? AppSize.getHeight(42),
        padding: AppSize.padding(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSize.getSize(12)),
          color: loading || !enable
              ? AppColors.buttonPrimaryDisabled
              : bgColor ?? AppColors.buttonPrimary,
          border: !enable
              ? Border.all(color: AppColors.grey200)
              : borderColor != null && !loading
              ? Border.all(color: borderColor!)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (loading)
              SizedBox(
                width: AppSize.getSize(26),
                height: AppSize.getSize(26),
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.buttonPrimary,
                ),
              )
            else ...[
              if (icon != null) ...[
                CustomIcon(
                  icon: icon!,
                  width: AppSize.getSize(24),
                  height: AppSize.getSize(24),
                  withColor: iconColored ?? false,
                  color: !enable
                      ? AppColors.grey300
                      : textColor ?? AppColors.white,
                ),
                SizedBox(width: AppSize.getWidth(8)),
              ],
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    decoration: textDecoration,
                    fontWeight: FontWeight.w500,
                    fontSize: AppSize.font(textSize ?? 16),
                    color: !enable
                        ? AppColors.buttonDisabledText
                        : textColor ?? AppColors.white,
                  ),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

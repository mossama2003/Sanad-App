import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({
    super.key,
    this.onTap,
    this.width,
    this.color,
    this.height,
    this.bgColor,
    this.padding,
    this.borderColor,
    this.borderRadius,
    required this.icon,
    this.withColor = false,
  });

  final String icon;
  final Color? color;
  final double? width;
  final bool withColor;
  final Color? bgColor;
  final double? height;
  final double? padding;
  final Function()? onTap;
  final Color? borderColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          shape: borderRadius != null ? BoxShape.rectangle : BoxShape.circle,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        padding: borderColor != null || bgColor != null
            ? EdgeInsets.all(AppSize.getSize(padding ?? 5))
            : null,
        child: SizedBox(
          width: width ?? AppSize.getSize(24),
          height: height ?? AppSize.getSize(24),
          child: SvgPicture.asset(
            icon,
            colorFilter: withColor
                ? null
                : ColorFilter.mode(color ?? AppColors.primary, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}

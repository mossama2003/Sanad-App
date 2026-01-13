import 'package:flutter/material.dart';
import 'package:shuaa_alamal/core/constant/app_assets.dart';
import 'package:shuaa_alamal/core/shared/widgets/custom_icon.dart';
import 'package:shuaa_alamal/core/style/app_colors.dart';

import '../../constant/app_size.dart';

class CustomCurrency extends StatelessWidget {
  const CustomCurrency({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CustomIcon(
      icon: AppSvg.sarSymbol,
      color: color ?? AppColors.grey500,
      width: AppSize.getSize(14),
      height: AppSize.getSize(14),
    );
  }
}

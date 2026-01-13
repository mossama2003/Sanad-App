import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import 'custom_svg.dart';

class CustomError extends StatelessWidget {
  const CustomError({super.key, this.onRefresh});

  final Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSize.padding(all: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomSvg(svg: AppSvg.error, height: AppSize.getHeight(225)),
          SizedBox(height: AppSize.getHeight(30), width: double.infinity),
          Text(
            'core.error_title'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(16),
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSize.getHeight(6)),
          Text(
            'core.error_desc'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSize.font(14),
              fontWeight: FontWeight.w500,
              color: AppColors.grey600,
            ),
          ),
          if (onRefresh != null) ...[
            SizedBox(height: AppSize.getHeight(30)),
            InkWell(
              onTap: onRefresh,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.primary.withValues(alpha: .2),
                ),
                padding: AppSize.padding(vertical: 8, horizontal: 16),
                child: Text(
                  'core.reload'.tr(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import 'custom_svg.dart';

class CustomEmpty extends StatelessWidget {
  const CustomEmpty({
    super.key,
    this.svg,
    this.text,
    this.image,
    this.title,
  });

  final String? svg;
  final String? text;
  final String? title;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSize.padding(all: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (image != null)
            Image.asset(
              image!,
              width: double.infinity,
              height: AppSize.getHeight(24),
            )
          else
            CustomSvg(
              svg: svg ?? AppSvg.empty,
              width: double.infinity,
              height: AppSize.getHeight(240),
            ),
          if (title != null) ...[
            SizedBox(height: AppSize.getHeight(16)),
            Text(
              title!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: AppColors.grey800,
                fontSize: AppSize.font(24),
                height: AppSize.fontHeight(24, 32),
              ),
            ),
          ],
          SizedBox(height: AppSize.getHeight(16), width: double.infinity),
          Text(
            text ?? 'core.no_content'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppSize.font(16),
              height: AppSize.fontHeight(16, 24),
              fontWeight: FontWeight.w500,
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}

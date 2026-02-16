import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/style/app_colors.dart';

class VolunteerHomeAppbarWidget extends StatelessWidget {
  const VolunteerHomeAppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: AppSize.padding(horizontal: 15),
      height: AppSize.getHeight(60),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1.5),
            color: AppColors.grey.withValues(alpha: 0.35),
            blurRadius: 3,
          ),
        ],
        // border: Border(
        //   bottom: BorderSide(
        //     color: AppColors.grey.withValues(alpha: 0.5),
        //     width: 0.5,
        //   ),
        // ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppSize.getSize(35),
            height: AppSize.getSize(35),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withValues(alpha: 0.35),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Text('🤝', style: TextStyle(fontSize: AppSize.font(22))),
            ),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Text(
            'Sanad',
            style: TextStyle(
              fontSize: AppSize.font(18),
              fontWeight: FontWeight.w400,
              color: AppColors.black,
            ),
          ),
          Spacer(),
          CustomIcon(
            icon: AppIcons.notification,
            width: AppSize.getSize(25),
            height: AppSize.getSize(25),
            color: AppColors.black,
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Container(
            width: AppSize.getSize(35),
            height: AppSize.getSize(35),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.grey.withValues(alpha: 0.35),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Text(
                'A',
                style: TextStyle(
                  fontSize: AppSize.font(20),
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

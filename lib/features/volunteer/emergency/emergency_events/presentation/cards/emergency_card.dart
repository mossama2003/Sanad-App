import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/shared/widgets/custom_progress_bar.dart';
import '../../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/style/app_colors.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.padding(all: 20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.red.withValues(alpha: 0.6)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.emergency,
                color: AppColors.red,
                width: AppSize.getWidth(18),
                height: AppSize.getHeight(18),
              ),
              SizedBox(width: AppSize.getWidth(8)),
              Container(
                padding: AppSize.padding(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.red.withValues(alpha: 0.2),
                ),
                child: Center(
                  child: Text(
                    'volunteer.emergency.card.critical'.tr().toUpperCase(),
                    style: TextStyle(
                      fontSize: AppSize.font(11),
                      fontWeight: FontWeight.w500,
                      color: AppColors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(8)),
          Text(
            'volunteer.emergency_removed.flood_relief'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(20),
              color: AppColors.red,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: AppSize.getHeight(8)),
          Text(
            'volunteer.emergency_removed.urgent_need'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(15),
              color: AppColors.grey700,
            ),
          ),
          SizedBox(height: AppSize.getHeight(15)),
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.location,
                color: AppColors.grey800,
                width: AppSize.getSize(15),
                height: AppSize.getSize(15),
              ),
              SizedBox(width: AppSize.getWidth(5)),
              Text(
                'volunteer.emergency_removed.minya_egypt'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(13),
                  color: AppColors.grey800,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(8)),
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.community,
                color: AppColors.grey800,
                width: AppSize.getSize(15),
                height: AppSize.getSize(15),
              ),
              SizedBox(width: AppSize.getWidth(5)),
              Text(
                'volunteer.emergency_removed.volunteers_joined'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(13),
                  color: AppColors.grey800,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(8)),
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.duration,
                color: AppColors.grey800,
                width: AppSize.getSize(15),
                height: AppSize.getSize(15),
              ),
              SizedBox(width: AppSize.getWidth(5)),
              Text(
                'volunteer.emergency_removed.posted'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(13),
                  color: AppColors.grey800,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(15)),
          CustomProgressBar(
            percent: 50,
            color: AppColors.red,
            height: AppSize.getHeight(8),
          ),
          SizedBox(height: AppSize.getHeight(15)),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: CustomButton(
                  onTap: () {},
                  title: 'volunteer.emergency.card.join_now'.tr(),
                  height: AppSize.getHeight(45),
                  bgColor: AppColors.red,
                ),
              ),
              SizedBox(width: AppSize.getWidth(5)),
              Expanded(
                child: CustomButton(
                  onTap: () {},
                  title: 'volunteer.emergency.card.contact'.tr(),
                  height: AppSize.getHeight(45),
                  bgColor: AppColors.white,
                  borderColor: AppColors.grey300,
                  textColor: AppColors.grey700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

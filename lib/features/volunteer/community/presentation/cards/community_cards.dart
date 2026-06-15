import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/chat/presentation/screens/chat_screen.dart';

class CommunityCards extends StatelessWidget {
  const CommunityCards({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> AppNavigator.push(ChatScreen()),
      child: Column(
        children: [
          Container(
            padding: AppSize.padding(all: 15),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: AppSize.getSize(40),
                      height: AppSize.getSize(40),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: CustomIcon(
                          icon: AppIcons.chat,
                          color: AppColors.white,
                          width: AppSize.getSize(22),
                          height: AppSize.getSize(22),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'volunteer.home_removed.blood_donation_drive_date'
                                      .tr(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppSize.font(15),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),

                              SizedBox(width: AppSize.getWidth(13)),

                              Text(
                                'volunteer.community.2_min_ago'.tr(),
                                style: TextStyle(
                                  fontSize: AppSize.font(11),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black.withValues(alpha: 0.55),
                                ),
                              ),

                              SizedBox(width: AppSize.getWidth(10)),

                              Container(
                                width: AppSize.getSize(20),
                                height: AppSize.getSize(20),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    '3',
                                    style: TextStyle(
                                      fontSize: AppSize.font(13),
                                      color: AppColors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.getHeight(5)),
                          Text(
                            'volunteer.home_removed.egyptian_red_crescent'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              fontWeight: FontWeight.w400,
                              color: AppColors.black.withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: AppSize.getHeight(5)),
                          Row(
                            children: [
                              CustomIcon(
                                icon: AppIcons.community,
                                color: AppColors.black.withValues(alpha: 0.5),
                                height: AppSize.getSize(18),
                                width: AppSize.getSize(18),
                              ),
                              SizedBox(width: AppSize.getWidth(2)),
                              Text(
                                '45',
                                style: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: AppColors.black.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: AppSize.getWidth(10)),
                              CustomIcon(
                                icon: AppIcons.events,
                                color: AppColors.black.withValues(alpha: 0.5),
                                height: AppSize.getSize(18),
                                width: AppSize.getSize(18),
                              ),
                              SizedBox(width: AppSize.getWidth(2)),
                              Text(
                                'volunteer.home_removed.dec_8_2025'.tr(),
                                style: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: AppColors.black.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.getHeight(5)),
                          Text(
                            'volunteer.home_removed.dont_forget_to_bring_your_id'
                                .tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              fontWeight: FontWeight.w300,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(12)),
                Container(
                  padding: AppSize.padding(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'volunteer.community.expired'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSize.getHeight(10)),

          Container(
            padding: AppSize.padding(all: 15),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: AppSize.getSize(40),
                      height: AppSize.getSize(40),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: CustomIcon(
                          icon: AppIcons.chat,
                          color: AppColors.white,
                          width: AppSize.getSize(22),
                          height: AppSize.getSize(22),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'volunteer.home_removed.blood_donation_drive_date'
                                      .tr(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: AppSize.font(15),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),

                              SizedBox(width: AppSize.getWidth(13)),

                              Text(
                                'volunteer.community.2_days_ago'.tr(),
                                style: TextStyle(
                                  fontSize: AppSize.font(11),
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.black.withValues(alpha: 0.55),
                                ),
                              ),

                              SizedBox(width: AppSize.getWidth(10)),
                              Container(
                                padding: AppSize.padding(
                                  horizontal: 10,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: AppColors.primary),
                                ),
                                child: Center(
                                  child: Text(
                                    'volunteer.community.ended'.tr(),
                                    style: TextStyle(
                                      fontSize: AppSize.font(13),
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.getHeight(5)),
                          Text(
                            'volunteer.home_removed.egyptian_red_crescent'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              fontWeight: FontWeight.w400,
                              color: AppColors.black.withValues(alpha: 0.8),
                            ),
                          ),
                          SizedBox(height: AppSize.getHeight(5)),
                          Row(
                            children: [
                              CustomIcon(
                                icon: AppIcons.community,
                                color: AppColors.black.withValues(alpha: 0.5),
                                height: AppSize.getSize(18),
                                width: AppSize.getSize(18),
                              ),
                              SizedBox(width: AppSize.getWidth(2)),
                              Text(
                                '45',
                                style: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: AppColors.black.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: AppSize.getWidth(10)),
                              CustomIcon(
                                icon: AppIcons.events,
                                color: AppColors.black.withValues(alpha: 0.5),
                                height: AppSize.getSize(18),
                                width: AppSize.getSize(18),
                              ),
                              SizedBox(width: AppSize.getWidth(2)),
                              Text(
                                'volunteer.home_removed.dec_8_2025'.tr(),
                                style: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: AppColors.black.withValues(alpha: 0.5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.getHeight(5)),
                          Text(
                            'volunteer.home_removed.dont_forget_to_bring_your_id'
                                .tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              fontWeight: FontWeight.w300,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(12)),
                Container(
                  padding: AppSize.padding(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    color: AppColors.grey.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'volunteer.community.expired'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      color: AppColors.black,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

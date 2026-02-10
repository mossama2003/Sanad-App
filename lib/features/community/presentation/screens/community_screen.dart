import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../core/constant/app_assets.dart';
import '../../../../core/constant/app_size.dart';
import '../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../core/style/app_colors.dart';
import '../../../home/presentation/widgets/home_appbar_widget.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeAppbarWidget(),
              SizedBox(height: AppSize.getHeight(15)),
              Padding(
                padding: AppSize.padding(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'community.title'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(22),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(8)),
                    Text(
                      'community.desc'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(20)),
                    CustomFieldText(
                      controller: TextEditingController(),
                      bgColor: AppColors.white,
                      iconStart: AppIcons.search,
                      hintText: 'community.search'.tr(),
                    ),
                    SizedBox(height: AppSize.getHeight(20)),
                    Container(
                      padding: AppSize.padding(all: 15),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(12),
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
                                width: AppSize.getSize(50),
                                height: AppSize.getSize(50),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: CustomIcon(
                                    icon: AppIcons.chat,
                                    color: AppColors.white,
                                    width: AppSize.getSize(28),
                                    height: AppSize.getSize(28),
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
                                        Text(
                                          'home_removed.blood_donation_drive_date'
                                              .tr(),
                                          style: TextStyle(
                                            fontSize: AppSize.font(15),
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: AppSize.getSize(20),
                                          height: AppSize.getSize(20),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
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
                                      'home_removed.egyptian_red_crescent'.tr(),
                                      style: TextStyle(
                                        fontSize: AppSize.font(13),
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.black.withValues(
                                          alpha: 0.8,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: AppSize.getHeight(5)),
                                    Row(
                                      children: [
                                        CustomIcon(
                                          icon: AppIcons.community,
                                          color: AppColors.black.withValues(
                                            alpha: 0.5,
                                          ),
                                          height: AppSize.getSize(18),
                                          width: AppSize.getSize(18),
                                        ),
                                        SizedBox(width: AppSize.getWidth(2)),
                                        Text(
                                          '45',
                                          style: TextStyle(
                                            fontSize: AppSize.font(13),
                                            color: AppColors.black.withValues(
                                              alpha: 0.5,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(width: AppSize.getWidth(10)),
                                        CustomIcon(
                                          icon: AppIcons.events,
                                          color: AppColors.black.withValues(
                                            alpha: 0.5,
                                          ),
                                          height: AppSize.getSize(18),
                                          width: AppSize.getSize(18),
                                        ),
                                        SizedBox(width: AppSize.getWidth(2)),
                                        Text(
                                          'home_removed.dec_8_2025'.tr(),
                                          style: TextStyle(
                                            fontSize: AppSize.font(13),
                                            color: AppColors.black.withValues(
                                              alpha: 0.5,
                                            ),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: AppSize.getHeight(5)),
                                    Text(
                                      'home_removed.dont_forget_to_bring_your_id'
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
                            padding: AppSize.padding(
                              vertical: 3,
                              horizontal: 10,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.grey.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'community.expired'.tr(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

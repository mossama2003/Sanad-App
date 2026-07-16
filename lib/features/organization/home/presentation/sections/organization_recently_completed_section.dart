import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';

class OrganizationRecentlyCompletedSection extends StatelessWidget {
  const OrganizationRecentlyCompletedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'organization.home.recently_completed.title'.tr(),
          style: TextStyle(
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: AppSize.getHeight(12)),
        ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: AppSize.padding(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: AppSize.padding(all: 15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'organization.home_removed.food_distribution'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(15),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: AppSize.padding(vertical: 2, horizontal: 5),
                          decoration: BoxDecoration(
                            color: AppColors.yellow500.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                CustomIcon(
                                  icon: AppIcons.star,
                                  width: AppSize.getSize(25),
                                  height: AppSize.getSize(25),
                                  withColor: true,
                                ),
                                Text(
                                  '4.8',
                                  style: TextStyle(
                                    fontSize: AppSize.font(15),
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.secondary400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.getHeight(5)),
                    Text(
                      'organization.home_removed.dec_8_2025'.tr(),
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
                          color: AppColors.grey700,
                          width: AppSize.getSize(18),
                          height: AppSize.getSize(18),
                        ),
                        SizedBox(width: AppSize.getWidth(5)),
                        Text(
                          'organization.home_removed.52_volunteer'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            fontWeight: FontWeight.w400,
                            color: AppColors.black.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}


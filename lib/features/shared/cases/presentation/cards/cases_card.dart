import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../dialogs/cases_pop_up.dart';

class CasesCard extends StatelessWidget {
  const CasesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
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
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.grey.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Image.asset(
                AppImages.casesImage,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: AppSize.padding(all: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: AppSize.padding(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: Row(
                          children: [
                            CustomIcon(
                              icon: AppIcons.check,
                              color: AppColors.primary,
                              width: AppSize.getSize(13),
                              height: AppSize.getSize(13),
                            ),
                            SizedBox(width: AppSize.getWidth(3)),
                            Text(
                              'Verified',
                              style: TextStyle(
                                fontSize: AppSize.font(10),
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(8)),
                    Text(
                      '2 days ago',
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w300,
                        color: AppColors.grey700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Text(
                  'shared.cases_removed.family_displaced_by_fire'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(12)),
                Text(
                  'shared.cases_removed.a_family_of_6_lost'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(15)),
                Container(
                  padding: AppSize.padding(all: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.grey50,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIcon(
                            icon: AppIcons.phone,
                            color: AppColors.laserBlue,
                            width: AppSize.getSize(20),
                            height: AppSize.getSize(20),
                          ),
                          SizedBox(width: AppSize.getWidth(10)),
                          Text(
                            'shared.cases_removed.contact'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              color: AppColors.grey700,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(10)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIcon(
                            icon: AppIcons.phone,
                            color: AppColors.laserBlue,
                            width: AppSize.getSize(20),
                            height: AppSize.getSize(20),
                          ),
                          SizedBox(width: AppSize.getWidth(10)),
                          Text(
                            '+20 123 456 7890',
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              color: AppColors.laserBlue,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(10)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomIcon(
                            icon: AppIcons.creditCard,
                            color: AppColors.laserBlue,
                            width: AppSize.getSize(20),
                            height: AppSize.getSize(20),
                          ),
                          SizedBox(width: AppSize.getWidth(10)),
                          Text(
                            'shared.cases_removed.national_bank'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              color: AppColors.grey700,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSize.getHeight(10)),
                Divider(thickness: 0.3, height: 1, color: AppColors.grey300),
                SizedBox(height: AppSize.getHeight(10)),
                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.donations,
                      color: AppColors.grey600,
                      width: AppSize.getWidth(18),
                      height: AppSize.getHeight(18),
                    ),
                    SizedBox(width: AppSize.getWidth(3)),
                    Text(
                      '380',
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    CustomIcon(
                      icon: AppIcons.share,
                      color: AppColors.grey600,
                      width: AppSize.getWidth(18),
                      height: AppSize.getHeight(18),
                    ),
                    SizedBox(width: AppSize.getWidth(3)),
                    Text(
                      '87',
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(15)),
                CustomButton(
                  title: 'shared.cases.card.button'.tr(),
                  height: AppSize.getHeight(50),
                  onTap: () => AppNavigator.dialog(CasesPopUp()),
                  bgColor: AppColors.laserBlue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

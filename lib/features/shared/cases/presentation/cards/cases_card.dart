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
        borderRadius: BorderRadius.circular(30),
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
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.grey.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Image.asset(
                    AppImages.casesImage,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: AppSize.getHeight(10),
                  right: AppSize.getWidth(10),
                  child: Container(
                    padding: AppSize.padding(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'shared.cases_removed.days_Ago'.tr(),
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: AppSize.font(11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: AppSize.getHeight(10),
                  left: AppSize.getWidth(10),
                  child: Container(
                    padding: AppSize.padding(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.brand200.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        CustomIcon(
                          icon: AppIcons.cases,
                          color: AppColors.red,
                          width: AppSize.getSize(17),
                          height: AppSize.getSize(17),
                        ),
                        SizedBox(width: AppSize.getWidth(5)),
                        Text(
                          'shared.cases.card.urgent'.tr(),
                          style: TextStyle(
                            color: AppColors.red,
                            fontSize: AppSize.font(11),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  top: AppSize.getHeight(10),
                  left: AppSize.getWidth(101),
                  child: Container(
                    padding: AppSize.padding(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        CustomIcon(
                          icon: AppIcons.check,
                          color: AppColors.green,
                          width: AppSize.getSize(17),
                          height: AppSize.getSize(17),
                        ),
                        SizedBox(width: AppSize.getWidth(5)),
                        Text(
                          'shared.cases.card.verified'.tr(),
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: AppSize.font(11),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSize.padding(all: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.cases_removed.family_displaced_by_fire'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Text(
                  'shared.cases_removed.a_family_of_6_lost'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: AppColors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(15)),
                Container(
                  padding: AppSize.padding(all: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: AppColors.grey300.withValues(alpha: 0.3),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'shared.cases.card.required'.tr(),
                                style: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: AppColors.grey600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: AppSize.getHeight(5)),
                              Text(
                                'shared.cases_removed.EGP_75000'.tr(),
                                style: TextStyle(
                                  fontSize: AppSize.font(20),
                                  color: AppColors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'shared.cases.card.raised'.tr(),
                                style: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: AppColors.grey600,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: AppSize.getHeight(5)),
                              Text(
                                'shared.cases_removed.EGP_45000'.tr(),
                                style: TextStyle(
                                  fontSize: AppSize.font(20),
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSize.getHeight(10)),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIcon(
                      icon: AppIcons.person,
                      color: AppColors.grey700,
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
                      color: AppColors.grey700,
                      width: AppSize.getSize(20),
                      height: AppSize.getSize(20),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Text(
                      '+20 123 456 7890',
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
                      icon: AppIcons.creditCard,
                      color: AppColors.grey700,
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
                SizedBox(height: AppSize.getHeight(10)),
                Divider(thickness: 0.3, height: 1, color: AppColors.grey300),
                SizedBox(height: AppSize.getHeight(15)),
                Row(
                  children: [
                    SizedBox(width: AppSize.getWidth(25)),
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
                    SizedBox(width: AppSize.getWidth(25)),
                    CustomIcon(
                      icon: AppIcons.comment,
                      color: AppColors.grey600,
                      width: AppSize.getWidth(18),
                      height: AppSize.getHeight(18),
                    ),
                    SizedBox(width: AppSize.getWidth(3)),
                    Text(
                      '80',
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: AppSize.padding(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          CustomIcon(
                            icon: AppIcons.share,
                            color: AppColors.green,
                            width: AppSize.getWidth(18),
                            height: AppSize.getHeight(18),
                          ),
                          SizedBox(width: AppSize.getWidth(3)),
                          Text(
                            '87',
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: AppSize.font(15),
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(25)),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(20)),
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

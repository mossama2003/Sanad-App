import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/validator/app_validators.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/helper/app_navigator.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/style/app_text_style.dart';

class ReportEmergencyScreen extends StatelessWidget {
  const ReportEmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(iconTheme: IconThemeData(color: AppColors.primary)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSize.padding(all: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'emergency.reports.title'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(22),
                    fontWeight: FontWeight.w500,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Text(
                  'emergency.reports.desc'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(20)),
                CustomFieldText(
                  controller: TextEditingController(),
                  validator: AppValidators.required,
                  title: 'emergency.reports.emergency_title'.tr(),
                  hintText: 'emergency.reports.brief'.tr(),
                ),
                SizedBox(height: AppSize.getHeight(12)),
                CustomFieldText(
                  controller: TextEditingController(),
                  validator: AppValidators.required,
                  maxLines: 5,
                  minLines: 5,
                  title: 'emergency.reports.description'.tr(),
                  hintText: 'emergency.reports.detailed'.tr(),
                ),
                SizedBox(height: AppSize.getHeight(12)),
                Text(
                  'emergency.reports.urgency_level'.tr(),
                  style: TextStyle(color: AppColors.grey700).xs,
                ),
                SizedBox(height: AppSize.getHeight(6)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
                        height: AppSize.getHeight(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                          border: Border.all(color: AppColors.red),
                        ),
                        child: Center(
                          child: Text(
                            'emergency.reports.critical'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(15),
                              color: AppColors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(5)),
                    Expanded(
                      child: Container(
                        height: AppSize.getHeight(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                          border: Border.all(color: AppColors.brand600),
                        ),
                        child: Center(
                          child: Text(
                            'emergency.reports.high'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(15),
                              color: AppColors.brand600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(5)),
                    Expanded(
                      child: Container(
                        height: AppSize.getHeight(50),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.white,
                          border: Border.all(color: AppColors.secondary400),
                        ),
                        child: Center(
                          child: Text(
                            'emergency.reports.medium'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(15),
                              color: AppColors.secondary400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(12)),
                CustomFieldText(
                  controller: TextEditingController(),
                  validator: AppValidators.required,
                  title: 'emergency.reports.location'.tr(),
                  hintText: 'emergency.reports.city_specific_adress'.tr(),
                ),
                SizedBox(height: AppSize.getHeight(12)),
                CustomFieldText(
                  controller: TextEditingController(),
                  validator: AppValidators.required,
                  title: 'emergency.reports.volunteers_needed'.tr(),
                  hintText: 'emergency.reports.estimated_number_needed'.tr(),
                ),
                SizedBox(height: AppSize.getHeight(12)),
                CustomFieldText(
                  controller: TextEditingController(),
                  validator: AppValidators.required,
                  title: 'emergency.reports.contact_information'.tr(),
                  hintText: 'emergency.reports.phone_number_for_coordination'
                      .tr(),
                ),
                SizedBox(height: AppSize.getHeight(20)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomButton(
                        onTap: () => AppNavigator.pop(),
                        title: 'emergency.reports.cancel'.tr(),
                        textColor: AppColors.black,
                        textSize: AppSize.font(15),
                        height: AppSize.getHeight(45),
                        bgColor: AppColors.grey200,
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Expanded(
                      child: CustomButton(
                        title: 'emergency.reports.submit_emergency'.tr(),
                        textColor: AppColors.white,
                        textSize: AppSize.font(15),
                        height: AppSize.getHeight(45),
                        bgColor: AppColors.red,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

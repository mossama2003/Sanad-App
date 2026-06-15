import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../report_emergency_event/presentation/screens/report_emergency_screen.dart';
import '../cards/emergency_card.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(iconTheme: IconThemeData(color: AppColors.red)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSize.padding(all: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.emergency,
                      color: AppColors.red,
                      width: AppSize.getWidth(25),
                      height: AppSize.getHeight(25),
                    ),
                    SizedBox(width: AppSize.getWidth(8)),
                    Text(
                      'volunteer.emergency.title'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(22),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Text(
                  'volunteer.emergency.desc'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w400,
                    color: AppColors.black.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(20)),
                CustomButton(
                  onTap: () => AppNavigator.push(ReportEmergencyScreen()),
                  title: 'volunteer.emergency.button'.tr(),
                  bgColor: AppColors.red,
                  icon: AppIcons.add,
                  height: AppSize.getHeight(50),
                ),
                SizedBox(height: AppSize.getHeight(20)),
                EmergencyCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

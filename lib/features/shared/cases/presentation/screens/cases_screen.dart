import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../volunteer/home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../cards/cases_card.dart';

class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VolunteerHomeAppbarWidget(),
              SizedBox(height: AppSize.getHeight(15)),
              Padding(
                padding: AppSize.padding(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'shared.cases.title'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(22),
                        fontWeight: FontWeight.w500,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(8)),
                    Text(
                      'shared.cases.desc'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(20)),
                    CustomButton(
                      title: 'shared.cases.button'.tr(),
                      bgColor: AppColors.laserBlue,
                      icon: AppIcons.add,
                      height: AppSize.getHeight(50),
                    ),
                    SizedBox(height: AppSize.getHeight(20)),
                    CasesCard(),
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

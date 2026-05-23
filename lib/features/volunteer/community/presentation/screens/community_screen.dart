import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../cards/community_cards.dart';

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
              VolunteerHomeAppbarWidget(),
              SizedBox(height: AppSize.getHeight(15)),
              Padding(
                padding: AppSize.padding(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'volunteer.community.title'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(22),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(3)),
                    Text(
                      'volunteer.community.desc'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w300,
                        color: AppColors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(15)),
                    CustomFieldText(
                      controller: TextEditingController(),
                      bgColor: AppColors.white,
                      iconStart: AppIcons.search,
                      hintText: 'volunteer.community.search'.tr(),
                    ),
                    SizedBox(height: AppSize.getHeight(15)),
                    CommunityCards(),

                    SizedBox(height: AppSize.getHeight(20)),

                    Center(
                      child: Text(
                        'volunteer.community.communities_are_automatically_created'
                            .tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppSize.font(13),
                          fontWeight: FontWeight.w400,
                          color: AppColors.black.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'volunteer.community.chat_access_remains'.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: AppSize.font(13),
                          fontWeight: FontWeight.w400,
                          color: AppColors.black.withValues(alpha: 0.7),
                        ),
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

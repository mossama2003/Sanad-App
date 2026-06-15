import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../volunteer/home/presentation/widgets/volunteer_home_appbar_widget.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../cards/donations_card.dart';
import '../cards/donations_info_card.dart';

class DonationsScreen extends StatelessWidget {
  const DonationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
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
                      'shared.donations.title'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(22),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(3)),
                    Text(
                      'shared.donations.desc'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        fontWeight: FontWeight.w300,
                        color: AppColors.black.withValues(alpha: 0.7),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(15)),
                    Row(
                      children: [
                        Expanded(
                          child: DonationsInfoCard(
                            icon: AppIcons.donations,
                            iconColor: AppColors.primary,
                            iconBackgroundColor: AppColors.primary.withValues(
                              alpha: 0.20,
                            ),
                            title: 'shared.donations_removed.EGP_12500'.tr(),
                            subtitle: 'shared.donations.your_total_donations'
                                .tr(),
                          ),
                        ),

                        SizedBox(width: AppSize.getWidth(13)),

                        Expanded(
                          child: DonationsInfoCard(
                            icon: AppIcons.growthArrow,
                            iconColor: AppColors.laserBlue,
                            iconBackgroundColor: AppColors.laserBlue.withValues(
                              alpha: 0.20,
                            ),
                            title: 'shared.donations_removed.8'.tr(),
                            subtitle: 'shared.donations.campaigns_supported'
                                .tr(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.getHeight(15)),
                    DonationsCard(),
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

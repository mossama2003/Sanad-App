import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/style/app_colors.dart';

import '../../../rewards/presentation/screens/rewards_screen.dart';

class AvatarSection extends StatelessWidget {
  const AvatarSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: AppSize.getWidth(88),
              height: AppSize.getWidth(88),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xFF2ECFA0), Color(0xFF1BB88A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: CustomIcon(
                  icon: AppIcons.profile,
                  color: AppColors.white,
                  width: AppSize.getSize(50),
                  height: AppSize.getSize(50),
                ),
              ),
            ),

            Positioned(
              bottom: -1,
              child: GestureDetector(
                onTap: () => AppNavigator.push(RewardsScreen()),
                child: Container(
                  padding: AppSize.padding(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.selago,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'shared.profile.level'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(11),
                      fontWeight: FontWeight.w700,
                      color: AppColors.sportyViolet,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: AppSize.getHeight(10)),

        Text(
          'Ahmed Mohamed',
          style: TextStyle(
            fontSize: AppSize.font(22),
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),

        SizedBox(height: AppSize.getHeight(4)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              icon: AppIcons.location,
              color: AppColors.grey,
              width: AppSize.getSize(15),
              height: AppSize.getSize(15),
            ),

            SizedBox(width: AppSize.getHeight(3)),

            Text(
              'shared.profile_removed.location'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(15),
                color: AppColors.grey,
              ),
            ),
          ],
        ),

        SizedBox(width: AppSize.getHeight(3)),

        Text(
          'shared.profile_removed.created'.tr(),
          style: TextStyle(fontSize: AppSize.font(15), color: AppColors.grey),
        ),
      ],
    );
  }
}

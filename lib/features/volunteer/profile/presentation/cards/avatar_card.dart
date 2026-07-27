import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/style/app_colors.dart';

import '../../../rewards/presentation/screens/rewards_screen.dart';

class AvatarCard extends StatelessWidget {
  const AvatarCard({
    super.key,
    required this.name,
    required this.location,
    required this.createdAt,
    this.image,
    this.level,
  });

  final String name;
  final String location;
  final String createdAt;
  final String? image;
  final String? level;

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
              child: image != null && image!.isNotEmpty
                  ? ClipOval(
                      child: Image.network(
                        image!,
                        fit: BoxFit.cover,
                        width: AppSize.getWidth(88),
                        height: AppSize.getWidth(88),
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: CustomIcon(
                              icon: AppIcons.profile,
                              color: AppColors.white,
                              width: AppSize.getSize(50),
                              height: AppSize.getSize(50),
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
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
                onTap: () => AppNavigator.push(const VolunteerRewardsScreen()),
                child: Container(
                  padding: AppSize.padding(horizontal: 12, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.selago,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .08),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    level ?? 'shared.profile.level'.tr(),
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
          name,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color,
            fontSize: AppSize.font(22),
            fontWeight: FontWeight.w700,
            letterSpacing: -.3,
          ),
        ),

        SizedBox(height: AppSize.getHeight(6)),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              icon: AppIcons.location,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              width: AppSize.getSize(15),
              height: AppSize.getSize(15),
            ),
            SizedBox(width: AppSize.getWidth(3)),
            Text(
              location,
              style: TextStyle(
                fontSize: AppSize.font(15),
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ],
        ),

        SizedBox(height: AppSize.getHeight(3)),

        Text(
          createdAt,
          style: TextStyle(
            fontSize: AppSize.font(15),
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }
}

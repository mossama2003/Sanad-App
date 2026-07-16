import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class VolunteerProfileCard extends StatefulWidget {
  const VolunteerProfileCard({super.key});

  @override
  State<VolunteerProfileCard> createState() => _VolunteerProfileCardState();
}

class _VolunteerProfileCardState extends State<VolunteerProfileCard> {
  final items = [
    {
      'title': 'volunteer.profile.blood_type'.tr(),
      'value': 'O-',
      'icon': AppIcons.blood,
    },
    {
      'title': 'volunteer.profile.profession'.tr(),
      'value': 'volunteer.profile_removed.nurse'.tr(),
      'icon': AppIcons.business,
    },
    {
      'title': 'volunteer.profile.own_vehicle'.tr(),
      'value': 'volunteer.profile_removed.yes'.tr(),
      'icon': AppIcons.car,
    },
    {
      'title': 'volunteer.profile.exp'.tr(),
      'value': 'volunteer.profile_removed.years'.tr(),
      'icon': AppIcons.experience,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;

    final secondaryTextColor = isDark ? AppColors.grey400 : AppColors.grey500;

    final itemBackground = isDark
        ? AppColors.grey900.withValues(alpha: .25)
        : AppColors.grey300.withValues(alpha: .2);

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: textColor.withValues(alpha: .15), width: .7),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppSize.padding(all: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'volunteer.profile.volunteer_profile'.tr(),
            style: TextStyle(
              color: textColor,
              fontSize: AppSize.font(15),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSize.getHeight(16)),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSize.getWidth(10),
              mainAxisSpacing: AppSize.getHeight(10),
              childAspectRatio: 2.8,
            ),

            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                decoration: BoxDecoration(
                  color: itemBackground,
                  borderRadius: BorderRadius.circular(20),
                ),

                padding: AppSize.padding(vertical: 10, horizontal: 15),

                child: Row(
                  children: [
                    Container(
                      width: AppSize.getWidth(30),
                      height: AppSize.getHeight(30),

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withValues(alpha: .1),
                      ),

                      child: Center(
                        child: CustomIcon(
                          icon: item['icon'] as String,
                          width: AppSize.getWidth(18),
                          height: AppSize.getHeight(18),
                        ),
                      ),
                    ),

                    SizedBox(width: AppSize.getWidth(10)),

                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Expanded(
                            child: Text(
                              item['title'] as String,

                              style: TextStyle(
                                color: secondaryTextColor,
                                fontWeight: FontWeight.w300,
                                fontSize: AppSize.font(11),
                              ),
                            ),
                          ),

                          Text(
                            item['value'] as String,

                            style: TextStyle(
                              color: textColor,
                              fontSize: AppSize.font(14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: AppSize.getHeight(16)),
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.language,
                color: secondaryTextColor,
                width: AppSize.getSize(18),
                height: AppSize.getSize(18),
              ),

              SizedBox(width: AppSize.getWidth(5)),

              Text(
                'volunteer.profile.language'.tr(),

                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(10)),

          Row(
            children: [
              ...List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(right: AppSize.getWidth(5)),

                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(
                        alpha: isDark ? .2 : .1,
                      ),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    padding: AppSize.padding(vertical: 5, horizontal: 13),

                    child: Text(
                      'English',

                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppSize.font(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(16)),

          Row(
            children: [
              CustomIcon(
                icon: AppIcons.skills,
                color: secondaryTextColor,
                width: AppSize.getSize(14),
                height: AppSize.getSize(14),
              ),

              SizedBox(width: AppSize.getWidth(5)),

              Text(
                'volunteer.profile.skills_certifications'.tr(),

                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(10)),

          Row(
            children: [
              ...List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.only(right: AppSize.getWidth(5)),

                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.laserBlue.withValues(
                        alpha: isDark ? .2 : .1,
                      ),

                      borderRadius: BorderRadius.circular(20),
                    ),

                    padding: AppSize.padding(vertical: 5, horizontal: 13),

                    child: Text(
                      'English',

                      style: TextStyle(
                        color: AppColors.laserBlue,
                        fontSize: AppSize.font(12),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(16)),

          CustomButton(
            onTap: () {
              // Handle button tap
            },

            height: AppSize.getHeight(35),

            bgColor: AppColors.primary.withValues(alpha: isDark ? .2 : .1),

            title: 'volunteer.profile.edit_volunteer_profile'.tr(),

            textColor: AppColors.primary,

            textSize: AppSize.font(13),
          ),
        ],
      ),
    );
  }
}

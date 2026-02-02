import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../core/constant/app_size.dart';
import '../../../../core/style/app_colors.dart';

class RecentlyCompletedSection extends StatelessWidget {
  const RecentlyCompletedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'home.recently_completed.title'.tr(),
          style: TextStyle(
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
        SizedBox(height: AppSize.getHeight(12)),
        ListView.builder(
          itemCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: AppSize.padding(bottom: 12),
              child: Container(
                width: double.infinity,
                padding: AppSize.padding(all: 15),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(15),
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
                    Row(
                      children: [
                        Text(
                          'home_removed.food_distribution'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(15),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Spacer(),
                        Container(
                          width: AppSize.getWidth(60),
                          height: AppSize.getHeight(25),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '+50 XP',
                              style: TextStyle(
                                fontSize: AppSize.font(15),
                                fontWeight: FontWeight.w400,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSize.getHeight(5)),
                    Text(
                      'home_removed.resala_charity'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w400,
                        color: AppColors.black.withValues(alpha: 0.8),
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(5)),
                    Text(
                      'home_removed.dec_8_2025'.tr(),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

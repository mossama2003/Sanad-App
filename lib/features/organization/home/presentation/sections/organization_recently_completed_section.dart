import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_number_formatter.dart';
import '../../../../../core/style/app_colors.dart';
import '../controllers/organization_home_cubit.dart';

class OrganizationRecentlyCompletedSection extends StatelessWidget {
  const OrganizationRecentlyCompletedSection({super.key, required this.cubit});

  final OrganizationHomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final events = cubit.home?.recentCompletedEvents ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'organization.home.recently_completed.title'.tr(),

          style: TextStyle(
            fontSize: AppSize.font(18),

            fontWeight: FontWeight.w600,

            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: AppSize.getHeight(12)),

        if (events.isEmpty)
          Center(
            child: Padding(
              padding: AppSize.padding(vertical: 30),

              child: Text(
                'organization.events.no_events_found'.tr(),

                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: .6),

                  fontSize: AppSize.font(14),
                ),
              ),
            ),
          )
        else
          ListView.builder(
            itemCount: events.length,

            shrinkWrap: true,

            physics: const NeverScrollableScrollPhysics(),

            itemBuilder: (context, index) {
              final event = events[index];

              return Padding(
                padding: AppSize.padding(bottom: 12),

                child: Container(
                  width: double.infinity,

                  padding: AppSize.padding(all: 14),

                  decoration: BoxDecoration(
                    color: theme.cardColor,

                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(
                      color: theme.colorScheme.onSurface.withValues(
                        alpha: isDark ? .12 : .08,
                      ),
                    ),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? .35 : .08,
                        ),

                        blurRadius: 8,
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Container(
                        width: AppSize.getWidth(40),

                        height: AppSize.getHeight(40),

                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(
                            alpha: isDark ? .18 : .12,
                          ),

                          shape: BoxShape.circle,
                        ),

                        child: Center(
                          child: CustomIcon(
                            icon: AppIcons.check,

                            color: AppColors.primary,

                            width: AppSize.getSize(20),

                            height: AppSize.getSize(20),
                          ),
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(12)),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              event.name,

                              maxLines: 1,

                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                fontSize: AppSize.font(15),

                                fontWeight: FontWeight.w600,

                                color: theme.colorScheme.onSurface,
                              ),
                            ),

                            SizedBox(height: AppSize.getHeight(3)),

                            Text(
                              DateFormat('MMM dd, yyyy').format(event.date),

                              style: TextStyle(
                                fontSize: AppSize.font(12),

                                fontWeight: FontWeight.w400,

                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: .55,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(8)),

                      Text(
                        '${event.attendees.compact} ${'organization.home.recently_completed.attendees'.tr()}',

                        textAlign: TextAlign.end,

                        style: TextStyle(
                          fontSize: AppSize.font(13),

                          fontWeight: FontWeight.w600,

                          color: AppColors.primary,
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

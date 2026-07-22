import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class OrganizationRecentlyCompletedSection extends StatelessWidget {
  const OrganizationRecentlyCompletedSection({super.key});

  static final List<_CompletedEvent> _events = [
    _CompletedEvent(
      title: 'organization.home.recently_completed.winter_clothing_drive'.tr(),
      date: 'organization.home.recently_completed.nov_28_2025'.tr(),
      joined: 80,
    ),

    _CompletedEvent(
      title: 'organization.home.recently_completed.literacy_workshop'.tr(),
      date: 'organization.home.recently_completed.nov_20_2025'.tr(),
      joined: 25,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

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

        ListView.builder(
          itemCount: _events.length,

          shrinkWrap: true,

          physics: const NeverScrollableScrollPhysics(),

          itemBuilder: (context, index) {
            final event = _events[index];

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
                      color: Colors.black.withValues(alpha: isDark ? .35 : .08),

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
                            event.title,

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
                            event.date,

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
                      '${event.joined} ${'organization.home.recently_completed.joined'.tr()}',

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

class _CompletedEvent {
  final String title;
  final String date;
  final int joined;

  const _CompletedEvent({
    required this.title,
    required this.date,
    required this.joined,
  });
}

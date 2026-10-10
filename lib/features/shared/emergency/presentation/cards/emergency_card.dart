import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../data/models/emergency_model.dart';
import '../helpers/emergency_helpers.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({super.key, required this.emergency, this.onTap});

  final EmergencyModel emergency;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);

    final urgencyColor = EmergencyHelpers.urgencyColor(emergency.urgency);

    final location = emergency.locationText;
    final creatorName = emergency.creator?.name ?? '';

    final percent = (emergency.progress * 100).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .35 : .12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ======================================================
              // Cover + badges + title
              // ======================================================
              SizedBox(
                height: AppSize.getHeight(180),
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    EmergencyCover(
                      url: emergency.coverUrl,
                      color: urgencyColor,
                    ),

                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [.4, 1],
                          colors: [
                            Colors.black.withValues(alpha: .05),
                            Colors.black.withValues(alpha: .75),
                          ],
                        ),
                      ),
                    ),

                    // Badges
                    Positioned(
                      top: AppSize.getHeight(12),
                      left: AppSize.getWidth(12),
                      right: AppSize.getWidth(12),
                      child: Wrap(
                        spacing: AppSize.getWidth(8),
                        runSpacing: AppSize.getHeight(6),
                        children: [
                          EmergencyBadge(
                            label: EmergencyHelpers.urgencyLabel(
                              emergency.urgency,
                            ),
                            color: urgencyColor,
                            icon: AppIcons.siren,
                          ),
                          EmergencyBadge(
                            label: EmergencyHelpers.categoryLabel(
                              emergency.category,
                            ),
                            color: AppColors.grey800,
                          ),

                          // Joined badge
                          if (emergency.joined)
                            EmergencyBadge(
                              label: 'shared.emergency.card.joined'.tr(),
                              color: Colors.green,
                              icon: AppIcons.check,
                            ),
                        ],
                      ),
                    ),

                    // Title + creator
                    Positioned(
                      left: AppSize.getWidth(16),
                      right: AppSize.getWidth(16),
                      bottom: AppSize.getHeight(14),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emergency.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSize.font(20),
                              fontWeight: FontWeight.w700,
                            ),
                          ),

                          if (creatorName.isNotEmpty) ...[
                            SizedBox(height: AppSize.getHeight(2)),
                            Text(
                              creatorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: .9),
                                fontSize: AppSize.font(13),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ======================================================
              // Details
              // ======================================================
              Padding(
                padding: AppSize.padding(all: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time + Location
                    Row(
                      children: [
                        CustomIcon(
                          icon: AppIcons.time,
                          color: secondaryColor,
                          width: AppSize.getSize(15),
                          height: AppSize.getSize(15),
                        ),
                        SizedBox(width: AppSize.getWidth(5)),
                        Text(
                          EmergencyHelpers.timeAgo(emergency.created),
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: secondaryColor,
                          ),
                        ),

                        if (location.isNotEmpty) ...[
                          SizedBox(width: AppSize.getWidth(14)),
                          CustomIcon(
                            icon: AppIcons.location,
                            color: secondaryColor,
                            width: AppSize.getSize(15),
                            height: AppSize.getSize(15),
                          ),
                          SizedBox(width: AppSize.getWidth(5)),
                          Expanded(
                            child: Text(
                              location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppSize.font(13),
                                color: secondaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),

                    SizedBox(height: AppSize.getHeight(12)),

                    // Description
                    Text(
                      emergency.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        color: secondaryColor,
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(14)),

                    // Volunteers
                    Row(
                      children: [
                        CustomIcon(
                          icon: AppIcons.community,
                          color: urgencyColor,
                          width: AppSize.getSize(18),
                          height: AppSize.getSize(18),
                        ),
                        SizedBox(width: AppSize.getWidth(6)),
                        Text(
                          '${emergency.joiners} / ${emergency.volunteers} '
                          '${'shared.emergency.card.volunteers'.tr()}',
                          style: TextStyle(
                            fontSize: AppSize.font(15),
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$percent%',
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: AppSize.getHeight(10)),

                    EmergencyProgressBar(
                      progress: emergency.progress,
                      color: urgencyColor,
                      height: AppSize.getHeight(8),
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

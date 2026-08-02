import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_number_formatter.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/volunteer_event_details_model.dart';

class VolunteerEventsCard extends StatelessWidget {
  const VolunteerEventsCard({
    super.key,
    required this.event,
    this.onDetailsTap,
    this.onJoinTap,
    this.isLoading = false,
  });

  final VolunteerEventDetailsModel event;
  final VoidCallback? onDetailsTap;
  final VoidCallback? onJoinTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .5);

    final name = event.name;
    final description = event.description;
    final category = event.category;
    final date = event.date;

    final location = event.location != null
        ? [
            event.location?['description'] ?? event.location?['address'],
            event.location?['city'],
          ].where((e) => e != null && e.toString().isNotEmpty).join(', ')
        : '';

    final joined = event.joined;

    final spots = event.spots;

    final joiners = event.joiners;

    final status = event.status.toLowerCase();

    final isUpcoming = status == 'upcoming';
    final isOngoing = status == 'ongoing';
    final isCompleted = status == 'completed';

    final isFull = spots > 0 && joiners >= spots;

    final spotsLeft = (spots - joiners).clamp(0, spots);

    final canJoin =
        !joined && !isCompleted && !isFull && (isUpcoming || isOngoing);

    final canLeave = joined && !isCompleted && (isUpcoming || isOngoing);

    final isDisabled = !canJoin && !canLeave;

    final cover = event.cover;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .15), blurRadius: 8),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),

            child: Stack(
              children: [
                SizedBox(
                  height: AppSize.getHeight(200),
                  width: double.infinity,

                  child: cover != null && cover.isNotEmpty
                      ? Image.network(
                          cover,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _buildPlaceholder(context),
                        )
                      : _buildPlaceholder(context),
                ),

                Positioned(
                  top: AppSize.getHeight(10),
                  left: AppSize.getWidth(10),
                  right: AppSize.getWidth(10),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: AppSize.padding(horizontal: 12, vertical: 2),

                        decoration: BoxDecoration(
                          color: AppColors.brand50,
                          borderRadius: BorderRadius.circular(15),
                        ),

                        child: Text(
                          category,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: AppSize.font(12),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      if (joined)
                        Container(
                          padding: AppSize.padding(horizontal: 12, vertical: 2),

                          decoration: BoxDecoration(
                            color: AppColors.grey200,
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Row(
                            children: [
                              CustomIcon(
                                icon: AppIcons.check,
                                width: AppSize.getSize(14),
                                height: AppSize.getSize(14),
                                color: AppColors.primary,
                              ),

                              SizedBox(width: AppSize.getWidth(5)),

                              Text(
                                'volunteer.events.joined'.tr(),
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: AppSize.font(12),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: AppSize.padding(all: 15),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppSize.font(20),
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(3)),

                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),

                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.events,
                      width: AppSize.getSize(18),
                      height: AppSize.getSize(18),
                      color: secondaryColor,
                    ),

                    SizedBox(width: AppSize.getWidth(5)),

                    Text(
                      DateFormat('dd MMM yyyy', 'en').format(date),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: AppSize.font(14),
                      ),
                    ),

                    SizedBox(width: AppSize.getWidth(70)),

                    CustomIcon(
                      icon: AppIcons.time,
                      width: AppSize.getSize(18),
                      height: AppSize.getSize(18),
                      color: secondaryColor,
                    ),

                    SizedBox(width: AppSize.getWidth(5)),

                    Text(
                      DateFormat('hh:mm a', 'en').format(date),
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: AppSize.font(14),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.getHeight(8)),

                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.location,
                      width: AppSize.getSize(18),
                      height: AppSize.getSize(18),
                      color: secondaryColor,
                    ),

                    SizedBox(width: AppSize.getWidth(5)),

                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: AppSize.font(14),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.getHeight(8)),

                Row(
                  children: [
                    CustomIcon(
                      icon: AppIcons.community,
                      width: AppSize.getSize(18),
                      height: AppSize.getSize(18),
                      color: AppColors.primary,
                    ),

                    SizedBox(width: AppSize.getWidth(5)),

                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text:
                                '${joiners.compact} ${'volunteer.events.joined'.tr()}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),

                          TextSpan(
                            text: ' • ',
                            style: TextStyle(color: secondaryColor),
                          ),

                          TextSpan(
                            text:
                                '${spotsLeft.compact} ${'volunteer.events.spot_left'.tr()}',
                            style: TextStyle(color: secondaryColor),
                          ),
                        ],
                      ),

                      style: TextStyle(fontSize: AppSize.font(13)),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.getHeight(15)),

                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        bgColor: Colors.transparent,
                        borderColor: AppColors.primary,
                        textColor: AppColors.primary,
                        icon: AppIcons.info,
                        iconSize: AppSize.getSize(15),
                        title: 'volunteer.events.details'.tr(),
                        onTap: onDetailsTap,
                      ),
                    ),

                    SizedBox(width: AppSize.getWidth(10)),

                    Expanded(
                      child: Opacity(
                        opacity: isDisabled ? .45 : 1,

                        child: CustomButton(
                          loading: isLoading,

                          icon: joined ? AppIcons.check : null,

                          iconSize: AppSize.getSize(15),

                          title: isCompleted
                              ? 'volunteer.events.completed'.tr()
                              : isFull && !joined
                              ? 'volunteer.events.full'.tr()
                              : joined
                              ? 'volunteer.events.joined'.tr()
                              : 'volunteer.events.join_event'.tr(),

                          onTap: isDisabled ? null : onJoinTap,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: AppSize.padding(all: 16),
              decoration: BoxDecoration(
                color: AppColors.grey200,
                shape: BoxShape.circle,
              ),
              child: CustomIcon(
                icon: AppIcons.image,
                width: AppSize.getSize(30),
                height: AppSize.getSize(30),
                color: AppColors.grey,
              ),
            ),
            SizedBox(height: AppSize.getHeight(12)),
            Text(
              'volunteer.events.no_cover'.tr(),
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: AppSize.font(14),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

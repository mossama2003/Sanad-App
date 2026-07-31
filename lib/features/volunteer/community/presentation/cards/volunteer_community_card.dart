import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/helper/app_helper.dart';
import '../../../../../core/helper/app_number_formatter.dart';
import '../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/chat/data/models/chat_model.dart';
import '../../../../shared/chat/presentation/screens/chat_screen.dart';
import '../../../events/data/models/volunteer_event_details_model.dart';

class VolunteerCommunityCard extends StatelessWidget {
  const VolunteerCommunityCard({super.key, required this.event});

  final VolunteerEventDetailsModel event;

  @override
  Widget build(BuildContext context) {
    final latestMessage = event.latestMessage?['message']?.toString() ?? '';

    final unread = event.unreadChatMessages;

    final joiners = event.joiners;

    final date = event.date;

    final status = event.status.toLowerCase();

    final isEnded = status == 'completed';

    return GestureDetector(
      onTap: () => AppNavigator.push(
        ChatScreen(
          eventId: event.id,
          currentUserId: CacheHelper.get(CacheKeys.profileId),
          event: event.toChatEvent(),
        ),
      ),
      child: Container(
        padding: AppSize.padding(all: 15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: .1),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: AppSize.getSize(40),
                  height: AppSize.getSize(40),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: CustomIcon(
                      icon: AppIcons.chat,
                      color: AppColors.white,
                      width: AppSize.getSize(22),
                      height: AppSize.getSize(22),
                    ),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(10)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              event.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: AppSize.font(15),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          SizedBox(width: AppSize.getWidth(10)),

                          Text(
                            AppHelper.timeAgoShort(date),
                            style: TextStyle(
                              fontSize: AppSize.font(11),
                              color: AppColors.black.withValues(alpha: .55),
                            ),
                          ),

                          SizedBox(width: AppSize.getWidth(10)),

                          Container(
                            padding: AppSize.padding(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: AppColors.primary),
                            ),
                            child: Text(
                              isEnded
                                  ? 'volunteer.community.ended'.tr()
                                  : 'volunteer.community.active'.tr(),
                              style: TextStyle(
                                fontSize: AppSize.font(12),
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary,
                              ),
                            ),
                          ),

                          if (unread > 0) ...[
                            SizedBox(width: AppSize.getWidth(5)),
                            Container(
                              constraints: BoxConstraints(
                                minWidth: AppSize.getSize(20),
                                minHeight: AppSize.getSize(20),
                              ),
                              padding: AppSize.padding(horizontal: 5),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: Text(
                                  unread.toString(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(12),
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      SizedBox(height: AppSize.getHeight(5)),

                      Text(
                        event.creator?['name'] ?? '',
                        style: TextStyle(
                          fontSize: AppSize.font(13),
                          color: AppColors.black.withValues(alpha: .8),
                        ),
                      ),

                      SizedBox(height: AppSize.getHeight(5)),

                      Row(
                        children: [
                          CustomIcon(
                            icon: AppIcons.community,
                            color: AppColors.black.withValues(alpha: .5),
                            width: AppSize.getSize(18),
                            height: AppSize.getSize(18),
                          ),

                          SizedBox(width: AppSize.getWidth(3)),

                          Text(
                            joiners.compact,
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              color: AppColors.black.withValues(alpha: .5),
                            ),
                          ),

                          SizedBox(width: AppSize.getWidth(12)),

                          CustomIcon(
                            icon: AppIcons.events,
                            color: AppColors.black.withValues(alpha: .5),
                            width: AppSize.getSize(18),
                            height: AppSize.getSize(18),
                          ),

                          SizedBox(width: AppSize.getWidth(3)),

                          Text(
                            DateFormat('dd MMM yyyy').format(date),
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              color: AppColors.black.withValues(alpha: .5),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSize.getHeight(6)),

                      Text(
                        latestMessage.isEmpty
                            ? 'volunteer.community.no_messages_yet'.tr()
                            : latestMessage,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppSize.font(13),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

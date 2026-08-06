import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/helper/app_number_formatter.dart';
import '../../data/models/volunteer_event_details_model.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/style/app_colors.dart';

class VolunteerEventDetailsBottomSheet extends StatelessWidget {
  const VolunteerEventDetailsBottomSheet({
    super.key,
    required this.event,
    this.onJoinTap,
    this.showJoinButton = true,
  });

  final VolunteerEventDetailsModel event;
  final VoidCallback? onJoinTap;
  final bool showJoinButton;

  Future<void> _makePhoneCall(String? phone) async {
    if (phone == null || phone.isEmpty) return;

    final Uri uri = Uri(scheme: 'tel', path: phone);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      AppToast.error(
        'volunteer.events.bottom_sheet.cannot_open_phone_app'.tr(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final textColor = colors.onSurface;
    final secondaryColor = textColor.withValues(alpha: .7);

    return SafeArea(
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * .8,
          ),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _EventImage(
                  imageUrl: event.cover,
                  onClose: () => AppNavigator.pop(),
                ),

                Padding(
                  padding: AppSize.padding(all: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event.name, style: _titleStyle(textColor)),

                      SizedBox(height: AppSize.getHeight(10)),

                      Text(
                        event.description,
                        style: _descriptionStyle(textColor),
                      ),

                      _EventDetailsCard(
                        event: event,
                        textColor: textColor,
                        secondaryColor: secondaryColor,

                        onPhoneTap: () {
                          _makePhoneCall(event.creator?['phone']);
                        },

                        onPhoneLongPress: () {
                          Clipboard.setData(
                            ClipboardData(text: event.creator?['phone'] ?? ''),
                          );

                          AppToast.success(
                            'volunteer.events.bottom_sheet.phone_copied'.tr(),
                          );
                        },
                      ),

                      if (showJoinButton) ...[
                        SizedBox(height: AppSize.getHeight(20)),
                        CustomButton(
                          title: event.joined
                              ? 'volunteer.events.bottom_sheet.joined'.tr()
                              : 'volunteer.events.bottom_sheet.join_event'.tr(),
                          icon: event.joined ? AppIcons.check : null,
                          height: AppSize.getHeight(50),
                          bgColor: event.joined
                              ? AppColors.primary.withValues(alpha: .1)
                              : AppColors.primary,
                          textColor: event.joined ? Colors.green : Colors.white,
                          onTap: onJoinTap,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _titleStyle(Color color) {
    return TextStyle(
      fontSize: AppSize.font(20),
      fontWeight: FontWeight.w500,
      color: color,
    );
  }

  TextStyle _descriptionStyle(Color color) {
    return TextStyle(
      fontSize: AppSize.font(15),
      fontWeight: FontWeight.w300,
      color: color,
    );
  }
}

class _EventDetailsCard extends StatelessWidget {
  const _EventDetailsCard({
    required this.event,
    required this.textColor,
    required this.secondaryColor,
    required this.onPhoneTap,
    required this.onPhoneLongPress,
  });

  final VolunteerEventDetailsModel event;
  final Color textColor;
  final Color secondaryColor;

  final VoidCallback onPhoneTap;
  final VoidCallback onPhoneLongPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.padding(all: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        children: [
          _EventDetailItem(
            icon: AppIcons.events,
            title: 'volunteer.events.bottom_sheet.date_time'.tr(),
            value: DateFormat('dd MMM yyyy - hh:mm a', 'en').format(event.date),
            textColor: textColor,
            secondaryColor: secondaryColor,
          ),

          SizedBox(height: AppSize.getHeight(10)),

          _EventDetailItem(
            icon: AppIcons.location,
            title: 'volunteer.events.bottom_sheet.location'.tr(),
            value: [
              event.location?['description'],
              event.location?['city'],
              event.location?['state'],
            ].where((e) => e != null && e.toString().isNotEmpty).join(', '),
            textColor: textColor,
            secondaryColor: secondaryColor,
          ),

          SizedBox(height: AppSize.getHeight(10)),

          _EventDetailItem(
            icon: AppIcons.community,
            title: 'volunteer.events.bottom_sheet.volunteers'.tr(),
            value: 'volunteer.events.bottom_sheet.members'.tr(
              namedArgs: {
                'joined': event.joiners.compact,
                'needed': event.spots.compact,
                'spots': (event.spots - event.joiners).compact,
              },
            ),
            textColor: textColor,
            secondaryColor: secondaryColor,
          ),

          SizedBox(height: AppSize.getHeight(10)),

          _EventDetailItem(
            icon: AppIcons.sparkle,
            title: 'volunteer.events.bottom_sheet.skills'.tr(),
            value: event.skills.isEmpty
                ? 'volunteer.events.bottom_sheet.no_skills_needed'.tr()
                : event.skills.join(', '),
            textColor: textColor,
            secondaryColor: secondaryColor,
          ),

          SizedBox(height: AppSize.getHeight(10)),

          _EventDetailItem(
            icon: AppIcons.profile,
            title: 'volunteer.events.bottom_sheet.contact'.tr(),
            value: event.creator?['name'] ?? '-',
            textColor: textColor,
            secondaryColor: secondaryColor,
          ),

          SizedBox(height: AppSize.getHeight(10)),

          _EventDetailItem(
            icon: AppIcons.phone,
            title: 'volunteer.events.bottom_sheet.phone'.tr(),
            value: event.creator?['phone'] ?? '-',
            isClickable: true,
            onTap: onPhoneTap,
            onLongPress: onPhoneLongPress,
            textColor: textColor,
            secondaryColor: secondaryColor,
          ),

          // SizedBox(height: AppSize.getHeight(10)),
          //
          // _EventDetailItem(
          //   icon: AppIcons.note,
          //   title: 'volunteer.events.bottom_sheet.note'.tr(),
          //   value: '-',
          //   textColor: textColor,
          //   secondaryColor: secondaryColor,
          // ),
        ],
      ),
    );
  }
}

class _EventImage extends StatelessWidget {
  const _EventImage({required this.imageUrl, required this.onClose});

  final String? imageUrl;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: AppSize.getHeight(250),
          width: double.infinity,
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => _buildPlaceholder(context),
                )
              : _buildPlaceholder(context),
        ),

        Positioned(
          top: AppSize.getHeight(16),
          left: AppSize.getWidth(16),
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              padding: AppSize.padding(all: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: .4),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
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
              decoration: const BoxDecoration(
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

class _EventDetailItem extends StatelessWidget {
  const _EventDetailItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.textColor,
    required this.secondaryColor,
    this.isClickable = false,
    this.onTap,
    this.onLongPress,
  });

  final String icon;
  final String title;
  final String value;
  final Color textColor;
  final Color secondaryColor;

  final bool isClickable;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isClickable ? onTap : null,
      onLongPress: isClickable ? onLongPress : null,
      borderRadius: BorderRadius.circular(12),

      child: Padding(
        padding: AppSize.padding(vertical: 4),
        child: Row(
          children: [
            CustomIcon(
              icon: icon,
              color: AppColors.primary,
              width: AppSize.getSize(20),
              height: AppSize.getSize(20),
            ),

            SizedBox(width: AppSize.getWidth(10)),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: AppSize.font(13),
                      color: secondaryColor,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(2)),

                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          value,
                          style: TextStyle(
                            fontSize: AppSize.font(14),
                            color: isClickable ? AppColors.primary : textColor,
                            fontWeight: isClickable
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),

                      if (isClickable)
                        Padding(
                          padding: EdgeInsets.only(left: AppSize.getWidth(6)),
                          child: Icon(
                            Icons.phone,
                            size: AppSize.getSize(16),
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

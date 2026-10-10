import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/emergency_model.dart';
import '../../data/params/emergency_param.dart';
import '../controllers/emergency_cubit.dart';
import '../forms/report_emergency_form.dart';
import '../helpers/emergency_helpers.dart';

class EmergencyDetailsDialog extends StatelessWidget {
  const EmergencyDetailsDialog({
    super.key,
    required this.emergency,
    required this.emergencyCubit,
    required this.isOrg,
    required this.currentUserId,
  });

  final EmergencyModel emergency;
  final EmergencyCubit emergencyCubit;
  final bool isOrg;
  final int? currentUserId;

  // ============================================================
  // Actions
  // ============================================================

  Future<void> _callPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone.trim());

    try {
      final opened = await launchUrl(uri);

      if (!opened) {
        AppToast.error('shared.emergency.card.call_failed'.tr());
      }
    } catch (_) {
      AppToast.error('shared.emergency.card.call_failed'.tr());
    }
  }

  Future<void> _openLocation(String url) async {
    final uri = Uri.tryParse(url.trim());

    if (uri == null) {
      AppToast.error('shared.emergency.card.no_location'.tr());
      return;
    }

    try {
      final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

      if (!opened) {
        AppToast.error('shared.emergency.card.no_location'.tr());
      }
    } catch (_) {
      AppToast.error('shared.emergency.card.no_location'.tr());
    }
  }

  Future<void> _share(EmergencyModel e) async {
    final buffer = StringBuffer()
      ..writeln(e.name)
      ..writeln(e.description);

    if (e.locationText.isNotEmpty) {
      buffer.writeln(e.locationText);
    }

    final url = e.location?.url ?? '';

    if (url.isNotEmpty) {
      buffer.writeln(url);
    }

    if (e.contactPhone.isNotEmpty) {
      buffer.writeln(e.contactPhone);
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString().trim()));

    AppToast.success('shared.emergency.card.copied'.tr());
  }

  // ============================================================
  // Edit Emergency
  // ============================================================

  void _editEmergency(BuildContext context, EmergencyModel e) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => OrganizationEmergencyForm(
          emergencyCubit: emergencyCubit,
          emergency: e,
        ),
      ),
    );
  }

  // ============================================================
  // Toggle Completed Status
  // ============================================================

  Future<void> _setEmergencyCompleted(
    BuildContext context,
    EmergencyModel e,
    bool completed,
  ) async {
    final param = UpdateEmergencyParam.statusOnly(active: !completed);

    final success = await emergencyCubit.updateEmergency(
      e.id,
      param,
      context: context,
    );

    if (!context.mounted) return;

    if (success) {
      AppToast.success('shared.emergency.card.status_updated'.tr());
    } else {
      AppToast.error('shared.emergency.card.status_update_failed'.tr());
    }
  }

  // ============================================================
  // Delete Emergency
  // ============================================================

  void _deleteEmergency(BuildContext context, EmergencyModel e) {
    showDialog<void>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: 'shared.emergency.card.delete_title'.tr(),
        message: 'shared.emergency.card.delete_message'.tr(),
        confirmText: 'shared.emergency.card.delete_confirm'.tr(),
        cancelText: 'shared.emergency.card.delete_cancel'.tr(),
        isDestructive: true,
        onConfirm: () async {
          final success = await emergencyCubit.deleteEmergency(e.id);

          if (!context.mounted) return;

          if (success) {
            AppToast.success('shared.emergency.card.delete_success'.tr());

            AppNavigator.pop();
          } else {
            AppToast.error('shared.emergency.card.delete_failed'.tr());
          }
        },
      ),
    );
  }

  // ============================================================
  // Helpers
  // ============================================================

  Widget _chip(String label, Color color) {
    return Container(
      padding: AppSize.padding(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: AppSize.font(12),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);

    final dialogColor =
        theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface;

    return BlocBuilder<EmergencyCubit, EmergencyState>(
      bloc: emergencyCubit,
      builder: (context, state) {
        final e = emergencyCubit.findById(emergency.id) ?? emergency;

        final urgencyColor = EmergencyHelpers.urgencyColor(e.urgency);

        final location = e.locationText;
        final locationUrl = e.location?.url ?? '';

        final percent = (e.progress * 100).round();

        final isOwner =
            isOrg &&
            (e.creator?.id == currentUserId || emergencyCubit.isMine(e.id));

        final canJoin = !isOrg;
        final hasLocation = locationUrl.isNotEmpty;

        final showActions = !isOwner && (canJoin || hasLocation);

        final isJoining = emergencyCubit.isJoining(e.id);
        final joinDisabled = e.joined || e.isFull || !e.active;

        final joinTitle = e.joined
            ? 'shared.emergency.card.joined'.tr()
            : e.isFull
            ? 'shared.emergency.card.full'.tr()
            : 'shared.emergency.card.join'.tr();

        return Dialog(
          backgroundColor: dialogColor,
          clipBehavior: Clip.antiAlias,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================================================
                // Cover + Badges + Close
                // ==================================================
                SizedBox(
                  height: AppSize.getHeight(190),
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      EmergencyCover(url: e.coverUrl, color: urgencyColor),
                      Positioned(
                        top: AppSize.getHeight(12),
                        left: AppSize.getWidth(12),
                        child: Row(
                          children: [
                            EmergencyBadge(
                              label: EmergencyHelpers.urgencyLabel(e.urgency),
                              color: urgencyColor,
                              icon: AppIcons.siren,
                            ),
                            // SizedBox(width: AppSize.getWidth(8)),
                            // EmergencyBadge(
                            //   label: e.active
                            //       ? 'shared.emergency.card.active'.tr()
                            //       : 'shared.emergency.card.closed'.tr(),
                            //   color: e.active
                            //       ? urgencyColor
                            //       : AppColors.grey800,
                            //   icon: AppIcons.siren,
                            // ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: AppSize.getHeight(10),
                        right: AppSize.getWidth(10),
                        child: GestureDetector(
                          onTap: () => AppNavigator.pop(),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: .85),
                              shape: BoxShape.circle,
                            ),
                            child: CustomIcon(
                              icon: AppIcons.close,
                              color: AppColors.black,
                              width: AppSize.getSize(16),
                              height: AppSize.getSize(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================================================
                // Content
                // ==================================================
                Padding(
                  padding: AppSize.padding(all: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        e.name,
                        style: TextStyle(
                          fontSize: AppSize.font(20),
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),

                      // Creator
                      if ((e.creator?.name ?? '').isNotEmpty) ...[
                        SizedBox(height: AppSize.getHeight(8)),
                        Row(
                          children: [
                            CustomIcon(
                              icon: AppIcons.organization,
                              color: urgencyColor,
                              width: AppSize.getSize(16),
                              height: AppSize.getSize(16),
                            ),
                            SizedBox(width: AppSize.getWidth(6)),
                            Expanded(
                              child: Text(
                                e.creator!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: AppSize.font(15),
                                  fontWeight: FontWeight.w500,
                                  color: urgencyColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      SizedBox(height: AppSize.getHeight(14)),

                      // Time + Location + Category
                      Wrap(
                        spacing: AppSize.getWidth(14),
                        runSpacing: AppSize.getHeight(8),
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIcon(
                                icon: AppIcons.time,
                                color: secondaryColor,
                                width: AppSize.getSize(15),
                                height: AppSize.getSize(15),
                              ),
                              SizedBox(width: AppSize.getWidth(5)),
                              Text(
                                EmergencyHelpers.timeAgo(e.created),
                                style: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: secondaryColor,
                                ),
                              ),
                            ],
                          ),
                          if (location.isNotEmpty)
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: AppSize.getWidth(170),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIcon(
                                    icon: AppIcons.location,
                                    color: secondaryColor,
                                    width: AppSize.getSize(15),
                                    height: AppSize.getSize(15),
                                  ),
                                  SizedBox(width: AppSize.getWidth(5)),
                                  Flexible(
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
                              ),
                            ),
                          _chip(
                            EmergencyHelpers.categoryLabel(e.category),
                            AppColors.primary,
                          ),
                        ],
                      ),

                      SizedBox(height: AppSize.getHeight(14)),

                      // Description
                      Text(
                        e.description,
                        style: TextStyle(
                          fontSize: AppSize.font(15),
                          height: 1.4,
                          color: secondaryColor,
                        ),
                      ),

                      // Skills / Blood Type / Certifications
                      if (e.skills.isNotEmpty ||
                          e.bloodType != null ||
                          e.certifications.isNotEmpty) ...[
                        SizedBox(height: AppSize.getHeight(14)),
                        Wrap(
                          spacing: AppSize.getWidth(8),
                          runSpacing: AppSize.getHeight(8),
                          children: [
                            for (final skill in e.skills)
                              _chip(skill, AppColors.laserBlue),
                            if (e.bloodType != null)
                              _chip(
                                'shared.emergency.card.blood_type'.tr(
                                  args: [e.bloodType!],
                                ),
                                AppColors.red,
                              ),
                            for (final certification in e.certifications)
                              _chip(certification, AppColors.grey800),
                          ],
                        ),
                      ],

                      SizedBox(height: AppSize.getHeight(18)),

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
                            'shared.emergency.card.volunteers'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(15),
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${e.joiners} / ${e.volunteers} ($percent%)',
                            style: TextStyle(
                              fontSize: AppSize.font(15),
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSize.getHeight(10)),

                      EmergencyProgressBar(
                        progress: e.progress,
                        color: urgencyColor,
                        height: AppSize.getHeight(8),
                      ),

                      // Phone
                      if (e.contactPhone.isNotEmpty) ...[
                        SizedBox(height: AppSize.getHeight(18)),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () => _callPhone(e.contactPhone),
                          child: Padding(
                            padding: AppSize.padding(vertical: 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIcon(
                                  icon: AppIcons.phone,
                                  color: secondaryColor,
                                  width: AppSize.getSize(18),
                                  height: AppSize.getSize(18),
                                ),
                                SizedBox(width: AppSize.getWidth(10)),
                                Text(
                                  EmergencyHelpers.formatPhone(e.contactPhone),
                                  style: TextStyle(
                                    fontSize: AppSize.font(15),
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],

                      SizedBox(height: AppSize.getHeight(14)),

                      Divider(
                        thickness: .5,
                        height: 1,
                        color: theme.dividerColor,
                      ),

                      SizedBox(height: AppSize.getHeight(16)),

                      // ==================================================
                      // Join + Location
                      // ==================================================
                      if (showActions)
                        Row(
                          children: [
                            if (canJoin)
                              Expanded(
                                child: Opacity(
                                  opacity: joinDisabled ? .5 : 1,
                                  child: CustomButton(
                                    loading: isJoining,
                                    title: joinTitle,
                                    height: AppSize.getHeight(45),
                                    bgColor: urgencyColor,
                                    onTap: joinDisabled || isJoining
                                        ? null
                                        : () => emergencyCubit.joinEmergency(
                                            e.id,
                                          ),
                                  ),
                                ),
                              ),
                            if (canJoin && hasLocation)
                              SizedBox(width: AppSize.getWidth(10)),
                            if (hasLocation)
                              Expanded(
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(30),
                                  onTap: () => _openLocation(locationUrl),
                                  child: Container(
                                    height: AppSize.getHeight(45),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: AppColors.primary,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.near_me_outlined,
                                          color: AppColors.primary,
                                          size: AppSize.getSize(18),
                                        ),
                                        SizedBox(width: AppSize.getWidth(6)),
                                        Text(
                                          'shared.emergency.card.location'.tr(),
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: AppSize.font(14),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),

                      // ==================================================
                      // Owner Actions: Completed + Edit + Delete
                      // ==================================================
                      if (isOwner) ...[
                        Container(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: .45),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                e.active
                                    ? Icons.radio_button_unchecked_rounded
                                    : Icons.check_circle_rounded,
                                color: e.active ? urgencyColor : Colors.green,
                                size: AppSize.getSize(22),
                              ),
                              SizedBox(width: AppSize.getWidth(10)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'shared.emergency.card.completed'.tr(),
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: AppSize.font(14),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: AppSize.getHeight(2)),
                                    Text(
                                      e.active
                                          ? 'shared.emergency.card.mark_completed'
                                                .tr()
                                          : 'shared.emergency.card.completed_message'
                                                .tr(),
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontSize: AppSize.font(11),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: !e.active,
                                activeTrackColor: Colors.green,
                                onChanged: (completed) {
                                  _setEmergencyCompleted(context, e, completed);
                                },
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: AppSize.getHeight(15)),

                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                title: 'shared.emergency.card.manage'.tr(),
                                height: AppSize.getHeight(40),
                                icon: AppIcons.edit,
                                iconSize: AppSize.getSize(18),
                                bgColor: AppColors.primary,
                                textColor: AppColors.white,
                                onTap: () => _editEmergency(context, e),
                              ),
                            ),
                            SizedBox(width: AppSize.getWidth(10)),
                            Expanded(
                              child: CustomButton(
                                title: 'shared.emergency.card.delete'.tr(),
                                height: AppSize.getHeight(40),
                                icon: AppIcons.delete,
                                iconSize: AppSize.getSize(18),
                                borderColor: AppColors.red,
                                bgColor: Colors.transparent,
                                textColor: AppColors.red,
                                onTap: () => _deleteEmergency(context, e),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // ==================================================
                      // Share
                      // ==================================================
                      SizedBox(
                        height: AppSize.getHeight(
                          showActions || isOwner ? 8 : 0,
                        ),
                      ),

                      Center(
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _share(e),
                          child: Padding(
                            padding: AppSize.padding(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIcon(
                                  icon: AppIcons.share,
                                  color: textColor,
                                  width: AppSize.getSize(16),
                                  height: AppSize.getSize(16),
                                ),
                                SizedBox(width: AppSize.getWidth(8)),
                                Text(
                                  'shared.emergency.card.share'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(15),
                                    fontWeight: FontWeight.w500,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

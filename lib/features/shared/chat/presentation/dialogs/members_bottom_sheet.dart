import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/features/shared/chat/data/enums/member_role_enum.dart';
import 'package:sanad_app/features/shared/chat/data/models/members_model.dart';

import '../../../../../core/style/app_colors.dart';

class MembersBottomSheet extends StatelessWidget {
  const MembersBottomSheet({super.key});

  // ── Data ──────────────────────────────────────────────────────────────────

  static const _admin = [
    MembersModel(
      name: 'Sanad Team',
      subtitle: 'Online now',
      isOnline: true,
      avatarColor: AppColors.primary,
      role: MemberRoleEnum.admin,
    ),
  ];

  static const _organizers = [
    MembersModel(
      name: 'Dr. Karim Sayed',
      subtitle: 'Red Crescent',
      isOnline: false,
      avatarColor: AppColors.bronze,
      role: MemberRoleEnum.organizer,
    ),
  ];

  static const _volunteers = [
    MembersModel(
      name: 'Ahmed Mohamed',
      isOnline: true,
      avatarColor: AppColors.grey500,
      role: MemberRoleEnum.volunteer,
    ),
    MembersModel(
      name: 'Nour Ali',
      isOnline: true,
      avatarColor: AppColors.grey500,
      role: MemberRoleEnum.volunteer,
    ),
    MembersModel(
      name: 'Omar Khaled',
      isOnline: false,
      avatarColor: AppColors.grey500,
      role: MemberRoleEnum.volunteer,
    ),
    MembersModel(
      name: 'Sara Hassan',
      isOnline: true,
      avatarColor: AppColors.grey500,
      role: MemberRoleEnum.volunteer,
    ),
    MembersModel(
      name: 'Yara Saad',
      isOnline: false,
      avatarColor: AppColors.grey500,
      role: MemberRoleEnum.volunteer,
    ),
    MembersModel(
      name: 'Mohamed Tarek',
      isOnline: true,
      avatarColor: AppColors.grey500,
      role: MemberRoleEnum.volunteer,
    ),
  ];

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const MembersBottomSheet(),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final total = _admin.length + _organizers.length + _volunteers.length;

    return DraggableScrollableSheet(
      initialChildSize: 0.60,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: AppSize.getHeight(10)),
              Container(
                width: AppSize.getWidth(40),
                height: AppSize.getHeight(4),
                decoration: BoxDecoration(
                  color: AppColors.grey500,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: AppSize.getHeight(14)),
              // Header
              Padding(
                padding: AppSize.padding(horizontal: 25),
                child: Row(
                  children: [
                    Text(
                      'Members ($total)',
                      style: TextStyle(
                        fontSize: AppSize.font(18),
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.grey500,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: CustomIcon(
                          icon: AppIcons.close,
                          color: AppColors.grey500,
                          width: AppSize.getSize(16),
                          height: AppSize.getSize(16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSize.getHeight(6)),

              Divider(
                color: AppColors.grey.withValues(alpha: 0.2),
                thickness: 1,
              ),

              // List
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: AppSize.padding(horizontal: 16, vertical: 8),
                  children: [
                    _buildSectionLabel('ADMIN'),
                    ..._admin.map(_buildMemberTile),

                    SizedBox(height: AppSize.getHeight(10)),
                    _buildSectionLabel('ORGANIZER'),
                    ..._organizers.map(_buildMemberTile),

                    SizedBox(height: AppSize.getHeight(10)),
                    _buildSectionLabel('VOLUNTEERS (${_volunteers.length})'),
                    ..._volunteers.map(_buildMemberTile),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ── Section label ─────────────────────────────────────────────────────────

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: AppSize.padding(bottom: 8, top: 4),
      child: Text(
        label,
        style: TextStyle(
          fontSize: AppSize.font(11),
          fontWeight: FontWeight.w600,
          color: AppColors.grey500,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  // ── Member tile ───────────────────────────────────────────────────────────

  Widget _buildMemberTile(MembersModel m) {
    return Padding(
      padding: AppSize.padding(vertical: 7),
      child: Row(
        children: [
          // Avatar with online dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppSize.getSize(44),
                height: AppSize.getSize(44),
                decoration: BoxDecoration(
                  color: m.role == MemberRoleEnum.volunteer
                      ? Color(0xFFF5F5F7)
                      : m.avatarColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  m.avatarLetter,
                  style: TextStyle(
                    color: m.role == MemberRoleEnum.volunteer
                        ? AppColors.black
                        : AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.font(17),
                  ),
                ),
              ),
              if (m.isOnline)
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    width: AppSize.getSize(11),
                    height: AppSize.getSize(11),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(width: AppSize.getWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.name,
                  style: TextStyle(
                    fontSize: AppSize.font(14.5),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(width: AppSize.getWidth(2)),

                Text(
                  m.statusText,
                  style: TextStyle(
                    fontSize: AppSize.font(12.5),
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          if (m.role == MemberRoleEnum.admin)
            _buildBadge(
              label: 'Admin',
              icon: AppIcons.check,
              color: AppColors.white,
              bg: AppColors.primary,
            ),
          if (m.role == MemberRoleEnum.organizer)
            _buildBadge(
              label: 'Organizer',
              icon: AppIcons.crown,
              color: AppColors.white,
              bg: AppColors.bronze,
            ),
        ],
      ),
    );
  }

  // ── Badge ─────────────────────────────────────────────────────────────────

  Widget _buildBadge({
    required String label,
    required String icon,
    required Color color,
    required Color bg,
  }) {
    return Container(
      padding: AppSize.padding(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIcon(
            icon: icon,
            color: color,
            width: AppSize.getSize(14),
            height: AppSize.getSize(14),
          ),
          SizedBox(width: AppSize.getWidth(4)),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.font(12),
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

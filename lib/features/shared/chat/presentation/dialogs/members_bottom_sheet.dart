import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/features/shared/chat/data/enums/member_role_enum.dart';
import 'package:sanad_app/features/shared/chat/data/models/member_model.dart';

import '../../../../../core/style/app_colors.dart';
import '../../data/repos/chat_repo.dart';
import '../controllers/members_cubit.dart';

class MembersBottomSheet extends StatefulWidget {
  final int eventId;
  final int? organizerId; // 👈 جديد
  final String? organizerName;
  final String? organizerSubtitle;
  final Set<int> onlineUserIds;
  final bool isOrganizer;

  const MembersBottomSheet({
    super.key,
    required this.eventId,
    this.organizerId, // 👈 جديد
    this.organizerName,
    this.organizerSubtitle,
    this.onlineUserIds = const {},
    this.isOrganizer = false,
  });

  static Future<void> show(
      BuildContext context, {
        required int eventId,
        int? organizerId, // 👈 جديد
        String? organizerName,
        String? organizerSubtitle,
        Set<int> onlineUserIds = const {},
        bool isOrganizer = false,
      }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MembersBottomSheet(
        eventId: eventId,
        organizerId: organizerId,
        // 👈 جديد
        organizerName: organizerName,
        organizerSubtitle: organizerSubtitle,
        onlineUserIds: onlineUserIds,
        isOrganizer: isOrganizer,
      ),
    );
  }

  @override
  State<MembersBottomSheet> createState() => _MembersBottomSheetState();
}

class _MembersBottomSheetState extends State<MembersBottomSheet> {
  late final MembersCubit _membersCubit;
  final ScrollController _scrollController = ScrollController();

  int? _editingMemberId;
  final TextEditingController _roleController = TextEditingController();

  // ── Dark mode helpers ───────────────────────────────────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  // خلفية الشيت (بديل AppColors.white)
  Color get _surfaceColor => Theme.of(context).cardColor;

  // نص أساسي (بديل AppColors.black)
  Color get _primaryTextColor =>
      Theme.of(context).textTheme.bodyLarge?.color ?? AppColors.black;

  // نص ثانوي (بديل AppColors.grey500)
  Color get _secondaryTextColor =>
      Theme.of(context).textTheme.bodySmall?.color ?? AppColors.grey500;

  // فواصل / بوردرات (بديل AppColors.grey500 / grey)
  Color get _dividerColor => Theme.of(context).dividerColor;

  // خلفية أفاتار الفوليونتير الفاتحة (كانت 0xFFF5F5F7)
  Color get _volunteerAvatarBg =>
      _isDark ? const Color(0xFF3A3A3C) : const Color(0xFFF5F5F7);

  @override
  void initState() {
    super.initState();
    _membersCubit = MembersCubit(
      chatRepo: ChatRepoImpel(),
      eventId: widget.eventId,
    )..loadMembers();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _roleController.dispose();
    _membersCubit.close();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 100) {
      _membersCubit.loadMoreMembers();
    }
  }

  void _startEditingRole(MemberModel member) {
    setState(() {
      _editingMemberId = member.id;
      _roleController.text = member.role;
    });
  }

  void _confirmEditingRole(MemberModel member) {
    final newRole = _roleController.text.trim();

    setState(() {
      _editingMemberId = null;
    });

    if (newRole.isEmpty || newRole == member.role) return;

    _membersCubit.updateMemberRole(memberId: member.id, newRole: newRole);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final hasOrganizer =
        widget.organizerName != null && widget.organizerName!.trim().isNotEmpty;

    final isOrganizerOnline =
        widget.organizerId != null &&
            widget.onlineUserIds.contains(widget.organizerId);

    return BlocProvider.value(
      value: _membersCubit,
      child: DraggableScrollableSheet(
        initialChildSize: 0.60,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: _surfaceColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: AppSize.getHeight(10)),
                Container(
                  width: AppSize.getWidth(40),
                  height: AppSize.getHeight(4),
                  decoration: BoxDecoration(
                    color: _dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(14)),

                // Header
                BlocBuilder<MembersCubit, MembersState>(
                  builder: (context, state) {
                    final volunteersCount = state is MembersLoaded
                        ? state.totalCount
                        : 0;
                    final total = 1 + (hasOrganizer ? 1 : 0) + volunteersCount;

                    return Padding(
                      padding: AppSize.padding(horizontal: 25),
                      child: Row(
                        children: [
                          Text(
                            'Members ($total)',
                            style: TextStyle(
                              fontSize: AppSize.font(18),
                              fontWeight: FontWeight.w700,
                              color: _primaryTextColor,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _dividerColor,
                                  width: 1.5,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: CustomIcon(
                                icon: AppIcons.close,
                                color: _secondaryTextColor,
                                width: AppSize.getSize(16),
                                height: AppSize.getSize(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                SizedBox(height: AppSize.getHeight(6)),
                Divider(
                  color: _dividerColor,
                  thickness: 1,
                ),

                // List
                Expanded(
                  child: BlocBuilder<MembersCubit, MembersState>(
                    builder: (context, state) {
                      if (state is MembersLoading || state is MembersInitial) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is MembersError) {
                        return Center(
                          child: Padding(
                            padding: AppSize.padding(all: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: _secondaryTextColor),
                                ),
                                SizedBox(height: AppSize.getHeight(10)),
                                GestureDetector(
                                  onTap: () => _membersCubit.retry(),
                                  child: Text(
                                    'shared.chat.retry'.tr(),
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      final loaded = state as MembersLoaded;

                      return ListView(
                        controller: _scrollController,
                        padding: AppSize.padding(horizontal: 16, vertical: 8),
                        children: [
                          _buildSectionLabel('ADMIN'),
                          _buildStaticTile(
                            name: 'Sanad Team',
                            subtitle: 'Online now',
                            isOnline: true,
                            avatarColor: AppColors.primary,
                            role: MemberRoleEnum.admin,
                          ),

                          if (hasOrganizer) ...[
                            SizedBox(height: AppSize.getHeight(10)),
                            _buildSectionLabel('ORGANIZER'),
                            _buildStaticTile(
                              name: widget.organizerName!,
                              subtitle: widget.organizerSubtitle,
                              isOnline: isOrganizerOnline,
                              avatarColor: AppColors.bronze,
                              role: MemberRoleEnum.organizer,
                            ),
                          ],

                          SizedBox(height: AppSize.getHeight(10)),
                          _buildSectionLabel(
                            'VOLUNTEERS (${loaded.volunteers.length})',
                          ),
                          ...loaded.volunteers.map(_buildMemberTile),

                          if (loaded.isLoadingMore)
                            Padding(
                              padding: AppSize.padding(vertical: 14),
                              child: const Center(
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
          color: _secondaryTextColor,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  // ── Static tile (Sanad Team / Organizer) ────────────────────────────────

  Widget _buildStaticTile({
    required String name,
    String? subtitle,
    required bool isOnline,
    required Color avatarColor,
    required MemberRoleEnum role,
  }) {
    return _buildTile(
      name: name,
      statusText: subtitle ?? (isOnline ? 'Online now' : 'Offline'),
      isOnline: isOnline,
      avatarColor: avatarColor,
      role: role,
      avatarLetter: name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?',
    );
  }

  // ── Member tile (from API) ──────────────────────────────────────────────

  Widget _buildMemberTile(MemberModel m) {
    final isOnline = widget.onlineUserIds.contains(m.userId);
    final isEditing = _editingMemberId == m.id;

    return _buildTile(
      name: m.volunteerName,
      statusText: m.role.trim(),
      isOnline: isOnline,
      avatarColor: AppColors.grey500,
      role: m.roleEnum,
      avatarLetter: m.avatarLetter,
      isEditing: isEditing,
      showRoleAsBadge: true,
      trailing: widget.isOrganizer
          ? GestureDetector(
        onTap: () =>
        isEditing ? _confirmEditingRole(m) : _startEditingRole(m),
        child: Padding(
          padding: AppSize.padding(all: 4),
          child: isEditing
              ? Container(
            width: AppSize.getSize(26),
            height: AppSize.getSize(26),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: CustomIcon(
              icon: AppIcons.check,
              color: AppColors.white,
              width: AppSize.getSize(18),
              height: AppSize.getSize(18),
            ),
          )
              : CustomIcon(
            icon: AppIcons.edit,
            color: _secondaryTextColor,
            width: AppSize.getSize(18),
            height: AppSize.getSize(18),
          ),
        ),
      )
          : null,
    );
  }

  // ── Shared tile UI ───────────────────────────────────────────────────────

  Widget _buildTile({
    required String name,
    required String statusText,
    required bool isOnline,
    required Color avatarColor,
    required MemberRoleEnum role,
    required String avatarLetter,
    bool isEditing = false,
    bool showRoleAsBadge = false,
    Widget? trailing,
  }) {
    final hasStatusText = statusText.trim().isNotEmpty;

    return Padding(
      padding: AppSize.padding(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with online dot
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppSize.getSize(44),
                height: AppSize.getSize(44),
                decoration: BoxDecoration(
                  color: role == MemberRoleEnum.volunteer
                      ? _volunteerAvatarBg
                      : avatarColor,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  avatarLetter,
                  style: TextStyle(
                    color: role == MemberRoleEnum.volunteer
                        ? _primaryTextColor
                        : AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.font(17),
                  ),
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 2,
                  right: -1,
                  child: Container(
                    width: AppSize.getSize(15),
                    height: AppSize.getSize(15),
                    decoration: BoxDecoration(
                      color: AppColors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: _surfaceColor, width: 2),
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
                  name,
                  style: TextStyle(
                    fontSize: AppSize.font(14.5),
                    fontWeight: FontWeight.w600,
                    color: _primaryTextColor,
                  ),
                ),
                if (isEditing) ...[
                  SizedBox(height: AppSize.getHeight(6)),
                  TextField(
                    controller: _roleController,
                    autofocus: true,
                    style: TextStyle(
                      fontSize: AppSize.font(13),
                      color: _primaryTextColor,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'shared.chat.role_hint'.tr(),
                      hintStyle: TextStyle(
                        fontSize: AppSize.font(13),
                        color: _secondaryTextColor,
                      ),
                      contentPadding: AppSize.padding(
                        horizontal: 14,
                        vertical: 9,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ] else if (hasStatusText) ...[
                  SizedBox(height: AppSize.getHeight(6)),
                  showRoleAsBadge
                      ? _buildBadge(
                    label: statusText,
                    icon: AppIcons.tag,
                    color: AppColors.bronze,
                    bg: AppColors.bronze.withValues(
                      alpha: _isDark ? 0.28 : 0.2,
                    ),
                  )
                      : Text(
                    statusText,
                    style: TextStyle(
                      fontSize: AppSize.font(12.5),
                      color: _secondaryTextColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (!isEditing && role == MemberRoleEnum.admin)
            _buildBadge(
              label: 'Admin',
              icon: AppIcons.check,
              color: AppColors.white,
              bg: AppColors.primary,
            ),
          if (!isEditing && role == MemberRoleEnum.organizer)
            _buildBadge(
              label: 'Organizer',
              icon: AppIcons.crown,
              color: AppColors.white,
              bg: AppColors.bronze,
            ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  // ── Badge (Admin / Organizer) ───────────────────────────────────────────

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

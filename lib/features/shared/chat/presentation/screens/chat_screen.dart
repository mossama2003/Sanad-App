import 'dart:ui';

import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

import '../../../../volunteer/community/presentation/controllers/volunteer_community_cubit.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/style/app_colors.dart';
import '../dialogs/report_chat_bottom_sheet.dart';
import '../dialogs/members_bottom_sheet.dart';
import '../../data/models/chat_model.dart';
import '../../data/repos/chat_repo.dart';
import '../controllers/chat_cubit.dart';

class ChatScreen extends StatefulWidget {
  final int eventId;
  final int currentUserId;
  final ChatEventModel event;

  const ChatScreen({
    super.key,
    required this.eventId,
    required this.currentUserId,
    required this.event,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _pinnedExpanded = false;
  bool _isFirstLoad = true;
  double? _prevMaxScrollExtent;
  bool _showScrollToBottom = false;
  bool _isLoadingMore = false;
  bool _showEmojiPicker = false;
  bool _isSendingLocation = false;
  ChatModel? _editingMessage;

  final GlobalKey _moreButtonKey = GlobalKey();
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  static final List<PinnedMessage> _pinned = [
    PinnedMessage(
      title: "shared.chat.pinned.welcome_title".tr(),
      body: "shared.chat.pinned.welcome_body".tr(),
      icon: AppIcons.community,
      color: AppColors.primary,
    ),

    PinnedMessage(
      title: "shared.chat.pinned.guidelines_title".tr(),
      body: "shared.chat.pinned.guidelines_body".tr(),
      icon: AppIcons.info,
      color: AppColors.laserBlue,
    ),

    PinnedMessage(
      title: "shared.chat.pinned.help_title".tr(),
      body: "shared.chat.pinned.help_body".tr(),
      icon: AppIcons.sparkle,
      color: AppColors.bronze,
    ),
  ];

  // final List<String> _reactions = ["👍", "❤️", "😂", "😮", "😢", "🙏"];

  late final ChatCubit _chatCubit;

  @override
  void initState() {
    super.initState();

    _chatCubit = ChatCubit(
      chatRepo: ChatRepoImpel(),
      eventId: widget.eventId,
      currentUserId: widget.currentUserId,
      // currentUserName هتاخد القيمة الافتراضية 'You' مؤقتًا
    )..initChat();

    _loadCurrentUserName(); // 👈 جديد

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _messageController.dispose();
    _messageFocusNode.dispose();
    _chatCubit.close();
    super.dispose();
  }

  Future<void> _loadCurrentUserName() async {
    final appCubit = AppCubit.get(context);

    var user = appCubit.user;
    user ??= await appCubit.getUser();

    if (!mounted) return;

    final name = user?.name;
    if (name != null && name.trim().isNotEmpty) {
      _chatCubit.updateCurrentUserName(name);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final position = _scrollController.position;

    if (position.pixels <= position.minScrollExtent + 80) {
      if (!_isLoadingMore) {
        _isLoadingMore = true;

        _prevMaxScrollExtent = position.maxScrollExtent;

        _chatCubit.loadMoreHistory();
      }
    }

    final shouldShow = position.maxScrollExtent - position.pixels > 300;

    if (shouldShow != _showScrollToBottom) {
      setState(() {
        _showScrollToBottom = shouldShow;
      });
    }
  }

  // void _showReactionPicker(
  //   BuildContext context,
  //   Offset position,
  //   ChatModel msg,
  // ) {
  //   final overlay = Overlay.of(context);
  //
  //   late OverlayEntry entry;
  //
  //   entry = OverlayEntry(
  //     builder: (_) {
  //       return Positioned.fill(
  //         child: Material(
  //           color: Colors.transparent,
  //           child: Stack(
  //             children: [
  //               Positioned.fill(
  //                 child: GestureDetector(
  //                   behavior: HitTestBehavior.translucent,
  //                   onTap: () {
  //                     if (entry.mounted) entry.remove();
  //                   },
  //                   child: Container(color: Colors.transparent),
  //                 ),
  //               ),
  //               Positioned(
  //                 left: position.dx - 100,
  //                 top: position.dy - 65,
  //                 child: Material(
  //                   color: Colors.transparent,
  //                   child: TweenAnimationBuilder(
  //                     duration: const Duration(milliseconds: 160),
  //                     tween: Tween(begin: .9, end: 1.0),
  //                     builder: (context, scale, child) {
  //                       return Transform.scale(scale: scale, child: child);
  //                     },
  //                     child: Container(
  //                       padding: AppSize.padding(horizontal: 6, vertical: 5),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(32),
  //                         boxShadow: [
  //                           BoxShadow(
  //                             color: Colors.black.withValues(alpha: .10),
  //                             blurRadius: 18,
  //                             offset: const Offset(0, 3),
  //                           ),
  //                         ],
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: _reactions.map((emoji) {
  //                           final selected = msg.reactionEmoji == emoji;
  //
  //                           return GestureDetector(
  //                             onTap: () {
  //                               setState(() {
  //                                 if (selected) {
  //                                   msg.reactionEmoji = null;
  //                                   msg.reactionCount = 0;
  //                                 } else {
  //                                   msg.reactionEmoji = emoji;
  //                                   msg.reactionCount = 1;
  //                                 }
  //                               });
  //                               if (entry.mounted) entry.remove();
  //                             },
  //                             child: AnimatedContainer(
  //                               duration: const Duration(milliseconds: 150),
  //                               margin: AppSize.margin(horizontal: 1),
  //                               padding: AppSize.padding(all: 5),
  //                               decoration: BoxDecoration(
  //                                 color: selected
  //                                     ? Colors.grey.withValues(alpha: .16)
  //                                     : Colors.transparent,
  //                                 borderRadius: BorderRadius.circular(100),
  //                               ),
  //                               child: AnimatedScale(
  //                                 duration: const Duration(milliseconds: 150),
  //                                 scale: selected ? 1.12 : 1,
  //                                 child: Text(
  //                                   emoji,
  //                                   style: TextStyle(
  //                                     fontSize: AppSize.font(22),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ),
  //                           );
  //                         }).toList(),
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  //
  //   overlay.insert(entry);
  //   Future.delayed(const Duration(seconds: 5), () {
  //     if (entry.mounted) entry.remove();
  //   });
  // }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _toggleEmojiPicker() {
    if (_showEmojiPicker) {
      setState(() => _showEmojiPicker = false);
      _messageFocusNode.requestFocus();
    } else {
      _messageFocusNode.unfocus();
      setState(() => _showEmojiPicker = true);
    }
  }

  void _onEmojiSelected(Category? category, Emoji emoji) {
    final text = _messageController.text;
    final selection = _messageController.selection;

    final cursorPos = selection.start >= 0 ? selection.start : text.length;

    final newText = text.replaceRange(cursorPos, cursorPos, emoji.emoji);

    _messageController.text = newText;
    _messageController.selection = TextSelection.collapsed(
      offset: cursorPos + emoji.emoji.length,
    );
  }

  Future<void> _sendCurrentLocation() async {
    if (_isSendingLocation) return;

    setState(() => _isSendingLocation = true);

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppToast.error('shared.chat.location_service_disabled'.tr());
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          AppToast.error('shared.chat.location_permission_denied'.tr());
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        AppToast.error('shared.chat.location_permission_denied_forever'.tr());
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final locationUrl =
          'https://www.google.com/maps?q=${position.latitude},${position.longitude}';

      _chatCubit.sendMessage(locationUrl);
      _scrollToBottom();
    } catch (_) {
      AppToast.error('shared.chat.location_fetch_failed'.tr());
    } finally {
      if (mounted) setState(() => _isSendingLocation = false);
    }
  }

  void _onBackspacePressed() {
    _messageController.text = _messageController.text.characters
        .skipLast(1)
        .toString();
    _messageController.selection = TextSelection.fromPosition(
      TextPosition(offset: _messageController.text.length),
    );
  }

  void _showMessageActions(ChatModel msg) {
    if (msg.senderName != 'You' || msg.status != ChatMessageStatus.sent) return;
    if (msg.id == null) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'dismiss',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim, secondaryAnim, child) {
        return GestureDetector(
          onTap: () => AppNavigator.pop(),
          behavior: HitTestBehavior.opaque,
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 8 * anim.value,
              sigmaY: 8 * anim.value,
            ),
            child: Container(
              color: AppColors.black.withValues(alpha: 0.25 * anim.value),
              child: Center(
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    type: MaterialType.transparency,
                    child: ScaleTransition(
                      scale: CurvedAnimation(
                        parent: anim,
                        curve: Curves.easeOutBack,
                        reverseCurve: Curves.easeIn,
                      ),
                      child: FadeTransition(
                        opacity: anim,
                        child: _buildMessageActionsSheet(msg),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionBar(ChatLoaded state) {
    return Container(
      color: AppColors.white,
      padding: AppSize.padding(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _chatCubit.exitSelectionMode(),
            child: Center(
              child: CustomIcon(
                icon: AppIcons.close,
                color: AppColors.black,
                width: AppSize.getSize(24),
                height: AppSize.getSize(24),
              ),
            ),
          ),
          SizedBox(width: AppSize.getWidth(14)),
          Expanded(
            child: Text(
              'shared.chat.selected_count'.tr(
                namedArgs: {'count': '${state.selectedMessageIds.length}'},
              ),
              style: TextStyle(
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
          ),
          GestureDetector(
            onTap: () =>
                _confirmDeleteSelected(state.selectedMessageIds.length),
            child: Center(
              child: CustomIcon(
                icon: AppIcons.delete,
                color: AppColors.red,
                width: AppSize.getSize(24),
                height: AppSize.getSize(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteMessage(ChatModel msg) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'shared.chat.delete_message'.tr(),
        message: 'shared.chat.delete_confirm'.tr(),
        confirmText: 'shared.chat.delete_message'.tr(),
        cancelText: 'shared.chat.cancel'.tr(),
        isDestructive: true,
        onConfirm: () => _chatCubit.deleteSingleMessage(msg.id!),
      ),
    );
  }

  void _confirmDeleteSelected(int count) {
    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'shared.chat.delete_message'.tr(),
        message: 'shared.chat.delete_selected_confirm'.tr(
          namedArgs: {'count': '$count'},
        ),
        confirmText: 'shared.chat.delete_message'.tr(),
        cancelText: 'shared.chat.cancel'.tr(),
        isDestructive: true,
        onConfirm: () => _chatCubit.deleteSelectedMessages(),
      ),
    );
  }

  void _startEditingMessage(ChatModel msg) {
    setState(() {
      _editingMessage = msg;
      _messageController.text = msg.text;
      _messageController.selection = TextSelection.collapsed(
        offset: msg.text.length,
      );
    });
    _messageFocusNode.requestFocus();
  }

  void _cancelEditing() {
    setState(() {
      _editingMessage = null;
      _messageController.clear();
    });
  }

  Future<void> _openLink(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        AppToast.error('shared.chat.link_open_failed'.tr());
      }
    } catch (_) {
      AppToast.error('shared.chat.link_open_failed'.tr());
    }
  }

  Widget _buildScrollToBottomButton() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: !_showScrollToBottom
          ? const SizedBox.shrink()
          : GestureDetector(
              onTap: _jumpToBottom,
              child: Container(
                padding: AppSize.padding(all: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: .15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: CustomIcon(
                    icon: AppIcons.arrowDown,
                    color: AppColors.white,
                    width: AppSize.getSize(15),
                    height: AppSize.getSize(15),
                  ),
                ),
              ),
            ),
    );
  }

  void _onSendPressed() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_editingMessage != null) {
      final messageId = _editingMessage!.id!;
      _chatCubit.editMessage(messageId: messageId, newText: text);

      setState(() => _editingMessage = null);
      _messageController.clear();
      return;
    }

    _chatCubit.sendMessage(text);
    _messageController.clear();
    _scrollToBottom();
  }

  String _dateDividerLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);

    final diff = today.difference(target).inDays;

    if (diff == 0) return 'shared.chat.today'.tr();
    if (diff == 1) return 'shared.chat.yesterday'.tr();

    if (diff < 7) {
      return DateFormat('EEEE').format(date);
    }

    return DateFormat('d MMM yyyy').format(date);
  }

  void _showChatOptionsMenu(BuildContext context) {
    final RenderBox button =
        _moreButtonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(
          Offset(0, button.size.height + 6),
          ancestor: overlay,
        ),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + const Offset(0, 6),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final userRole = AppCubit.get(context).user?.role;
    final isVolunteer = userRole == 'volunteer';

    showMenu<String>(
      context: context,
      position: position,
      color: AppColors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      constraints: BoxConstraints(minWidth: AppSize.getWidth(220)),
      items: [
        _buildMenuItem(
          value: 'mute_notifications',
          icon: AppIcons.muteNotification,
          label: 'shared.chat.mute_notifications'.tr(),
        ),
        _buildMenuItem(
          value: 'search_messages',
          icon: AppIcons.search,
          label: 'shared.chat.search_messages'.tr(),
        ),
        _buildMenuItem(
          value: 'share_invite',
          icon: AppIcons.share,
          label: 'shared.chat.share_invite'.tr(),
        ),
        const PopupMenuDivider(
          height: 12,
          thickness: 0.2,
          endIndent: 15,
          indent: 15,
        ),
        _buildMenuItem(
          value: 'report_chat',
          icon: AppIcons.flag,
          label: 'shared.chat.report_chat'.tr(),
          color: AppColors.red,
        ),
        if (isVolunteer)
          _buildMenuItem(
            value: 'leave_chat',
            icon: AppIcons.signOut,
            label: 'shared.chat.leave_chat'.tr(),
            color: AppColors.red,
          ),
      ],
    ).then((selected) {
      if (selected == null) return;
      _handleChatOption(selected);
    });
  }

  PopupMenuItem<String> _buildMenuItem({
    required String value,
    required String icon,
    required String label,
    Color? color,
  }) {
    return PopupMenuItem<String>(
      value: value,
      height: 44,
      child: Row(
        children: [
          CustomIcon(
            icon: icon,
            color: color ?? AppColors.grey700,
            width: AppSize.getSize(18),
            height: AppSize.getSize(18),
          ),
          SizedBox(width: AppSize.getWidth(12)),
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.font(13.5),
              fontWeight: FontWeight.w500,
              color: color ?? AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  void _handleChatOption(String option) {
    switch (option) {
      case 'mute_notifications':
        AppToast.success('shared.chat.muted_success'.tr());
        break;

      case 'search_messages':
        break;

      case 'share_invite':

        /// TODO Share APP LINK
        // Share.share(
        //   'shared.chat.invite_message'.tr(
        //     namedArgs: {'eventName': widget.event.name},
        //   ),
        // );
        break;

      case 'report_chat':
        AppNavigator.sheet(
          ReportChatBottomSheet(
            onReport: (reason) {
              _chatCubit.reportEvent(reason);
            },
          ),
        );
        break;

      case 'leave_chat':
        _confirmLeaveChat();
        break;
    }
  }

  void _confirmLeaveChat() {
    final communityCubit = context.read<VolunteerCommunityCubit>();

    showDialog(
      context: context,
      builder: (context) => ConfirmDialog(
        title: 'shared.chat.leave_chat'.tr(),
        message: 'shared.chat.leave_confirm'.tr(),
        confirmText: 'shared.chat.leave_chat'.tr(),
        cancelText: 'shared.chat.cancel'.tr(),
        isDestructive: true,
        onConfirm: () async {
          final success = await _chatCubit.leaveEvent();

          if (!success) return;

          await communityCubit.removeCommunity(_chatCubit.eventId);

          if (!mounted) return;

          AppNavigator.pop();
        },
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _chatCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F7),
        body: SafeArea(
          child: BlocBuilder<ChatCubit, ChatState>(
            buildWhen: (previous, current) =>
                current is ChatLoaded &&
                (previous is! ChatLoaded ||
                    previous.isSelectionMode != current.isSelectionMode ||
                    previous.selectedMessageIds.length !=
                        current.selectedMessageIds.length),
            builder: (context, state) {
              final isSelectionMode =
                  state is ChatLoaded && state.isSelectionMode;

              return Column(
                children: [
                  if (isSelectionMode)
                    _buildSelectionBar(state)
                  else ...[
                    _buildAppBar(context, state),
                    _buildEventBanner(),
                    _buildPinnedSection(),
                  ],
                  Expanded(
                    child: Stack(
                      children: [
                        BlocConsumer<ChatCubit, ChatState>(
                          listener: (context, state) {
                            if (state is ChatError) {
                              AppToast.error(state.message);
                              return;
                            }

                            if (state is! ChatLoaded) return;

                            if (_prevMaxScrollExtent != null &&
                                !state.isLoadingMore) {
                              final oldExtent = _prevMaxScrollExtent!;
                              _prevMaxScrollExtent = null;
                              _isLoadingMore = false;

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!_scrollController.hasClients) return;

                                final newExtent =
                                    _scrollController.position.maxScrollExtent;

                                final diff = newExtent - oldExtent;

                                if (diff > 0) {
                                  _scrollController.jumpTo(
                                    _scrollController.offset + diff,
                                  );
                                }
                              });

                              return;
                            }

                            if (_isFirstLoad &&
                                state.messages.isNotEmpty &&
                                !state.isSyncing) {
                              _isFirstLoad = false;

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (!_scrollController.hasClients) return;

                                _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent,
                                );
                              });

                              return;
                            }

                            if (!_showScrollToBottom) {
                              _scrollToBottom();
                            }
                          },
                          builder: (context, state) {
                            if (state is ChatLoading || state is ChatInitial) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (state is ChatError) {
                              return _buildErrorState(state.message);
                            }

                            final chatState = state as ChatLoaded;

                            if (chatState.messages.isEmpty &&
                                !chatState.isSyncing &&
                                !chatState.isLoadingMore) {
                              return _buildEmptyState();
                            }

                            return SingleChildScrollView(
                              controller: _scrollController,
                              child: Column(
                                children: [
                                  if (chatState.isSyncing)
                                    _buildSyncingBanner(),
                                  if (chatState.isLoadingMore)
                                    Padding(
                                      padding: AppSize.padding(vertical: 10),
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
                                  ..._buildMessagesWithDividers(chatState),
                                  SizedBox(height: AppSize.getHeight(12)),
                                ],
                              ),
                            );
                          },
                        ),
                        Positioned(
                          right: 16,
                          bottom: 20,
                          child: _buildScrollToBottomButton(),
                        ),
                      ],
                    ),
                  ),
                  if (!isSelectionMode) _buildMessageInput(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return BlocProvider.value(
  //     value: _chatCubit,
  //     child: Scaffold(
  //       backgroundColor: const Color(0xFFF5F5F7),
  //       body: SafeArea(
  //         child: Column(
  //           children: [
  //             _buildAppBar(context),
  //             _buildEventBanner(),
  //             _buildPinnedSection(),
  //
  //             Expanded(
  //               child: Stack(
  //                 children: [
  //                   BlocConsumer<ChatCubit, ChatState>(
  //                     listener: (context, state) {
  //                       if (state is ChatError) {
  //                         AppToast.error(state.message);
  //                         return;
  //                       }
  //
  //                       if (state is! ChatLoaded) return;
  //
  //                       // ==========================
  //                       // تحميل رسائل قديمة فوق
  //                       // ==========================
  //                       if (_prevMaxScrollExtent != null &&
  //                           !state.isLoadingMore) {
  //                         final oldExtent = _prevMaxScrollExtent!;
  //                         _prevMaxScrollExtent = null;
  //                         _isLoadingMore = false;
  //
  //                         WidgetsBinding.instance.addPostFrameCallback((_) {
  //                           if (!_scrollController.hasClients) return;
  //
  //                           final newExtent =
  //                               _scrollController.position.maxScrollExtent;
  //
  //                           final diff = newExtent - oldExtent;
  //
  //                           if (diff > 0) {
  //                             _scrollController.jumpTo(
  //                               _scrollController.offset + diff,
  //                             );
  //                           }
  //                         });
  //
  //                         return;
  //                       }
  //
  //                       // ==========================
  //                       // أول دخول للشات
  //                       // ==========================
  //                       if (_isFirstLoad &&
  //                           state.messages.isNotEmpty &&
  //                           !state.isSyncing) {
  //                         _isFirstLoad = false;
  //
  //                         WidgetsBinding.instance.addPostFrameCallback((_) {
  //                           if (!_scrollController.hasClients) return;
  //
  //                           _scrollController.jumpTo(
  //                             _scrollController.position.maxScrollExtent,
  //                           );
  //                         });
  //
  //                         return;
  //                       }
  //
  //                       // ==========================
  //                       // رسالة جديدة فقط
  //                       // ==========================
  //                       if (!_showScrollToBottom) {
  //                         _scrollToBottom();
  //                       }
  //                     },
  //                     builder: (context, state) {
  //                       if (state is ChatLoading || state is ChatInitial) {
  //                         return const Center(
  //                           child: CircularProgressIndicator(),
  //                         );
  //                       }
  //
  //                       if (state is ChatError) {
  //                         return _buildErrorState(state.message);
  //                       }
  //
  //                       final chatState = state as ChatLoaded;
  //
  //                       if (chatState.messages.isEmpty &&
  //                           !chatState.isSyncing &&
  //                           !chatState.isLoadingMore) {
  //                         return _buildEmptyState();
  //                       }
  //
  //                       return SingleChildScrollView(
  //                         controller: _scrollController,
  //                         child: Column(
  //                           children: [
  //                             if (chatState.isSyncing) _buildSyncingBanner(),
  //                             if (chatState.isLoadingMore)
  //                               Padding(
  //                                 padding: AppSize.padding(vertical: 10),
  //                                 child: const Center(
  //                                   child: SizedBox(
  //                                     width: 20,
  //                                     height: 20,
  //                                     child: CircularProgressIndicator(
  //                                       strokeWidth: 2,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ),
  //                             ..._buildMessagesWithDividers(chatState.messages),
  //                             SizedBox(height: AppSize.getHeight(12)),
  //                           ],
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                   Positioned(
  //                     right: 16,
  //                     bottom: 20,
  //                     child: _buildScrollToBottomButton(),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             _buildMessageInput(),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ── AppBar ───────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context, ChatState outerState) {
    return Container(
      color: AppColors.white,
      padding: AppSize.padding(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          CustomIcon(
            icon: AppIcons.arrowBack,
            color: AppColors.black,
            onTap: () => AppNavigator.pop(),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Container(
            width: AppSize.getWidth(40),
            height: AppSize.getHeight(40),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              widget.event.name.trim().isNotEmpty
                  ? widget.event.name.trim()[0].toUpperCase()
                  : '',
              style: TextStyle(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
                fontSize: AppSize.font(18),
              ),
            ),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.event.name,
                  style: TextStyle(
                    fontSize: AppSize.font(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(1)),
                BlocBuilder<ChatCubit, ChatState>(
                  buildWhen: (previous, current) =>
                      current is ChatLoaded &&
                      (previous is! ChatLoaded ||
                          previous.onlineCount != current.onlineCount ||
                          previous.totalMembersCount !=
                              current.totalMembersCount ||
                          previous.isPresenceReady != current.isPresenceReady),
                  builder: (context, state) {
                    final online = state is ChatLoaded ? state.onlineCount : 0;
                    final total = state is ChatLoaded
                        ? state.totalMembersCount +
                              2 // 👈 إضافة الـ 2 هنا
                        : 0;
                    final isReady =
                        state is ChatLoaded && state.isPresenceReady;

                    return Text(
                      isReady
                          ? 'shared.chat.online_members_count'.tr(
                              namedArgs: {
                                'online': '$online',
                                'total': '$total',
                              },
                            )
                          : 'shared.chat.members_count_only'.tr(
                              namedArgs: {'total': '$total'},
                            ),
                      style: TextStyle(
                        fontSize: AppSize.font(12),
                        color: AppColors.grey500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          CustomIcon(
            icon: AppIcons.community,
            color: AppColors.grey600,
            onTap: () {
              final currentState = _chatCubit.state;
              final onlineIds = currentState is ChatLoaded
                  ? currentState.onlineUserIds
                  : <int>{};

              final userRole = AppCubit.get(context).user?.role;
              final isOrganizer =
                  userRole == 'organization' || userRole == 'admin';

              MembersBottomSheet.show(
                context,
                eventId: widget.eventId,
                organizerName: widget.event.organizerName,
                onlineUserIds: onlineIds,
                isOrganizer: isOrganizer,
              );
            },
          ),
          SizedBox(width: AppSize.getWidth(10)),
          CustomIcon(
            key: _moreButtonKey,
            icon: AppIcons.more,
            color: AppColors.grey600,
            onTap: () => _showChatOptionsMenu(context),
          ),
        ],
      ),
    );
  }

  // ── Event Banner ─────────────────────────────────────────────────────────

  Widget _buildEventBanner() {
    return Container(
      color: AppColors.white,
      child: Column(
        children: [
          Padding(
            padding: AppSize.padding(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: AppSize.getSize(36),
                  height: AppSize.getSize(36),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: CustomIcon(
                    icon: AppIcons.sparkle,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppSize.getWidth(10)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event.name,
                        style: TextStyle(
                          fontSize: AppSize.font(13),
                          fontWeight: FontWeight.w600,
                          color: AppColors.black,
                        ),
                      ),
                      SizedBox(height: AppSize.getHeight(2)),
                      Text(
                        DateFormat(
                          'MMM d, yyyy • h:mm a',
                          context.locale.languageCode,
                        ).format(widget.event.date),
                        style: TextStyle(
                          fontSize: AppSize.font(11),
                          color: AppColors.grey500,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () =>
                      _chatCubit.showEventDetails(context, widget.eventId),
                  child: Container(
                    padding: AppSize.padding(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'shared.chat.view_event'.tr(),
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: AppSize.font(13),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // _buildPinnedSection(),
        ],
      ),
    );
  }

  // ── Error State ──────────────────────────────────────────────────────────

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: AppSize.padding(all: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIcon(
              icon: AppIcons.info,
              color: AppColors.grey500,
              width: AppSize.getSize(40),
              height: AppSize.getSize(40),
            ),
            SizedBox(height: AppSize.getHeight(10)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSize.font(13),
                color: AppColors.grey500,
              ),
            ),
            SizedBox(height: AppSize.getHeight(14)),
            GestureDetector(
              onTap: () => _chatCubit.initChat(),
              child: Container(
                padding: AppSize.padding(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'shared.chat.retry'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Pinned Section ─────────────────────────────────────────────────────────

  Widget _buildPinnedSection() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _pinnedExpanded = !_pinnedExpanded;
        });
      },
      child: Container(
        margin: AppSize.margin(all: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: AppSize.padding(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  CustomIcon(
                    icon: AppIcons.pin,
                    color: AppColors.primary,
                    width: AppSize.getSize(15),
                    height: AppSize.getSize(15),
                  ),
                  SizedBox(width: AppSize.getWidth(8)),
                  Text(
                    'Pinned messages',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: AppSize.getSize(15),
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(width: AppSize.getWidth(8)),
                  Container(
                    padding: AppSize.padding(horizontal: 11),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_pinned.length}',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: AppSize.font(13),
                      ),
                    ),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: _pinnedExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: CustomIcon(
                      icon: AppIcons.arrowDown,
                      color: AppColors.grey500,
                      width: AppSize.getSize(12),
                      height: AppSize.getSize(12),
                    ),
                  ),
                ],
              ),
            ),
            ClipRect(
              child: AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOutCubic,
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: _pinnedExpanded
                      ? const BoxConstraints()
                      : const BoxConstraints(maxHeight: 0),
                  child: Column(
                    children: _pinned.map((p) => _buildPinnedCard(p)).toList(),
                  ),
                ),
              ),
            ),
            SizedBox(height: AppSize.getHeight(4)),
          ],
        ),
      ),
    );
  }

  Widget _buildPinnedCard(PinnedMessage p) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: AppSize.padding(all: 14),
      decoration: BoxDecoration(
        color: p.color.withValues(alpha: 0.1),
        border: Border.all(color: p.color.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSize.getSize(36),
            height: AppSize.getSize(36),
            decoration: BoxDecoration(color: p.color, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: CustomIcon(
              icon: p.icon,
              color: AppColors.white,
              width: AppSize.getSize(18),
              height: AppSize.getSize(18),
            ),
          ),
          SizedBox(width: AppSize.getWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.title,
                  style: TextStyle(
                    color: p.color,
                    fontWeight: FontWeight.w700,
                    fontSize: AppSize.font(13.5),
                  ),
                ),
                SizedBox(height: AppSize.getWidth(4)),
                Text(
                  p.body,
                  style: TextStyle(
                    fontSize: AppSize.font(11),
                    color: AppColors.black,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Date Divider ─────────────────────────────────────────────────────────

  Widget _buildDateDivider(String label) {
    return Padding(
      padding: AppSize.padding(vertical: 12),
      child: Row(
        children: [
          SizedBox(width: AppSize.getWidth(16)),
          Expanded(child: Divider(color: AppColors.grey500, thickness: 1)),
          Padding(
            padding: AppSize.padding(horizontal: 12),
            child: Text(
              label,
              style: TextStyle(
                fontSize: AppSize.font(12),
                color: AppColors.grey500,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: AppColors.grey500, thickness: 1)),
          SizedBox(width: AppSize.getWidth(16)),
        ],
      ),
    );
  }

  List<Widget> _buildMessagesWithDividers(ChatLoaded chatState) {
    final widgets = <Widget>[];
    DateTime? lastDate;
    String? lastSenderName;

    for (int i = 0; i < chatState.messages.length; i++) {
      final msg = chatState.messages[i];
      final msgDate = DateTime(
        msg.createdAt.year,
        msg.createdAt.month,
        msg.createdAt.day,
      );

      final isNewDay = lastDate == null || msgDate != lastDate;

      if (isNewDay) {
        widgets.add(_buildDateDivider(_dateDividerLabel(msg.createdAt)));
        lastDate = msgDate;
        lastSenderName = null;
      }

      final isFirstInGroup = lastSenderName != msg.senderName;

      widgets.add(
        _buildChatMessage(
          msg,
          isFirstInGroup: isFirstInGroup,
          isSelectionMode: chatState.isSelectionMode,
          isSelected:
              msg.id != null && chatState.selectedMessageIds.contains(msg.id),
        ),
      );

      lastSenderName = msg.senderName;
    }

    return widgets;
  }

  // ── Chat Message ─────────────────────────────────────────────────────────

  Widget _buildAvatar(ChatModel msg) {
    return Container(
      width: AppSize.getSize(38),
      height: AppSize.getSize(38),
      decoration: BoxDecoration(color: msg.avatarColor, shape: BoxShape.circle),
      alignment: Alignment.center,
      child: Text(
        msg.avatarLetter,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: AppSize.font(16),
        ),
      ),
    );
  }

  Widget _buildChatMessage(
    ChatModel msg, {
    required bool isFirstInGroup,
    bool isSelectionMode = false,
    bool isSelected = false,
  }) {
    final bool isSanad = msg.badge == 'Sanad Admin';
    final bool isMe = msg.senderName == 'You';
    final bool isSelectable = isSelectionMode && isMe && msg.id != null;

    final bubbleColor = isMe
        ? AppColors.primary
        : (isSanad ? const Color(0xFFD6F5EC) : Colors.white);

    final textColor = isMe ? Colors.white : AppColors.black;

    return GestureDetector(
      onTap: isSelectionMode
          ? () {
              if (!isSelectable) return;
              _chatCubit.toggleMessageSelection(msg.id!, isOwnMessage: isMe);
            }
          : null,
      child: Container(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.06)
            : Colors.transparent,
        padding: AppSize.padding(
          horizontal: 14,
          top: isFirstInGroup ? 8 : 2,
          bottom: isFirstInGroup ? 0 : 0,
        ),
        child: Row(
          mainAxisAlignment: isMe
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (isSelectionMode && isMe) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (isFirstInGroup) ...[
                    Opacity(opacity: 0, child: _buildNameBadgeRow(msg, isMe)),
                    SizedBox(height: AppSize.getHeight(5)),
                  ],
                  Padding(
                    padding: AppSize.padding(top: 6),
                    child: Icon(
                      isSelected
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      size: 20,
                      color: isSelected ? AppColors.primary : AppColors.grey500,
                    ),
                  ),
                ],
              ),
              SizedBox(width: AppSize.getWidth(8)),
            ],
            if (!isMe) ...[
              isFirstInGroup
                  ? _buildAvatar(msg)
                  : SizedBox(width: AppSize.getSize(38)),
              SizedBox(width: AppSize.getWidth(10)),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (isFirstInGroup) ...[
                    _buildNameBadgeRow(msg, isMe),
                    SizedBox(height: AppSize.getHeight(5)),
                  ],
                  GestureDetector(
                    onLongPress: () => _showMessageActions(msg),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: AppSize.padding(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: bubbleColor,
                            border: Border.all(color: AppColors.grey300),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: Radius.circular(isMe ? 20 : 10),
                              bottomRight: Radius.circular(isMe ? 10 : 20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Linkify(
                                text: msg.text,
                                onOpen: (link) => _openLink(link.url),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                options: const LinkifyOptions(humanize: true),
                                style: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: textColor,
                                  fontWeight: FontWeight.w600,
                                  height: 1.5,
                                ),
                                linkStyle: TextStyle(
                                  fontSize: AppSize.font(13),
                                  color: isMe
                                      ? AppColors.white
                                      : AppColors.laserBlue,
                                  height: 1.5,
                                  decoration: TextDecoration.underline,
                                  decorationColor: isMe
                                      ? AppColors.white
                                      : AppColors.laserBlue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: AppSize.getHeight(4)),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    DateFormat(
                                      'hh:mm a',
                                      'en_US',
                                    ).format(msg.createdAt),
                                    style: TextStyle(
                                      fontSize: AppSize.font(10),
                                      color: isMe
                                          ? Colors.white.withValues(alpha: 0.75)
                                          : AppColors.grey500,
                                    ),
                                  ),
                                  if (msg.isEdited) ...[
                                    SizedBox(width: AppSize.getWidth(4)),
                                    Text(
                                      'shared.chat.edited'.tr(),
                                      style: TextStyle(
                                        fontSize: AppSize.font(9),
                                        fontStyle: FontStyle.italic,
                                        color: isMe
                                            ? Colors.white70
                                            : AppColors.grey500,
                                      ),
                                    ),
                                  ],
                                  if (msg.status ==
                                      ChatMessageStatus.sending) ...[
                                    SizedBox(width: AppSize.getWidth(4)),
                                    SizedBox(
                                      width: 9,
                                      height: 9,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 1.3,
                                        color: isMe
                                            ? Colors.white70
                                            : AppColors.grey500,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),

                        if (msg.reactionEmoji != null)
                          Padding(
                            padding: AppSize.padding(top: 6),
                            child: _buildReaction(msg),
                          ),

                        if (msg.status == ChatMessageStatus.failed)
                          Padding(
                            padding: AppSize.padding(top: 4),
                            child: GestureDetector(
                              onTap: () =>
                                  _chatCubit.retryMessage(msg.localId!),
                              behavior: HitTestBehavior.opaque,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomIcon(
                                    icon: AppIcons.info,
                                    color: AppColors.red,
                                    width: AppSize.getSize(12),
                                    height: AppSize.getSize(12),
                                  ),
                                  SizedBox(width: AppSize.getWidth(2)),
                                  Text(
                                    'shared.chat.tap_to_retry'.tr(),
                                    style: TextStyle(
                                      fontSize: AppSize.font(10),
                                      color: AppColors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSize.getHeight(4)),
                ],
              ),
            ),
            if (isMe) ...[
              SizedBox(width: AppSize.getWidth(10)),
              isFirstInGroup
                  ? _buildAvatar(msg)
                  : SizedBox(width: AppSize.getSize(38)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNameBadgeRow(ChatModel msg, bool isMe) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMe)
          Text(
            msg.senderName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppSize.font(12),
              color: AppColors.black,
            ),
          ),
        if (!isMe && msg.badge != null) ...[
          SizedBox(width: AppSize.getWidth(6)),
          _buildBadge(msg),
        ],
        if (isMe) ...[
          if (msg.badge != null) _buildBadge(msg),
          SizedBox(width: AppSize.getWidth(6)),
          Text(
            msg.senderName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppSize.font(13),
              color: AppColors.black,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBadge(ChatModel msg) {
    return Container(
      padding: AppSize.padding(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: msg.badgeColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (msg.badgeIcon != null)
            CustomIcon(
              icon: msg.badgeIcon!,
              color: msg.badgeTextColor ?? AppColors.white,
              width: AppSize.getSize(11),
              height: AppSize.getSize(11),
            ),

          if (msg.badgeIcon != null) SizedBox(width: AppSize.getWidth(3)),

          Text(
            msg.badge ?? '',
            style: TextStyle(
              fontSize: AppSize.font(11),
              color: msg.badgeTextColor ?? AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReaction(ChatModel msg) {
    return Container(
      padding: AppSize.padding(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: .05), blurRadius: 6),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            msg.reactionEmoji!,
            style: TextStyle(fontSize: AppSize.font(15)),
          ),
          if (msg.reactionCount > 0)
            Padding(
              padding: const EdgeInsets.only(left: 3),
              child: Text(
                "${msg.reactionCount}",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: AppSize.font(12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Column(
      children: [
        if (_editingMessage != null) _buildEditingBanner(),
        _buildTypingIndicator(),
        Container(
          padding: AppSize.padding(horizontal: 12, bottom: 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: _toggleEmojiPicker,
                child: Padding(
                  padding: AppSize.padding(all: 6),
                  child: CustomIcon(
                    icon: _showEmojiPicker ? AppIcons.keyboard : AppIcons.emoji,
                    color: AppColors.grey600,
                    width: AppSize.getSize(23),
                    height: AppSize.getSize(23),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _sendCurrentLocation,
                child: Padding(
                  padding: AppSize.padding(all: 6),
                  child: _isSendingLocation
                      ? SizedBox(
                          width: AppSize.getSize(24),
                          height: AppSize.getSize(24),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                      : CustomIcon(
                          icon: AppIcons.location,
                          color: AppColors.grey600,
                          width: AppSize.getSize(24),
                          height: AppSize.getSize(24),
                        ),
                ),
              ),
              Expanded(
                child: CustomFieldText(
                  controller: _messageController,
                  focusNode: _messageFocusNode,
                  hintText: 'shared.chat.write_message'.tr(),
                  onChanged: (_) => _chatCubit.notifyTyping(),
                  onTap: () {
                    if (_showEmojiPicker) {
                      setState(() => _showEmojiPicker = false);
                    }
                  },
                ),
              ),
              SizedBox(width: AppSize.getWidth(10)),
              GestureDetector(
                onTap: _onSendPressed,
                child: Container(
                  width: AppSize.getSize(42),
                  height: AppSize.getSize(42),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomIcon(
                      icon: AppIcons.send,
                      color: AppColors.white,
                      width: AppSize.getSize(22),
                      height: AppSize.getSize(22),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        Offstage(
          offstage: !_showEmojiPicker,
          child: SizedBox(
            height: 250,
            child: EmojiPicker(
              onEmojiSelected: _onEmojiSelected,
              onBackspacePressed: _onBackspacePressed,
              config: Config(
                height: 250,
                emojiViewConfig: EmojiViewConfig(
                  columns: 8,
                  emojiSizeMax: 28,
                  backgroundColor: AppColors.white,
                ),
                categoryViewConfig: CategoryViewConfig(
                  indicatorColor: AppColors.primary,
                  iconColorSelected: AppColors.primary,
                  backgroundColor: AppColors.white,
                ),
                bottomActionBarConfig: const BottomActionBarConfig(
                  enabled: false,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTypingIndicator() {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (previous, current) =>
          current is ChatLoaded &&
          (previous is! ChatLoaded ||
              previous.typingUsers != current.typingUsers),
      builder: (context, state) {
        if (state is! ChatLoaded || state.typingUsers.isEmpty) {
          return const SizedBox.shrink();
        }

        final names = state.typingUsers.values.toList();
        final text = names.length == 1
            ? 'shared.chat.one_typing'.tr(namedArgs: {'name': names.first})
            : 'shared.chat.multiple_typing'.tr();

        return Padding(
          padding: AppSize.padding(horizontal: 16, bottom: 4),
          child: Row(
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: AppColors.grey500,
                ),
              ),
              SizedBox(width: AppSize.getWidth(6)),
              Text(
                text,
                style: TextStyle(
                  fontSize: AppSize.font(11),
                  fontStyle: FontStyle.italic,
                  color: AppColors.grey500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppSize.padding(all: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: AppSize.getSize(70),
              height: AppSize.getSize(70),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: CustomIcon(
                icon: AppIcons.chat,
                color: AppColors.primary,
                width: AppSize.getSize(32),
                height: AppSize.getSize(32),
              ),
            ),
            SizedBox(height: AppSize.getHeight(14)),
            Text(
              'shared.chat.no_messages_title'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w600,
                color: AppColors.black,
              ),
            ),
            SizedBox(height: AppSize.getHeight(6)),
            Text(
              'shared.chat.no_messages_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppSize.font(13),
                color: AppColors.grey500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncingBanner() {
    return Padding(
      padding: AppSize.padding(vertical: 8, horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: AppColors.grey500,
            ),
          ),
          SizedBox(width: AppSize.getWidth(6)),
          Text(
            'shared.chat.syncing_messages'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(11),
              color: AppColors.grey500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageActionsSheet(ChatModel msg) {
    return Padding(
      padding: AppSize.padding(horizontal: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: AppSize.getWidth(280)),
            padding: AppSize.padding(horizontal: 18, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              msg.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: AppSize.font(16),
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: AppSize.getHeight(14)),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionTile(
                  icon: AppIcons.edit,
                  label: 'shared.chat.edit_message'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _startEditingMessage(msg);
                  },
                ),
                Divider(height: 1, color: AppColors.grey300),
                _buildActionTile(
                  icon: AppIcons.check,
                  label: 'shared.chat.select_messages'.tr(),
                  onTap: () {
                    Navigator.pop(context);
                    _chatCubit.enterSelectionMode(msg.id!);
                  },
                ),
                Divider(height: 1, color: AppColors.grey300),
                _buildActionTile(
                  icon: AppIcons.delete,
                  label: 'shared.chat.delete_message'.tr(),
                  color: AppColors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDeleteMessage(msg);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: AppSize.padding(horizontal: 18, vertical: 14),
        child: Row(
          children: [
            CustomIcon(
              icon: icon,
              color: color ?? AppColors.black,
              width: AppSize.getSize(20),
              height: AppSize.getSize(20),
            ),
            SizedBox(width: AppSize.getWidth(12)),
            Text(
              label,
              style: TextStyle(
                fontSize: AppSize.font(14),
                fontWeight: FontWeight.w500,
                color: color ?? AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditingBanner() {
    return Container(
      padding: AppSize.padding(horizontal: 20, vertical: 12),
      color: AppColors.primary.withValues(alpha: 0.08),
      child: Row(
        children: [
          CustomIcon(
            icon: AppIcons.edit,
            width: AppSize.getSize(20),
            height: AppSize.getSize(20),
          ),
          SizedBox(width: AppSize.getWidth(6)),
          Expanded(
            child: Text(
              'shared.chat.editing_message'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(12),
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          GestureDetector(
            onTap: _cancelEditing,
            child: CustomIcon(
              icon: AppIcons.close,
              color: AppColors.grey600,
              width: AppSize.getSize(20),
              height: AppSize.getSize(20),
            ),
          ),
        ],
      ),
    );
  }
}

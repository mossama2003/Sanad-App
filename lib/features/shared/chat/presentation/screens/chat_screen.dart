import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/style/app_colors.dart';
import '../../data/models/chat_model.dart';
import 'members.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _pinnedExpanded = true;

  // ── Data ────────────────────────────────────────────────────────────────────

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  static final List<PinnedMessage> _pinned = [
    PinnedMessage(
      title: 'Welcome to Beach Cleanup Drive 👋',
      body:
          "So glad you're here! This community brings together everyone joining Beach Cleanup Drive. Say hi, ask questions, and let's make this event amazing together.",
      icon: AppIcons.donations,
      color: AppColors.primary,
    ),
    PinnedMessage(
      title: 'Quick Guidance',
      body:
          'Arrive 15 minutes early • Bring your ID for QR check-in • Wear comfortable clothes • Coordinate carpooling here if you can.',
      icon: AppIcons.info,
      color: AppColors.laserBlue,
    ),
    PinnedMessage(
      title: 'Community Notes',
      body:
          'Be kind & respectful • No spam or promotions • Use channels to coordinate not chat • Admins are always around if you need help.',
      icon: AppIcons.sparkle,
      color: AppColors.bronze,
    ),
  ];

  static final _messages = [
    ChatModel(
      senderName: 'Sanad Team',
      badge: 'Sanad Admin',
      badgeColor: AppColors.primary,
      badgeIcon: AppIcons.check,
      text:
          "Hi everyone! 👋 I'm here from Sanad if you need any help or have feedback about the event.",
      time: '9:00 AM',
      avatarColor: Color(0xFF3DAB8E),
      avatarLetter: 'S',
    ),
    ChatModel(
      senderName: 'Layla Mostafa',
      badge: 'Organizer',
      badgeColor: AppColors.bronze,
      badgeIcon: AppIcons.crown,
      text:
          "Hello team! Excited to have you all on board for the Beach Cleanup Drive. I'll share location pin tonight.",
      time: '9:12 AM',
      avatarColor: Color(0xFFE8824A),
      avatarLetter: 'L',
    ),
    ChatModel(
      senderName: 'Nour Ali',
      text: 'So excited! Is there parking nearby?',
      time: '9:24 AM',
      avatarColor: Color(0xFF718096),
      avatarLetter: 'N',
      reactionEmoji: '❤️',
      reactionCount: 2,
    ),
    ChatModel(
      senderName: 'Layla Mostafa',
      badge: 'Organizer',
      badgeColor: AppColors.bronze,
      badgeIcon: AppIcons.crown,
      text: "Yes, free parking at the main entrance. I'll add a map shortly.",
      time: '9:31 AM',
      avatarColor: Color(0xFFE8824A),
      avatarLetter: 'L',
    ),
  ];

  final List<String> _reactions = ["👍", "❤️", "😂", "😮", "😢", "🙏"];

  void _showReactionPicker(
    BuildContext context,
    Offset position,
    ChatModel msg,
  ) {
    final overlay = Overlay.of(context);

    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) {
        return Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (entry.mounted) {
                        entry.remove();
                      }
                    },
                    child: Container(color: Colors.transparent),
                  ),
                ),

                // 👇 البوب أب نفسه
                Positioned(
                  left: position.dx - 100,
                  top: position.dy - 65,
                  child: Material(
                    color: Colors.transparent,
                    child: TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 160),
                      tween: Tween(begin: .9, end: 1.0),
                      builder: (context, scale, child) {
                        return Transform.scale(scale: scale, child: child);
                      },
                      child: Container(
                        padding: AppSize.padding(horizontal: 6, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: .10),
                              blurRadius: 18,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: _reactions.map((emoji) {
                            final selected = msg.reactionEmoji == emoji;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selected) {
                                    msg.reactionEmoji = null;
                                    msg.reactionCount = 0;
                                  } else {
                                    msg.reactionEmoji = emoji;
                                    msg.reactionCount = 1;
                                  }
                                });

                                if (entry.mounted) {
                                  entry.remove();
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: AppSize.margin(horizontal: 1),
                                padding: AppSize.padding(all: 5),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? Colors.grey.withValues(alpha: .16)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: AnimatedScale(
                                  duration: const Duration(milliseconds: 150),
                                  scale: selected ? 1.12 : 1,
                                  child: Text(
                                    emoji,
                                    style: TextStyle(
                                      fontSize: AppSize.font(22),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 5), () {
      if (entry.mounted) {
        entry.remove();
      }
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

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            _buildEventBanner(),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    _buildPinnedSection(),
                    _buildDateDivider('Today'),
                    ..._messages.map(_buildChatMessage),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  // ── AppBar ───────────────────────────────────────────────────────────────────

  Widget _buildAppBar(BuildContext context) {
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
          // Avatar
          Container(
            width: AppSize.getWidth(40),
            height: AppSize.getHeight(40),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              'B',
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
                  'Beach Cleanup Drive',
                  style: TextStyle(
                    fontSize: AppSize.font(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(1)),
                Text(
                  '6 online • 8 members',
                  style: TextStyle(
                    fontSize: AppSize.font(12),
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          CustomIcon(
            icon: AppIcons.community,
            color: AppColors.grey600,
            onTap: () {
              MembersBottomSheet.show(context);
            },
          ),
          SizedBox(width: AppSize.getWidth(10)),
          CustomIcon(
            icon: AppIcons.more,
            color: AppColors.grey600,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // ── Event Banner ─────────────────────────────────────────────────────────────

  Widget _buildEventBanner() {
    return Container(
      color: AppColors.white,
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
            child: CustomIcon(icon: AppIcons.sparkle, color: AppColors.primary),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Green Earth Foundation',
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    fontWeight: FontWeight.w600,
                    color: AppColors.black,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(2)),
                Text(
                  'Dec 15, 2025 • 9:00 AM',
                  style: TextStyle(
                    fontSize: AppSize.font(11),
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: AppSize.padding(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'View Event',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: AppSize.font(13),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Pinned Section ─────────────────────────────────────────────────────────

  Widget _buildPinnedSection() {
    return Container(
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
          GestureDetector(
            onTap: () {
              setState(() {
                _pinnedExpanded = !_pinnedExpanded;
              });
            },
            child: Padding(
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
          ),

          // Expandable Content
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

  // ── Date Divider ─────────────────────────────────────────────────────────────

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

  // ── Chat Message ─────────────────────────────────────────────────────────────

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

  Widget _buildChatMessage(ChatModel msg) {
    final bool isSanad = msg.badge == 'Sanad Admin';
    final bool isMe = msg.senderName == 'You';

    final bubbleColor = isMe
        ? AppColors.primary
        : (isSanad ? const Color(0xFFD6F5EC) : Colors.white);

    final textColor = isMe ? Colors.white : AppColors.black;

    return Padding(
      padding: AppSize.padding(horizontal: 14, vertical: 8),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) _buildAvatar(msg),

          if (!isMe) SizedBox(width: AppSize.getWidth(10)),

          Flexible(
            child: Column(
              crossAxisAlignment: isMe
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                // NAME + BADGE
                Row(
                  mainAxisAlignment: isMe
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Text(
                        msg.senderName,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: AppSize.font(13),
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
                ),

                SizedBox(height: AppSize.getHeight(5)),

                // BUBBLE
                GestureDetector(
                  onLongPressStart: (details) {
                    _showReactionPicker(context, details.globalPosition, msg);
                  },
                  child: Column(
                    crossAxisAlignment: isMe
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: AppSize.padding(horizontal: 14, vertical: 11),
                        decoration: BoxDecoration(
                          color: bubbleColor,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(18),
                            topRight: const Radius.circular(18),
                            bottomLeft: Radius.circular(isMe ? 18 : 4),
                            bottomRight: Radius.circular(isMe ? 4 : 18),
                          ),
                        ),
                        child: Text(
                          msg.text,
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: textColor,
                            height: 1.5,
                          ),
                        ),
                      ),

                      // REACTIONS
                      if (msg.reactionEmoji != null)
                        Padding(
                          padding: AppSize.padding(top: 6),
                          child: _buildReaction(msg),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: AppSize.getHeight(4)),

                Text(
                  msg.time,
                  style: TextStyle(
                    fontSize: AppSize.font(11),
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),

          if (isMe) SizedBox(width: AppSize.getWidth(10)),

          if (isMe) _buildAvatar(msg),
        ],
      ),
    );
  }

  Widget _buildBadge(ChatModel msg) {
    return Container(
      padding: AppSize.padding(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: msg.badgeColor!,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIcon(
            icon: msg.badgeIcon!,
            color: AppColors.white,
            width: AppSize.getSize(11),
            height: AppSize.getSize(11),
          ),
          SizedBox(width: AppSize.getWidth(3)),
          Text(
            msg.badge!,
            style: TextStyle(
              fontSize: AppSize.font(11),
              color: AppColors.white,
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
    return Container(
      padding: AppSize.padding(horizontal: 12, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: CustomFieldText(
              controller: _messageController,
              hintText: 'Write a message...',
            ),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          GestureDetector(
            onTap: () {
              final text = _messageController.text.trim();
              if (text.isEmpty) return;

              setState(() {
                _messages.add(
                  ChatModel(
                    senderName: 'You',
                    text: text,
                    time: 'Now',
                    avatarColor: AppColors.primary,
                    avatarLetter: 'Y',
                  ),
                );
              });

              _messageController.clear();
              _scrollToBottom();
            },
            child: Container(
              width: AppSize.getSize(42),
              height: AppSize.getSize(42),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

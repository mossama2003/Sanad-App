import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/cases_model.dart';
import '../controllers/case_cubit.dart';

class CaseCommentsBottomSheet extends StatefulWidget {
  final int caseId;
  final CasesCubit casesCubit;

  const CaseCommentsBottomSheet({
    super.key,
    required this.caseId,
    required this.casesCubit,
  });

  static void show(BuildContext context, int caseId, CasesCubit casesCubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: casesCubit,
        child: CaseCommentsBottomSheet(caseId: caseId, casesCubit: casesCubit),
      ),
    );
  }

  @override
  State<CaseCommentsBottomSheet> createState() =>
      _CaseCommentsBottomSheetState();
}

class _CaseCommentsBottomSheetState extends State<CaseCommentsBottomSheet> {
  final TextEditingController commentController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = AppCubit.get(context).user?.id;
    widget.casesCubit.getCaseComments(widget.caseId);
    widget.casesCubit.connectToCommentsChannel(widget.caseId);
  }

  @override
  void dispose() {
    widget.casesCubit.disconnectFromCommentsChannel();
    commentController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void _send() {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    widget.casesCubit.addCaseComment(
      caseId: widget.caseId,
      comment: text,
      context: context,
    );

    commentController.clear();
    FocusScope.of(context).unfocus();
  }

  // ===================== Long Press Options =====================

  void _showCommentOptions(CaseCommentModel comment) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSize.getHeight(10)),
            ListTile(
              leading: CustomIcon(
                icon: AppIcons.edit,
                color: AppColors.black,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
              title: Text(
                'shared.cases.comments.edit'.tr(),
                style: TextStyle(fontSize: AppSize.font(15)),
              ),
              onTap: () {
                AppNavigator.pop();
                _showEditDialog(comment);
              },
            ),
            ListTile(
              leading: CustomIcon(
                icon: AppIcons.delete,
                color: AppColors.red,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
              title: Text(
                'shared.cases.comments.delete'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(15),
                  color: AppColors.red,
                ),
              ),
              onTap: () {
                AppNavigator.pop();
                _confirmDelete(comment);
              },
            ),
            SizedBox(height: AppSize.getHeight(10)),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(CaseCommentModel comment) {
    final editController = TextEditingController(text: comment.comment);

    AppNavigator.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: AppSize.padding(all: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'shared.cases.comments.edit'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(16),
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: AppSize.getHeight(12)),
              TextField(
                controller: editController,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.grey.withValues(alpha: 0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: AppSize.getHeight(16)),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'core.cancel'.tr(),
                      bgColor: AppColors.grey200,
                      textColor: AppColors.black,
                      height: AppSize.getHeight(42),
                      onTap: () => AppNavigator.pop(),
                    ),
                  ),
                  SizedBox(width: AppSize.getWidth(12)),
                  Expanded(
                    child: CustomButton(
                      title: 'core.save'.tr(),
                      bgColor: AppColors.primary,
                      textColor: AppColors.white,
                      height: AppSize.getHeight(42),
                      onTap: () {
                        final newText = editController.text.trim();
                        if (newText.isEmpty) return;

                        AppNavigator.pop();
                        widget.casesCubit.editComment(
                          commentId: comment.id,
                          newComment: newText,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(CaseCommentModel comment) {
    AppNavigator.dialog(
      ConfirmDialog(
        title: 'shared.cases.comments.confirm_delete_title'.tr(),
        message: 'shared.cases.comments.confirm_delete_desc'.tr(),
        confirmText: 'shared.cases.comments.delete'.tr(),
        isDestructive: true,
        onConfirm: () => widget.casesCubit.deleteComment(
          commentId: comment.id,
          caseId: widget.caseId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding: AppSize.padding(bottom: bottomInset),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.65,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              SizedBox(height: AppSize.getHeight(10)),

              Container(
                width: AppSize.getWidth(40),
                height: AppSize.getHeight(4),
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              SizedBox(height: AppSize.getHeight(12)),

              Text(
                'shared.cases.comments.title'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(16),
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),

              SizedBox(height: AppSize.getHeight(10)),
              Divider(height: 1, color: AppColors.grey300),

              Expanded(
                child: BlocBuilder<CasesCubit, CasesState>(
                  bloc: widget.casesCubit,
                  buildWhen: (previous, current) =>
                      current is Loading ||
                      current is Success ||
                      current is Error,
                  builder: (context, state) {
                    final cubit = widget.casesCubit;

                    if (state is Loading && cubit.comments.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (cubit.comments.isEmpty) {
                      return Center(
                        child: Text(
                          'shared.cases.comments.no_comments'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: AppColors.grey,
                          ),
                        ),
                      );
                    }

                    return ListView.separated(
                      padding: AppSize.padding(all: 16),
                      itemCount: cubit.comments.length,
                      separatorBuilder: (_, _) =>
                          SizedBox(height: AppSize.getHeight(16)),
                      itemBuilder: (context, index) {
                        final comment = cubit.comments[index];
                        final isOwner =
                            currentUserId != null &&
                            comment.creator?.id == currentUserId;

                        return _CommentTile(
                          comment: comment,
                          onRetry: comment.status == CommentStatus.failed
                              ? () => widget.casesCubit.retryFailedComment(
                                  caseId: widget.caseId,
                                  localId: comment.localId!,
                                  context: context,
                                )
                              : null,
                          onLongPress:
                              isOwner && comment.status == CommentStatus.sent
                              ? () => _showCommentOptions(comment)
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),

              Divider(height: 1, color: AppColors.grey300),

              Padding(
                padding: AppSize.padding(all: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: AppSize.padding(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.grey.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: commentController,
                          focusNode: focusNode,
                          minLines: 1,
                          maxLines: 4,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _send(),
                          style: TextStyle(fontSize: AppSize.font(14)),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'shared.cases.comments.hint'.tr(),
                            hintStyle: TextStyle(
                              fontSize: AppSize.font(13),
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(8)),
                    BlocBuilder<CasesCubit, CasesState>(
                      bloc: widget.casesCubit,
                      buildWhen: (previous, current) =>
                          current is Sending ||
                          current is Success ||
                          current is Error,
                      builder: (context, state) {
                        final sending = widget.casesCubit.isSendingComment;

                        return GestureDetector(
                          onTap: sending ? null : _send,
                          child: Container(
                            width: AppSize.getSize(42),
                            height: AppSize.getSize(42),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: sending
                                  ? SizedBox(
                                      width: AppSize.getSize(20),
                                      height: AppSize.getSize(20),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : CustomIcon(
                                      icon: AppIcons.send,
                                      color: AppColors.white,
                                      width: AppSize.getSize(22),
                                      height: AppSize.getSize(22),
                                    ),
                            ),
                          ),
                        );
                      },
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

class _CommentTile extends StatelessWidget {
  final CaseCommentModel comment;
  final VoidCallback? onRetry;
  final VoidCallback? onLongPress; // 👈 جديد

  const _CommentTile({required this.comment, this.onRetry, this.onLongPress});

  @override
  Widget build(BuildContext context) {
    final creatorName = comment.creator?.name ?? '';
    final avatarUrl = comment.creator?.avatar;
    final isSending = comment.status == CommentStatus.sending;
    final isFailed = comment.status == CommentStatus.failed;

    return GestureDetector(
      onLongPress: onLongPress,
      child: Opacity(
        opacity: isSending ? 0.5 : 1,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: avatarUrl != null
                  ? CachedNetworkImage(
                      imageUrl: avatarUrl,
                      width: AppSize.getSize(36),
                      height: AppSize.getSize(36),
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: AppSize.getSize(36),
                        height: AppSize.getSize(36),
                        color: AppColors.grey300,
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: AppSize.getSize(36),
                        height: AppSize.getSize(36),
                        color: AppColors.grey300,
                        child: Icon(
                          Icons.person,
                          color: AppColors.grey700,
                          size: AppSize.getSize(18),
                        ),
                      ),
                    )
                  : Container(
                      width: AppSize.getSize(36),
                      height: AppSize.getSize(36),
                      color: AppColors.grey300,
                      child: Icon(
                        Icons.person,
                        color: AppColors.grey700,
                        size: AppSize.getSize(18),
                      ),
                    ),
            ),
            SizedBox(width: AppSize.getWidth(10)),
            Expanded(
              child: Container(
                padding: AppSize.padding(all: 12),
                decoration: BoxDecoration(
                  color: isFailed
                      ? AppColors.red.withValues(alpha: 0.08)
                      : AppColors.grey.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            creatorName,
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              fontWeight: FontWeight.w600,
                              color: AppColors.black,
                            ),
                          ),
                        ),
                        if (isSending)
                          SizedBox(
                            width: AppSize.getSize(12),
                            height: AppSize.getSize(12),
                            child: const CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                          )
                        else
                          Text(
                            timeago.format(comment.created),
                            style: TextStyle(
                              fontSize: AppSize.font(11),
                              color: AppColors.grey,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: AppSize.getHeight(4)),
                    Text(
                      comment.comment,
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        color: AppColors.grey700,
                      ),
                    ),
                    if (isFailed) ...[
                      SizedBox(height: AppSize.getHeight(6)),
                      GestureDetector(
                        onTap: onRetry,
                        child: Text(
                          'shared.cases.comments.tap_to_retry'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(12),
                            color: AppColors.red,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/cases_model.dart';
import '../controllers/case_cubit.dart';

class CaseCommentsBottomSheet extends StatefulWidget {
  final int caseId;
  final CasesCubit casesCubit; // 👈 جديد

  const CaseCommentsBottomSheet({
    super.key,
    required this.caseId,
    required this.casesCubit, // 👈 جديد
  });

  static void show(BuildContext context, int caseId, CasesCubit casesCubit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: casesCubit,
        // 👈 بيستخدم الـ instance الممرر، مش context lookup
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

  @override
  void initState() {
    super.initState();
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

              // Drag handle
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
                      separatorBuilder: (_, __) =>
                          SizedBox(height: AppSize.getHeight(16)),
                      itemBuilder: (context, index) {
                        final comment = cubit.comments[index];
                        return _CommentTile(
                          comment: comment,
                          onRetry: comment.status == CommentStatus.failed
                              ? () => widget.casesCubit.retryFailedComment(
                                  caseId: widget.caseId,
                                  localId: comment.localId!,
                                  context: context,
                                )
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),

              Divider(height: 1, color: AppColors.grey300),

              // Input
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

  const _CommentTile({required this.comment, this.onRetry});

  @override
  Widget build(BuildContext context) {
    final creatorName = comment.creator?.name ?? '';
    final avatarUrl = comment.creator?.avatar;
    final isSending = comment.status == CommentStatus.sending;
    final isFailed = comment.status == CommentStatus.failed;

    return Opacity(
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
    );
  }
}

import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_number_formatter.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../data/helper/case_attachment_helpers.dart';
import '../dialogs/case_comments_bottom_sheet.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/cases_model.dart';
import '../controllers/case_cubit.dart';
import '../dialogs/cases_pop_up.dart';

class CasesCard extends StatelessWidget {
  final CaseListItemModel caseItem;
  final CasesCubit casesCubit;
  final bool isOwner;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final VoidCallback? onComplete;

  const CasesCard({
    super.key,
    required this.caseItem,
    required this.casesCubit,
    this.isOwner = false,
    this.onDelete,
    this.onEdit,
    this.onComplete,
  });

  double get _progressValue {
    final estimated = caseItem.paymentDetails.estimatedAmount;
    final raised = caseItem.paymentDetails.raisedAmount;

    if (estimated <= 0) return 0;

    return (raised / estimated).clamp(0.0, 1.0);
  }

  String get _progressPercent {
    return (_progressValue * 100).toStringAsFixed(0);
  }

  List<String> get _imageUrls => caseItem.attachments
      .where(isImageAttachment)
      .map((a) => a.attachment.url)
      .toList();

  bool get _hasPayment => caseItem.paymentDetails.estimatedAmount > 0;

  /// Completed is only considered for the owner.
  bool get _isCompleted => isOwner && !caseItem.active;

  /// Like / comments / share should disappear when owner case is completed.
  bool get _showEngagement => !_isCompleted;

  String _formatEgyptianPhone(String phone) {
    final value = phone.trim();

    if (value.startsWith('+20')) {
      return '0${value.substring(3)}';
    }

    if (value.startsWith('20') && value.length == 12) {
      return '0${value.substring(2)}';
    }

    return value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final textColor = colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .65);

    final cardColor = theme.cardColor;

    final sectionColor = theme.brightness == Brightness.dark
        ? colorScheme.surfaceContainerHighest
        : AppColors.grey300.withValues(alpha: 0.3);

    final dividerColor = theme.dividerColor;

    final isCompleting = casesCubit.isCompletingCase(caseItem.id);

    // لو مفيش صور من السيرفر لسه، استخدم الصور المحلية
    // اللي اتحفظت وقت الإنشاء مباشرة
    final imageUrls = _imageUrls;

    final localImages = imageUrls.isEmpty
        ? casesCubit.localImagesFor(caseItem.id)
        : const <File>[];

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.35 : 0.2,
            ),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // Image
          // ============================================================
          ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            child: Stack(
              children: [
                _CaseImageCarousel(
                  imageUrls: imageUrls,
                  localImages: localImages,
                ),

                // Created time
                Positioned(
                  bottom: AppSize.getHeight(10),
                  right: AppSize.getWidth(10),
                  child: Container(
                    padding: AppSize.padding(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark
                          ? Colors.black.withValues(alpha: .6)
                          : AppColors.divider,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      timeago.format(caseItem.created),
                      style: TextStyle(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : AppColors.black,
                        fontSize: AppSize.font(11),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                // Verified badge
                if (caseItem.verified)
                  Positioned(
                    top: AppSize.getHeight(10),
                    left: AppSize.getWidth(10),
                    child: Container(
                      padding: AppSize.padding(horizontal: 15, vertical: 5),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? Colors.black.withValues(alpha: .6)
                            : AppColors.white.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomIcon(
                            icon: AppIcons.check,
                            color: AppColors.green,
                            width: AppSize.getSize(17),
                            height: AppSize.getSize(17),
                          ),
                          SizedBox(width: AppSize.getWidth(5)),
                          Text(
                            'shared.cases.card.verified'.tr(),
                            style: TextStyle(
                              color: AppColors.green,
                              fontSize: AppSize.font(11),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ============================================================
          // Content
          // ============================================================
          Padding(
            padding: AppSize.padding(all: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ========================================================
                // Name + Completed + Urgent
                // ========================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Case name
                    Expanded(
                      child: Text(
                        caseItem.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: AppSize.font(15),
                          fontWeight: FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ),

                    // Completed badge
                    if (_isCompleted) ...[
                      SizedBox(width: AppSize.getWidth(8)),
                      const _CompletedBadge(),
                    ],

                    // Urgent badge
                    if (caseItem.urgency == 'high') ...[
                      SizedBox(width: AppSize.getWidth(8)),
                      Container(
                        padding: AppSize.padding(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.brand200.withValues(alpha: 0.8),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIcon(
                              icon: AppIcons.cases,
                              color: AppColors.red,
                              width: AppSize.getSize(16),
                              height: AppSize.getSize(16),
                            ),
                            SizedBox(width: AppSize.getWidth(4)),
                            Text(
                              'shared.cases.card.urgent'.tr(),
                              style: TextStyle(
                                color: AppColors.red,
                                fontSize: AppSize.font(11),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: AppSize.getHeight(16)),

                // ========================================================
                // Description
                // ========================================================
                Text(
                  caseItem.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: secondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(15)),

                // ========================================================
                // Payment
                // ========================================================
                if (_hasPayment) ...[
                  Container(
                    padding: AppSize.padding(all: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: sectionColor,
                    ),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'shared.cases.card.required'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(13),
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: AppSize.getHeight(5)),
                                Text(
                                  'EGP ${caseItem.paymentDetails.estimatedAmount.compact}',
                                  style: TextStyle(
                                    fontSize: AppSize.font(20),
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const Spacer(),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'shared.cases.card.raised'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(13),
                                    color: secondaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                SizedBox(height: AppSize.getHeight(5)),
                                Text(
                                  'EGP ${caseItem.paymentDetails.raisedAmount.compact}',
                                  style: TextStyle(
                                    fontSize: AppSize.font(20),
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: AppSize.getHeight(10)),

                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: _progressValue,
                            minHeight: 8,
                            backgroundColor: theme.brightness == Brightness.dark
                                ? colorScheme.onSurface.withValues(alpha: .15)
                                : AppColors.grey300,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primary,
                            ),
                          ),
                        ),

                        SizedBox(height: AppSize.getHeight(5)),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$_progressPercent%',
                            style: TextStyle(
                              fontSize: AppSize.font(12),
                              fontWeight: FontWeight.w600,
                              color: secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(10)),
                ],

                SizedBox(height: AppSize.getHeight(10)),

                // ========================================================
                // Contact Name
                // ========================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIcon(
                      icon: AppIcons.contact,
                      color: secondaryColor,
                      width: AppSize.getSize(20),
                      height: AppSize.getSize(20),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Expanded(
                      child: Text(
                        caseItem.contactName,
                        style: TextStyle(
                          fontSize: AppSize.font(13),
                          color: secondaryColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSize.getHeight(10)),

                // ========================================================
                // Contact Phone
                // ========================================================
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomIcon(
                      icon: AppIcons.mobile,
                      color: secondaryColor,
                      width: AppSize.getSize(20),
                      height: AppSize.getSize(20),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Text(
                      _formatEgyptianPhone(caseItem.contactPhone),
                      style: TextStyle(
                        fontSize: AppSize.font(13),
                        color: secondaryColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),

                // ========================================================
                // Payment Description
                // ========================================================
                if (caseItem.paymentDetails.description != null) ...[
                  SizedBox(height: AppSize.getHeight(10)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomIcon(
                        icon: AppIcons.creditCard,
                        color: secondaryColor,
                        width: AppSize.getSize(20),
                        height: AppSize.getSize(20),
                      ),
                      SizedBox(width: AppSize.getWidth(10)),
                      Expanded(
                        child: Text(
                          caseItem.paymentDetails.paymentType == 'wallet'
                              ? _formatEgyptianPhone(
                                  caseItem.paymentDetails.description!,
                                )
                              : caseItem.paymentDetails.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: secondaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                SizedBox(height: AppSize.getHeight(10)),

                Divider(thickness: 0.3, height: 1, color: dividerColor),

                SizedBox(height: AppSize.getHeight(15)),

                // ========================================================
                // Actions Row
                //
                // LEFT:
                //   Like + Comments
                //
                // RIGHT:
                //   Share + Edit + Complete + Delete
                //
                // Completed owner:
                //   Delete ONLY
                // ========================================================
                Row(
                  children: [
                    // ======================================================
                    // LEFT SIDE
                    // Like + Comments
                    // ======================================================
                    if (_showEngagement)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Like
                          InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              if (!casesCubit.isLikingCase(caseItem.id)) {
                                casesCubit.likeCase(caseItem.id);
                              }
                            },
                            child: Padding(
                              padding: AppSize.padding(
                                vertical: 5,
                                horizontal: 3,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  casesCubit.isLikingCase(caseItem.id)
                                      ? SizedBox(
                                          width: AppSize.getWidth(18),
                                          height: AppSize.getHeight(18),
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.primary,
                                              ),
                                        )
                                      : CustomIcon(
                                          icon: AppIcons.donations,
                                          color: caseItem.isLiked
                                              ? AppColors.red
                                              : secondaryColor,
                                          width: AppSize.getWidth(18),
                                          height: AppSize.getHeight(18),
                                        ),

                                  SizedBox(width: AppSize.getWidth(3)),

                                  Text(
                                    caseItem.likers.compact,
                                    style: TextStyle(
                                      fontSize: AppSize.font(15),
                                      fontWeight: FontWeight.w300,
                                      color: caseItem.isLiked
                                          ? AppColors.red
                                          : textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: AppSize.getWidth(12)),

                          // Comments
                          GestureDetector(
                            onTap: () {
                              CaseCommentsBottomSheet.show(
                                context,
                                caseItem.id,
                                casesCubit,
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIcon(
                                  icon: AppIcons.comment,
                                  color: secondaryColor,
                                  width: AppSize.getWidth(18),
                                  height: AppSize.getHeight(18),
                                ),
                                SizedBox(width: AppSize.getWidth(3)),
                                Text(
                                  caseItem.comments.compact,
                                  style: TextStyle(
                                    fontSize: AppSize.font(15),
                                    fontWeight: FontWeight.w300,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    // ======================================================
                    // Push everything else to the right
                    // ======================================================
                    const Spacer(),

                    // ======================================================
                    // SHARE
                    // Volunteer + Active Owner only
                    // ======================================================
                    if (_showEngagement) ...[
                      InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          // TODO: Add share functionality.
                        },
                        child: Container(
                          width: AppSize.getWidth(36),
                          height: AppSize.getHeight(36),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: CustomIcon(
                            icon: AppIcons.share,
                            color: textColor,
                            width: AppSize.getWidth(17),
                            height: AppSize.getHeight(17),
                          ),
                        ),
                      ),

                      if (isOwner) SizedBox(width: AppSize.getWidth(5)),
                    ],

                    // ======================================================
                    // OWNER ACTIONS
                    // ======================================================
                    if (isOwner) ...[
                      // ====================================================
                      // EDIT
                      // Active owner only
                      // ====================================================
                      if (caseItem.active) ...[
                        InkWell(
                          onTap: onEdit,
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: AppSize.getWidth(36),
                            height: AppSize.getHeight(36),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: CustomIcon(
                              icon: AppIcons.edit,
                              color: AppColors.primary,
                              width: AppSize.getSize(18),
                              height: AppSize.getSize(18),
                            ),
                          ),
                        ),

                        SizedBox(width: AppSize.getWidth(5)),

                        // ==================================================
                        // COMPLETE
                        // Active owner only
                        // ==================================================
                        InkWell(
                          borderRadius: BorderRadius.circular(30),
                          onTap: !isCompleting ? onComplete : null,
                          child: _ActiveToggleButton(
                            isActive: caseItem.active,
                            isLoading: isCompleting,
                          ),
                        ),

                        SizedBox(width: AppSize.getWidth(5)),
                      ],

                      // ====================================================
                      // DELETE
                      // Always visible for owner
                      // ====================================================
                      InkWell(
                        onTap: onDelete,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          width: AppSize.getWidth(36),
                          height: AppSize.getHeight(36),
                          decoration: BoxDecoration(
                            color: AppColors.red.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: CustomIcon(
                            icon: AppIcons.delete,
                            color: AppColors.red,
                            width: AppSize.getSize(18),
                            height: AppSize.getSize(18),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // ============================================================
                // Donate / Help Button
                // Only for non-owner
                // ============================================================
                if (!isOwner) ...[
                  SizedBox(height: AppSize.getHeight(20)),

                  CustomButton(
                    title: 'shared.cases.card.button'.tr(),
                    height: AppSize.getHeight(40),
                    onTap: () => AppNavigator.dialog(
                      CasesPopUp(caseItem: caseItem, casesCubit: casesCubit),
                    ),
                    bgColor: AppColors.laserBlue,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Completed Badge
// ============================================================================

class _CompletedBadge extends StatelessWidget {
  const _CompletedBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.padding(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIcon(
            icon: AppIcons.check,
            color: AppColors.green,
            width: AppSize.getSize(15),
            height: AppSize.getSize(15),
          ),

          SizedBox(width: AppSize.getWidth(4)),

          Text(
            'shared.cases.card.completed'.tr(),
            style: TextStyle(
              color: AppColors.green,
              fontSize: AppSize.font(11),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Active / Complete Toggle
// ============================================================================

class _ActiveToggleButton extends StatelessWidget {
  final bool isActive;
  final bool isLoading;

  const _ActiveToggleButton({required this.isActive, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.grey500 : AppColors.green;

    // Completed state is represented by the Completed badge.
    if (!isActive) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: AppSize.padding(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: isLoading
          ? SizedBox(
              width: AppSize.getSize(18),
              height: AppSize.getSize(18),
              child: CircularProgressIndicator(strokeWidth: 2, color: color),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: AppSize.getWidth(30),
                  height: AppSize.getHeight(16),
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: AppSize.getWidth(12),
                    height: AppSize.getHeight(12),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),

                SizedBox(width: AppSize.getWidth(6)),

                Text(
                  'shared.cases.card.complete'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(11),
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
    );
  }
}

// ============================================================================
// Case Image Carousel
// ============================================================================

class _CaseImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final List<File> localImages;

  const _CaseImageCarousel({
    required this.imageUrls,
    this.localImages = const [],
  });

  @override
  State<_CaseImageCarousel> createState() => _CaseImageCarouselState();
}

class _CaseImageCarouselState extends State<_CaseImageCarousel> {
  late final PageController _pageController;

  Timer? _autoScrollTimer;

  int _currentPage = 0;

  int get _itemCount => widget.imageUrls.isNotEmpty
      ? widget.imageUrls.length
      : widget.localImages.length;

  bool get _useNetwork => widget.imageUrls.isNotEmpty;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    if (_itemCount > 1) {
      _startAutoScroll();
    }
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_pageController.hasClients) {
        return;
      }

      final nextPage = (_currentPage + 1) % _itemCount;

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isDark = theme.brightness == Brightness.dark;

    final onSurface = theme.colorScheme.onSurface;

    if (_itemCount == 0) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: onSurface.withValues(alpha: .15)),
        ),
        child: Image.asset(
          AppImages.casesImage,
          width: double.infinity,
          height: AppSize.getHeight(180),
          fit: BoxFit.cover,
        ),
      );
    }

    return SizedBox(
      height: AppSize.getHeight(180),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _itemCount,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: onSurface.withValues(alpha: .15)),
                ),
                child: _useNetwork
                    ? CachedNetworkImage(
                        imageUrl: widget.imageUrls[index],
                        width: double.infinity,
                        height: AppSize.getHeight(180),
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: AppSize.getHeight(180),
                          color: isDark
                              ? theme.colorScheme.surfaceContainerHighest
                              : AppColors.grey300,
                        ),
                        errorWidget: (context, url, error) => Image.asset(
                          AppImages.casesImage,
                          width: double.infinity,
                          height: AppSize.getHeight(180),
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.file(
                        widget.localImages[index],
                        width: double.infinity,
                        height: AppSize.getHeight(180),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              AppImages.casesImage,
                              width: double.infinity,
                              height: AppSize.getHeight(180),
                              fit: BoxFit.cover,
                            ),
                      ),
              );
            },
          ),

          if (_itemCount > 1)
            Padding(
              padding: AppSize.padding(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_itemCount, (index) {
                  final isActive = index == _currentPage;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(
                      horizontal: AppSize.getWidth(3),
                    ),
                    width: isActive
                        ? AppSize.getWidth(16)
                        : AppSize.getWidth(6),
                    height: AppSize.getHeight(6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

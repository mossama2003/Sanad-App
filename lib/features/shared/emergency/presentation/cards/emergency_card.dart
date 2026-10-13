import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_size.dart';
import '../../data/models/emergency_model.dart';
import '../../../../../../core/style/app_colors.dart';
import '../helpers/emergency_helpers.dart';

class EmergencyCard extends StatelessWidget {
  const EmergencyCard({
    super.key,
    required this.emergency,
    this.onTap,
  });

  final EmergencyModel emergency;
  final VoidCallback? onTap;

  List<String> get imageUrls => emergency.attachments
      .where((a) => a.isImage && a.url.isNotEmpty)
      .map((a) => a.url)
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);

    final urgencyColor =
    EmergencyHelpers.urgencyColor(emergency.urgency);

    final location = emergency.locationText;
    final creatorName = emergency.creator?.name ?? '';

    final percent = (emergency.progress * 100).round();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? .35 : .12,
            ),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======================================================
            // Cover + Image Slider + Badges + Title
            // ======================================================
            SizedBox(
              height: AppSize.getHeight(180),
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Images: manual swipe + automatic scrolling.
                  // Tap opens the dialog; horizontal drag stays
                  // handled by the PageView.
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: _EmergencyImageCarousel(
                      imageUrls: imageUrls,
                      fallbackColor: urgencyColor,
                    ),
                  ),

                  // Gradient
                  IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [.4, 1],
                          colors: [
                            Colors.black.withValues(alpha: .05),
                            Colors.black.withValues(alpha: .75),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Badges
                  Positioned(
                    top: AppSize.getHeight(12),
                    left: AppSize.getWidth(12),
                    right: AppSize.getWidth(12),
                    child: IgnorePointer(
                      child: Wrap(
                        spacing: AppSize.getWidth(8),
                        runSpacing: AppSize.getHeight(6),
                        children: [
                          EmergencyBadge(
                            label: EmergencyHelpers.urgencyLabel(
                              emergency.urgency,
                            ),
                            color: urgencyColor,
                            icon: AppIcons.siren,
                          ),
                          EmergencyBadge(
                            label: EmergencyHelpers.categoryLabel(
                              emergency.category,
                            ),
                            color: AppColors.grey800,
                          ),
                          if (emergency.joined)
                            EmergencyBadge(
                              label:
                              'shared.emergency.card.joined'.tr(),
                              color: Colors.green,
                              icon: AppIcons.check,
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Title + Creator
                  Positioned(
                    left: AppSize.getWidth(16),
                    right: AppSize.getWidth(16),
                    bottom: AppSize.getHeight(14),
                    child: IgnorePointer(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emergency.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: AppSize.font(20),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (creatorName.isNotEmpty) ...[
                            SizedBox(
                              height: AppSize.getHeight(2),
                            ),
                            Text(
                              creatorName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: .9,
                                ),
                                fontSize: AppSize.font(13),
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

            // ======================================================
            // Details
            // ======================================================
            InkWell(
              onTap: onTap,
              child: Padding(
                padding: AppSize.padding(all: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Time + Location
                    Row(
                      children: [
                        CustomIcon(
                          icon: AppIcons.time,
                          color: secondaryColor,
                          width: AppSize.getSize(15),
                          height: AppSize.getSize(15),
                        ),
                        SizedBox(
                          width: AppSize.getWidth(5),
                        ),
                        Text(
                          EmergencyHelpers.timeAgo(
                            emergency.created,
                          ),
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: secondaryColor,
                          ),
                        ),
                        if (location.isNotEmpty) ...[
                          SizedBox(
                            width: AppSize.getWidth(14),
                          ),
                          CustomIcon(
                            icon: AppIcons.location,
                            color: secondaryColor,
                            width: AppSize.getSize(15),
                            height: AppSize.getSize(15),
                          ),
                          SizedBox(
                            width: AppSize.getWidth(5),
                          ),
                          Expanded(
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
                      ],
                    ),

                    SizedBox(
                      height: AppSize.getHeight(12),
                    ),

                    // Description
                    Text(
                      emergency.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: AppSize.font(15),
                        color: secondaryColor,
                      ),
                    ),

                    SizedBox(
                      height: AppSize.getHeight(14),
                    ),

                    // Volunteers
                    Row(
                      children: [
                        CustomIcon(
                          icon: AppIcons.community,
                          color: urgencyColor,
                          width: AppSize.getSize(18),
                          height: AppSize.getSize(18),
                        ),
                        SizedBox(
                          width: AppSize.getWidth(6),
                        ),
                        Text(
                          '${emergency.joiners} / '
                              '${emergency.volunteers} '
                              '${'shared.emergency.card.volunteers'.tr()}',
                          style: TextStyle(
                            fontSize: AppSize.font(15),
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$percent%',
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: AppSize.getHeight(10),
                    ),

                    // Progress Bar
                    EmergencyProgressBar(
                      progress: emergency.progress,
                      color: urgencyColor,
                      height: AppSize.getHeight(8),
                    ),
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

// ============================================================================
// Emergency Image Carousel
// ============================================================================

class _EmergencyImageCarousel extends StatefulWidget {
  const _EmergencyImageCarousel({
    required this.imageUrls,
    required this.fallbackColor,
  });

  final List<String> imageUrls;
  final Color fallbackColor;

  @override
  State<_EmergencyImageCarousel> createState() =>
      _EmergencyImageCarouselState();
}

class _EmergencyImageCarouselState extends State<_EmergencyImageCarousel> {
  late final PageController _pageController;

  Timer? _autoScrollTimer;

  int _currentPage = 0;

  int get _itemCount => widget.imageUrls.length;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    if (_itemCount > 1) {
      _startAutoScroll();
    }
  }

  @override
  void didUpdateWidget(covariant _EmergencyImageCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.imageUrls != widget.imageUrls) {
      _stopAutoScroll();
      _currentPage = 0;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        if (_pageController.hasClients && _itemCount > 0) {
          _pageController.jumpToPage(0);
        }

        if (_itemCount > 1) {
          _startAutoScroll();
        }

        setState(() {});
      });
    }
  }

  void _startAutoScroll() {
    _stopAutoScroll();

    if (_itemCount <= 1) return;

    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted ||
          !_pageController.hasClients ||
          _itemCount <= 1 ||
          _pageController.position.isScrollingNotifier.value) {
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

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_itemCount == 0) {
      return _buildFallback();
    }

    return SizedBox(
      width: double.infinity,
      height: AppSize.getHeight(180),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Swipeable image slider
          PageView.builder(
            controller: _pageController,
            itemCount: _itemCount,
            physics: const PageScrollPhysics(),
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.imageUrls[index],
                width: double.infinity,
                height: AppSize.getHeight(180),
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Container(
                    color: isDark
                        ? theme.colorScheme.surfaceContainerHighest
                        : AppColors.grey300,
                    alignment: Alignment.center,
                    child: const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    color: widget.fallbackColor.withValues(alpha: .12),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: widget.fallbackColor,
                    ),
                  );
                },
              );
            },
          ),

          // Image indicators
          if (_itemCount > 1)
            Padding(
              padding: AppSize.padding(bottom: 8),
              child: IgnorePointer(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_itemCount, (index) {
                    final isActive = index == _currentPage;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: EdgeInsets.symmetric(
                        horizontal: AppSize.getWidth(3),
                      ),
                      width: AppSize.getWidth(isActive ? 16 : 6),
                      height: AppSize.getHeight(6),
                      decoration: BoxDecoration(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withValues(alpha: .5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFallback() {
    return Container(
      width: double.infinity,
      height: AppSize.getHeight(180),
      color: widget.fallbackColor.withValues(alpha: .12),
      alignment: Alignment.center,
      child: Icon(
        Icons.image_not_supported_outlined,
        size: 40,
        color: widget.fallbackColor,
      ),
    );
  }
}

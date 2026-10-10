import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';

class EmergencyHelpers {
  static const Color remainingColor = Color(0xFFF5A524);

  static Color urgencyColor(String urgency) {
    switch (urgency.toLowerCase()) {
      case 'critical':
      case 'high':
        return AppColors.red;

      case 'medium':
        return AppColors.bronze;

      case 'low':
        return AppColors.green;

      default:
        return AppColors.red;
    }
  }

  static String urgencyLabel(String urgency) {
    final key = urgency.toLowerCase();

    const known = ['low', 'medium', 'high', 'critical'];

    if (!known.contains(key)) return urgency;

    return 'shared.emergency.urgency.$key'.tr();
  }

  static String categoryLabel(String category) {
    final key = category.toLowerCase();

    const known = ['medical', 'rescue', 'food', 'shelter', 'other'];

    if (known.contains(key)) return 'shared.emergency.categories.$key'.tr();

    if (category.isEmpty) return category;

    return category[0].toUpperCase() + category.substring(1);
  }

  static String timeAgo(DateTime? date) {
    if (date == null) return '';

    final diff = DateTime.now().difference(date);

    if (diff.inMinutes < 1) {
      return 'shared.emergency.card.just_now'.tr();
    }

    if (diff.inMinutes < 60) {
      return 'shared.emergency.card.minutes_ago'.tr(
        args: ['${diff.inMinutes}'],
      );
    }

    if (diff.inHours < 24) {
      return 'shared.emergency.card.hours_ago'.tr(args: ['${diff.inHours}']);
    }

    if (diff.inDays < 7) {
      return 'shared.emergency.card.days_ago'.tr(args: ['${diff.inDays}']);
    }

    return DateFormat('dd MMM yyyy', 'en').format(date.toLocal());
  }

  /// +201005557788 → +20 100 555 7788
  static String formatPhone(String phone) {
    final value = phone.trim();

    if (value.startsWith('+20') && value.length == 13) {
      final rest = value.substring(3);

      return '+20 ${rest.substring(0, 3)} ${rest.substring(3, 6)} '
          '${rest.substring(6)}';
    }

    return value;
  }
}

// ============================================================================
// Badge (Critical / Active)
// ============================================================================

class EmergencyBadge extends StatelessWidget {
  const EmergencyBadge({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final String? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.padding(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Color.alphaBlend(color.withValues(alpha: .12), Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            CustomIcon(
              icon: icon!,
              color: color,
              width: AppSize.getSize(14),
              height: AppSize.getSize(14),
            ),
            SizedBox(width: AppSize.getWidth(5)),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: AppSize.font(12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Cover Image
// ============================================================================

class EmergencyCover extends StatelessWidget {
  const EmergencyCover({super.key, required this.url, required this.color});

  final String? url;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withValues(alpha: .9), color.withValues(alpha: .55)],
        ),
      ),
    );

    final image = url;

    if (image == null || image.isEmpty) return placeholder;

    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (_, _) => placeholder,
      errorWidget: (_, _, _) => placeholder,
    );
  }
}

// ============================================================================
// Progress Bar (filled + remaining)
// ============================================================================

class EmergencyProgressBar extends StatelessWidget {
  const EmergencyProgressBar({
    super.key,
    required this.progress,
    required this.color,
    this.height = 8,
  });

  /// 0.0 → 1.0
  final double progress;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(color: EmergencyHelpers.remainingColor),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

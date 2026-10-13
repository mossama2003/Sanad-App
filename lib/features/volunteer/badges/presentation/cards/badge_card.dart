import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/badges_model.dart';

class BadgeCard extends StatelessWidget {
  final BadgeModel badge;

  const BadgeCard({super.key, required this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;

    final isEarned = badge.isEarned;

    final backgroundColor = isEarned
        ? AppColors.primary.withValues(alpha: isDark ? .12 : .07)
        : (isDark
              ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: .45)
              : const Color(0xFFF8F9FC));

    final borderColor = isEarned
        ? AppColors.primary.withValues(alpha: .25)
        : textColor.withValues(alpha: .06);

    final mutedColor = textColor.withValues(alpha: .45);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.padding(horizontal: 10, vertical: 14).horizontal,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .08 : .025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Badge icon
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: AppSize.getWidth(60),
                height: AppSize.getWidth(60),
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEarned
                      ? AppColors.primary.withValues(alpha: .12)
                      : (isDark
                            ? textColor.withValues(alpha: .06)
                            : Colors.white),
                  border: Border.all(
                    color: isEarned
                        ? AppColors.primary.withValues(alpha: .18)
                        : textColor.withValues(alpha: .07),
                  ),
                ),
                child: ClipOval(
                  child: badge.image != null && badge.image!.isNotEmpty
                      ? Opacity(
                          opacity: isEarned ? 1 : .35,
                          child: Image.network(
                            badge.image!,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.workspace_premium_rounded,
                                size: AppSize.getSize(28),
                                color: isEarned
                                    ? AppColors.primary
                                    : mutedColor,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.workspace_premium_rounded,
                          size: AppSize.getSize(28),
                          color: isEarned ? AppColors.primary : mutedColor,
                        ),
                ),
              ),

              // Earned / locked indicator
              Positioned(
                bottom: -2,
                right: -3,
                child: Container(
                  width: AppSize.getWidth(23),
                  height: AppSize.getWidth(23),
                  decoration: BoxDecoration(
                    color: isEarned
                        ? Colors.green
                        : (isDark
                              ? theme.colorScheme.surface
                              : const Color(0xFFE9ECF2)),
                    shape: BoxShape.circle,
                    border: Border.all(color: backgroundColor, width: 2),
                  ),
                  child: Icon(
                    isEarned ? Icons.check_rounded : Icons.lock_rounded,
                    size: AppSize.getSize(12),
                    color: isEarned ? Colors.white : mutedColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(12)),

          // Badge name
          Text(
            badge.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppSize.font(11),
              fontWeight: FontWeight.w600,
              height: 1.4,
              color: isEarned ? textColor : textColor.withValues(alpha: .65),
            ),
          ),

          SizedBox(height: AppSize.getHeight(7)),

          // Status label
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.getWidth(9),
              vertical: AppSize.getHeight(4),
            ),
            decoration: BoxDecoration(
              color: isEarned
                  ? Colors.green.withValues(alpha: .10)
                  : textColor.withValues(alpha: .05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isEarned ? 'earned' : 'locked',
              style: TextStyle(
                fontSize: AppSize.font(9),
                fontWeight: FontWeight.w600,
                color: isEarned ? Colors.green : mutedColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

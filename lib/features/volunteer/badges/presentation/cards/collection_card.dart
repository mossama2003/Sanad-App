import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_count_up_text.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';

class CollectionCard extends StatelessWidget {
  final int collected;
  final int total;

  // gold, silver, bronze;

  const CollectionCard({
    super.key,
    required this.collected,
    required this.total,
    // required this.gold,
    // required this.silver,
    // required this.bronze,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final safeTotal = total < 0 ? 0 : total;
    final safeCollected = collected.clamp(0, safeTotal);

    final progress = safeTotal == 0 ? 0.0 : safeCollected / safeTotal;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF2ECFA0), Color(0xFF1BB88A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .25 : .08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: 55,
            child: Opacity(
              opacity: .15,
              child: CustomIcon(
                icon: AppIcons.cup,
                color: AppColors.white,
                width: AppSize.getSize(110),
                height: AppSize.getSize(110),
              ),
            ),
          ),

          Padding(
            padding: AppSize.padding(all: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.badges.your_collection'.tr(),
                  style: TextStyle(
                    fontSize: AppSize.font(13),
                    color: AppColors.white,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(6)),

                // Animated counter with fixed total
                RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: AppCountUpText(
                          value: safeCollected,
                          duration: const Duration(milliseconds: 300),
                          style: TextStyle(
                            fontSize: AppSize.font(40),
                            fontWeight: FontWeight.w800,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' /$safeTotal',
                        style: TextStyle(
                          fontSize: AppSize.font(20),
                          fontWeight: FontWeight.w500,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSize.getHeight(6)),

                // Animated progress bar
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutExpo,
                  builder: (context, animatedProgress, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: animatedProgress,
                        backgroundColor: AppColors.white.withValues(alpha: .3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    );
                  },
                ),

                // SizedBox(height: AppSize.getHeight(14)),
                // Row(
                //   children: [
                //     _TierDot(color: AppColors.gold, label: '$gold Gold'),
                //     SizedBox(width: AppSize.getWidth(16)),
                //     _TierDot(color: AppColors.silver, label: '$silver Silver'),
                //     SizedBox(width: AppSize.getWidth(16)),
                //     _TierDot(color: AppColors.bronze, label: '$bronze Bronze'),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class _TierDot extends StatelessWidget {
//   final Color color;
//   final String label;
//
//   const _TierDot({required this.color, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: AppSize.getSize(8),
//           height: AppSize.getSize(8),
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         SizedBox(width: AppSize.getWidth(5)),
//         Text(
//           label,
//           style: TextStyle(fontSize: AppSize.font(12), color: AppColors.white),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/constant/app_size.dart';

class DonationsInfoCard extends StatelessWidget {
  final String icon;
  final Color iconColor;
  final Color iconBackgroundColor;
  final String title;
  final String subtitle;

  const DonationsInfoCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBackgroundColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;

    return Container(
      height: AppSize.getHeight(120),
      padding: AppSize.padding(all: 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: textColor.withValues(
            alpha: isDark ? .12 : .1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: isDark ? .25 : .1,
            ),
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: AspectRatio(
              aspectRatio: 1,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  padding: AppSize.padding(all: 10),
                  decoration: BoxDecoration(
                    color: iconBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? .2 : .1,
                        ),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: CustomIcon(
                    icon: icon,
                    color: iconColor,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: AppSize.font(25),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor.withValues(alpha: .6),
                    fontWeight: FontWeight.w400,
                    fontSize: AppSize.font(12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';

import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

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
    return Container(
      height: AppSize.getHeight(120),
      padding: AppSize.padding(all: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppColors.grey.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
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
                        color: AppColors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: CustomIcon(icon: icon, color: iconColor),
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
                        color: AppColors.black,
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
                    color: AppColors.grey,
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

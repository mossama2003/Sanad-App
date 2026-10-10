import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';

class SettingsGroupCard extends StatelessWidget {
  final String title;
  final List<Widget>? children;

  final String? icon;
  final Widget? trailing;

  const SettingsGroupCard({
    super.key,
    required this.title,
    this.children,
    this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        if (children != null)
          Text(
            title,
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: .5),
              fontSize: AppSize.font(14),
              fontWeight: FontWeight.w600,
            ),
          ),

        if (children != null) SizedBox(height: AppSize.getHeight(10)),

        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: theme.colorScheme.onSurface.withValues(alpha: .15),
              width: .7,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? .3 : .05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: AppSize.padding(all: 15),
          child: children != null
              ? Column(children: children!)
              : Row(
                  children: [
                    Container(
                      padding: AppSize.padding(all: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: .12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: CustomIcon(
                        icon: icon!,
                        color: AppColors.primary,
                        width: AppSize.getSize(20),
                        height: AppSize.getSize(20),
                      ),
                    ),
                    SizedBox(width: AppSize.getWidth(10)),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: AppSize.font(14),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    trailing ?? const SizedBox(),
                  ],
                ),
        ),
      ],
    );
  }
}

class SettingsTile extends StatelessWidget {
  final String icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;
  final bool withColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
    this.withColor = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: AppSize.padding(vertical: 5),
        child: Row(
          children: [
            Container(
              padding: AppSize.padding(all: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: CustomIcon(
                icon: icon,
                withColor: withColor,
                color: AppColors.primary,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
            ),
            SizedBox(width: AppSize.getWidth(10)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: AppSize.font(14),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

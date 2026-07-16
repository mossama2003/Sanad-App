import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';

class EditProfileGroupCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const EditProfileGroupCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          title,

          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: .5),

            fontSize: AppSize.font(14),

            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: AppSize.getHeight(10)),

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

          child: Column(children: children),
        ),
      ],
    );
  }
}

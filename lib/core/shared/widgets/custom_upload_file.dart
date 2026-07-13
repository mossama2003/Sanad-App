import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../style/app_colors.dart';
import '../../style/app_text_style.dart';

class CustomUploadFile extends StatelessWidget {
  const CustomUploadFile({
    super.key,
    this.image,
    required this.onTap,
    required this.onRemove,
    this.icon,
    this.hint,
    this.title,
    this.minLines,
    this.maxLines,
    this.height,
    this.isRequired = false,
  });

  final File? image;

  final VoidCallback onTap;
  final VoidCallback onRemove;

  final String? icon;
  final String? hint;
  final String? title;

  final int? minLines;
  final int? maxLines;

  final bool isRequired;

  final double? height;

  double get _containerHeight =>
      height ?? AppSize.getHeight(60 + ((maxLines ?? minLines ?? 1) - 1) * 24);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.textTheme.bodyMedium?.color ?? AppColors.inputText;

    final borderColor = theme.dividerColor;

    final errorColor = theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        if (title != null) ...[
          RichText(
            text: TextSpan(
              text: title!,

              style: TextStyle(color: AppColors.textSecondary).xs,

              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *',

                        style: TextStyle(
                          color: errorColor,

                          fontSize: AppSize.font(12),
                        ),
                      ),
                    ]
                  : [],
            ),
          ),

          SizedBox(height: AppSize.getHeight(8)),
        ],

        Container(
          height: _containerHeight,

          width: double.infinity,

          decoration: DottedDecoration(
            shape: Shape.box,

            borderRadius: BorderRadius.circular(16),

            color: borderColor,

            strokeWidth: 1.5,

            dash: const [6, 4],
          ),

          child: image == null
              ? InkWell(
                  onTap: onTap,

                  borderRadius: BorderRadius.circular(16),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      CustomIcon(
                        icon: icon!,

                        height: AppSize.getSize(25),

                        width: AppSize.getSize(25),

                        color: AppColors.iconGrey,
                      ),

                      SizedBox(width: AppSize.getWidth(8)),

                      Text(hint!, style: TextStyle(color: textColor)),
                    ],
                  ),
                )
              : Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),

                      child: Image.file(
                        image!,

                        width: double.infinity,

                        height: double.infinity,

                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 8,

                      right: 8,

                      child: InkWell(
                        onTap: onRemove,

                        child: Container(
                          padding: AppSize.padding(all: 6),

                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.dark
                                ? Colors.black87
                                : Colors.black54,

                            shape: BoxShape.circle,
                          ),

                          child: CustomIcon(
                            icon: AppIcons.close,

                            color: AppColors.white,

                            height: AppSize.getSize(18),

                            width: AppSize.getSize(18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}

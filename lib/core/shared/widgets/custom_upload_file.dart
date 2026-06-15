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
  final int? minLines;
  final int? maxLines;
  final String? title;
  final bool isRequired;
  final double? height;

  // Each "line" maps to a row height — same unit as CustomFieldText uses
  double get _containerHeight =>
      height ?? AppSize.getHeight(60 + ((maxLines ?? minLines ?? 1) - 1) * 24);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          RichText(
            text: TextSpan(
              text: title!,
              style: TextStyle(color: AppColors.grey700).xs,
              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.red,
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
            color: AppColors.grey300,
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
                        color: AppColors.black,
                      ),
                      SizedBox(width: AppSize.getWidth(8)),
                      Text(hint!, style: TextStyle(color: AppColors.black)),
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
                          decoration: const BoxDecoration(
                            color: Colors.black54,
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

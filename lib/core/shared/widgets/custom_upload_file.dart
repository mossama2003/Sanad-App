import 'dart:io';
import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import '../../style/app_text_style.dart';
import 'custom_icon.dart';

class CustomUploadFile extends StatelessWidget {
  const CustomUploadFile({
    super.key,
    this.image,
    required this.onTap,
    required this.onRemove,
    this.icon,
    this.hint,
    this.title,
    this.height,
    this.isRequired = false,
    this.validator,
    this.minLines,
    this.maxLines,
  });

  final File? image;

  final VoidCallback onTap;
  final VoidCallback onRemove;

  final String? icon;
  final String? hint;
  final String? title;

  final double? height;

  final bool isRequired;

  final String? Function(File?)? validator;

  final int? minLines;
  final int? maxLines;

  double get _containerHeight {
    if (height != null) return height!;

    if (minLines != null) {
      return AppSize.getHeight(60.0 * minLines!);
    }

    return AppSize.getHeight(60);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.textTheme.bodyMedium?.color ?? AppColors.inputText;

    final borderColor = theme.dividerColor;

    final errorColor = theme.colorScheme.error;

    return FormField<File?>(
      initialValue: image,

      validator: (_) {
        return validator?.call(image);
      },

      builder: (field) {
        final hasError = field.hasError;

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
                color: hasError ? errorColor : borderColor,
                strokeWidth: 1.5,
                dash: const [6, 4],
              ),

              child: image == null
                  ? InkWell(
                      onTap: () {
                        onTap();
                        field.didChange(image);
                      },

                      borderRadius: BorderRadius.circular(16),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIcon(
                            icon: icon!,
                            height: AppSize.getSize(25),
                            width: AppSize.getSize(25),
                            color: AppColors.iconGrey,
                          ),

                          SizedBox(height: AppSize.getHeight(8)),

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
                            onTap: () {
                              onRemove();
                              field.didChange(null);
                            },

                            child: Container(
                              padding: AppSize.padding(all: 6),

                              decoration: BoxDecoration(
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

            if (field.hasError)
              Padding(
                padding: EdgeInsets.only(
                  top: AppSize.getHeight(6),
                  left: AppSize.getWidth(4),
                ),

                child: Text(
                  field.errorText!,
                  style: TextStyle(
                    color: errorColor,
                    fontSize: AppSize.font(12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

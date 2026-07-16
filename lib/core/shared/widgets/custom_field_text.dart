import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import 'custom_icon.dart';

class CustomFieldText extends StatelessWidget {
  const CustomFieldText({
    super.key,
    this.title,
    this.hintText,
    this.helperText,
    this.labelText,
    required this.controller,
    this.onSubmit,
    this.padding,
    this.onTap,
    this.onChanged,
    this.iconStart,
    this.iconEnd,
    this.iconEndTap,
    this.minLines,
    this.maxLines,
    this.enabled = true,
    this.validator,
    this.iconColor = false,
    this.readOnly = false,
    this.autofocus = false,
    this.obscureText = false,
    this.isRequired = false,
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.bgColor,

    // customization
    this.titleColor,
    this.titleSize,
    this.borderRadius,
  });

  final TextEditingController controller;

  final bool iconColor;
  final Color? bgColor;

  final String? iconStart;
  final String? iconEnd;
  final Function()? iconEndTap;

  final String? title;
  final String? labelText;
  final String? hintText;
  final String? helperText;

  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? padding;

  final bool obscureText;
  final bool isRequired;

  final int? minLines;
  final int? maxLines;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final Function()? onTap;
  final Function(String)? onSubmit;
  final Function(String)? onChanged;

  final FormFieldValidator<String>? validator;

  final List<TextInputFormatter>? inputFormatters;

  // customization
  final Color? titleColor;
  final double? titleSize;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.textTheme.bodyMedium?.color ?? AppColors.inputText;

    final hintColor = theme.brightness == Brightness.dark
        ? AppColors.grey400
        : AppColors.grey;

    final borderColor = theme.dividerColor;

    final errorColor = theme.colorScheme.error;

    final radius = borderRadius ?? 12;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        if (title != null) ...[
          RichText(
            text: TextSpan(
              text: title!,

              style: TextStyle(
                color: titleColor ?? AppColors.textSecondary,
                fontSize: titleSize ?? AppSize.font(12),
              ),

              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: errorColor,
                          fontSize: AppSize.font(15),
                        ),
                      ),
                    ]
                  : [],
            ),
          ),

          SizedBox(height: AppSize.getHeight(6)),
        ],

        TextFormField(
          controller: controller,

          enabled: enabled,

          readOnly: readOnly,

          onTap: onTap,

          onChanged: onChanged,

          onFieldSubmitted: onSubmit,

          autofocus: autofocus,

          obscureText: obscureText,

          keyboardType: keyboardType,

          minLines: minLines ?? 1,

          maxLines: maxLines ?? minLines ?? 1,

          validator: validator,

          inputFormatters: inputFormatters,

          autovalidateMode: AutovalidateMode.onUserInteraction,

          style: TextStyle(
            color: textColor,
            fontSize: AppSize.font(14),
            fontWeight: FontWeight.w600,
          ),

          decoration: InputDecoration(
            filled: true,

            fillColor: bgColor ?? Theme.of(context).cardColor,

            hintText: hintText ?? labelText ?? '',

            hintStyle: TextStyle(color: hintColor, fontSize: AppSize.font(12)),

            contentPadding: padding,

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: borderColor),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: borderColor),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: errorColor),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius),
              borderSide: BorderSide(color: errorColor, width: 1.5),
            ),

            prefixIcon: iconStart != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIcon(
                        icon: iconStart!,
                        withColor: iconColor,
                        width: AppSize.getSize(50),
                        color: iconColor ? null : AppColors.iconGrey,
                      ),
                    ],
                  )
                : null,

            suffixIcon: iconEnd != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIcon(
                        icon: iconEnd!,
                        onTap: iconEndTap,
                        withColor: iconColor,
                        width: AppSize.getSize(50),
                        color: iconColor ? null : AppColors.iconGrey,
                      ),
                    ],
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

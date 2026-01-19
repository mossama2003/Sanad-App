import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import '../../style/app_text_style.dart';
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
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
  });

  final TextEditingController controller;

  final bool iconColor;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: TextStyle(color: AppColors.grey700).xs),
          SizedBox(height: AppSize.getHeight(6)),
        ],
        TextFormField(
          enabled: enabled,
          readOnly: readOnly,
          onTap: onTap,
          minLines: minLines ?? 1,
          maxLines: maxLines ?? minLines ?? 1,
          autofocus: autofocus,
          onChanged: onChanged,
          controller: controller,
          obscureText: obscureText,
          onFieldSubmitted: onSubmit,
          keyboardType: keyboardType,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            fontSize: AppSize.font(14),
            fontWeight: FontWeight.w600,
          ),
          validator: validator,
          inputFormatters: inputFormatters,
          decoration: InputDecoration(
            hintStyle: TextStyle(color: AppColors.grey).xs,

            contentPadding: padding,
            hintText: hintText ?? labelText ?? '',
            errorStyle: TextStyle(fontSize: AppSize.font(14)),

            suffixIconConstraints: BoxConstraints(
              minHeight: AppSize.getHeight(40),
              maxHeight: AppSize.getHeight(40),
            ),
            prefixIconConstraints: BoxConstraints(
              minHeight: AppSize.getHeight(40),
              maxHeight: AppSize.getHeight(40),
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.grey300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: AppColors.grey300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: Colors.red, width: 1.5),
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

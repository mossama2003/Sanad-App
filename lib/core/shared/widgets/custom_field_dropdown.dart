import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import '../../style/app_text_style.dart';
import 'custom_icon.dart';

class CustomFieldDropdown<T> extends StatelessWidget {
  const CustomFieldDropdown({
    super.key,
    this.title,
    this.titleSize,
    this.titleColor,
    this.hintText,
    this.validator,
    this.enabled = true,
    this.isRequired = false,
    this.borderRadius = 12,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final ValueNotifier<T?> selected;

  final bool enabled;
  final bool isRequired;

  final String? title;
  final double? titleSize;
  final Color? titleColor;

  final String? hintText;

  final double borderRadius;

  final ValueChanged<T?> onChanged;

  final List<DropdownItem<T>>? items;

  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.textTheme.bodyMedium?.color;

    final hintColor = theme.textTheme.bodySmall?.color?.withValues(alpha: .6);

    final borderColor = theme.dividerColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          RichText(
            text: TextSpan(
              text: title!,
              style: TextStyle(
                color: titleColor ?? textColor,
                fontSize: titleSize ?? AppSize.font(12),
                fontWeight: FontWeight.w500,
              ),
              children: isRequired
                  ? [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.red,
                          fontSize: titleSize ?? AppSize.font(12),
                        ),
                      ),
                    ]
                  : [],
            ),
          ),

          SizedBox(height: AppSize.getHeight(6)),
        ],

        DropdownButtonFormField2<T>(
          items: items,

          valueListenable: selected,

          isExpanded: true,

          validator: validator,

          autovalidateMode: AutovalidateMode.onUserInteraction,

          style: TextStyle(
            color: textColor,
            fontSize: AppSize.font(14),
            fontWeight: FontWeight.w600,
          ),

          hint: hintText != null && selected.value == null
              ? Text(hintText!, style: TextStyle(color: hintColor).xs)
              : null,

          onChanged: enabled
              ? (value) {
                  selected.value = value;
                  onChanged(value);
                }
              : null,

          iconStyleData: IconStyleData(
            icon: CustomIcon(
              icon: AppIcons.downArrow,
              width: AppSize.getSize(12),
              height: AppSize.getSize(12),
              color: theme.iconTheme.color,
            ),

            openMenuIcon: CustomIcon(
              icon: AppIcons.upArrow,
              width: AppSize.getSize(12),
              height: AppSize.getSize(12),
              color: theme.iconTheme.color,
            ),
          ),

          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),

          decoration: InputDecoration(
            filled: true,

            fillColor: theme.cardColor,

            enabled: enabled,

            hintStyle: TextStyle(color: hintColor).xs,

            errorStyle: TextStyle(fontSize: AppSize.font(14)),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: borderColor),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

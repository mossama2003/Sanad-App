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
    this.hintText,
    this.validator,
    this.enabled = true,
    this.isRequired = false,
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final ValueNotifier<T?> selected;

  final bool enabled;
  final bool isRequired;

  final String? title;
  final String? hintText;

  final ValueChanged<T?> onChanged;

  final List<DropdownItem<T>>? items;

  final FormFieldValidator<T>? validator;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    final hintColor = Theme.of(
      context,
    ).textTheme.bodySmall?.color?.withValues(alpha: .6);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        if (title != null) ...[
          RichText(
            text: TextSpan(
              text: title!,

              style: TextStyle(color: textColor).xs,

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

          SizedBox(height: AppSize.getHeight(6)),
        ],

        DropdownButtonFormField2<T>(
          items: items,

          valueListenable: selected,

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

              color: Theme.of(context).iconTheme.color,
            ),

            openMenuIcon: CustomIcon(
              icon: AppIcons.upArrow,

              width: AppSize.getSize(12),

              height: AppSize.getSize(12),

              color: Theme.of(context).iconTheme.color,
            ),
          ),

          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,

              borderRadius: BorderRadius.circular(12),
            ),
          ),

          decoration: InputDecoration(
            filled: true,

            fillColor: Theme.of(context).cardColor,

            enabled: enabled,

            hintStyle: TextStyle(color: hintColor).xs,

            errorStyle: TextStyle(fontSize: AppSize.font(14)),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: Theme.of(context).dividerColor),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),

            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: const BorderSide(color: Colors.red),
            ),

            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),

              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

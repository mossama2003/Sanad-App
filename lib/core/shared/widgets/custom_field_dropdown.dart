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
          SizedBox(height: AppSize.getHeight(6)),
        ],
        DropdownButtonFormField2<T>(
          items: items,
          valueListenable: selected,
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          style: TextStyle(
            color: AppColors.black,
            fontSize: AppSize.font(14),
            fontWeight: FontWeight.w600,
          ),
          hint: hintText != null && selected.value == null
              ? Text(hintText!, style: TextStyle(color: AppColors.grey).xs)
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
              color: AppColors.grey500,
            ),
            openMenuIcon: CustomIcon(
              icon: AppIcons.upArrow,
              width: AppSize.getSize(12),
              height: AppSize.getSize(12),
              color: AppColors.grey500,
            ),
          ),
          decoration: InputDecoration(
            enabled: enabled,
            hintStyle: TextStyle(color: AppColors.grey).xs,
            errorStyle: TextStyle(fontSize: AppSize.font(14)),
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

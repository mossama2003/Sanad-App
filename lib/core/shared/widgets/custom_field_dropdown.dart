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
    required this.items,
    required this.selected,
    required this.onChanged,
  });

  final ValueNotifier<T?> selected;
  final bool enabled;
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
          Text(title!, style: TextStyle(color: AppColors.grey700).xs),
          SizedBox(height: AppSize.getHeight(6)),
        ],
        DropdownButtonFormField2<T>(
          items: items,
          valueListenable: selected,
          validator: validator,
          iconStyleData: IconStyleData(
            icon: Center(
              child: CustomIcon(
                icon: AppIcons.chevronDown,
                width: AppSize.getSize(24),
                height: AppSize.getSize(24),
                color: AppColors.grey500,
              ),
            ),
          ),
          menuItemStyleData: MenuItemStyleData(
            padding: AppSize.padding(horizontal: 14),
          ),
          alignment: Alignment.center,
          style: TextStyle(
            color: AppColors.grey900,
          ).sm.copyWith(height: AppSize.fontHeight(16, 20)),
          onChanged: enabled
              ? (value) {
                  selected.value = value;
                  onChanged(value);
                }
              : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          hint: hintText != null && selected.value == null
              ? Text(
                  hintText!,
                  style: TextStyle(
                    color: AppColors.grey900,
                  ).sm.copyWith(height: AppSize.fontHeight(16, 20)),
                )
              : null,
          decoration: InputDecoration(
            enabled: enabled,
            contentPadding: EdgeInsetsDirectional.only(
              end: AppSize.getWidth(14),
              top: AppSize.getHeight(10),
              bottom: AppSize.getHeight(10),
            ),
          ),
        ),
      ],
    );
  }
}

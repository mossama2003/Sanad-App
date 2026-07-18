import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../constant/app_assets.dart';
import '../../constant/app_size.dart';
import '../../style/app_colors.dart';
import '../../style/app_text_style.dart';
import 'custom_icon.dart';

class CustomFieldMultiDropdown<T> extends StatefulWidget {
  const CustomFieldMultiDropdown({
    super.key,
    this.title,
    this.titleSize,
    this.titleColor,
    this.hintText,
    this.enabled = true,
    this.isRequired = false,
    this.borderRadius = 12,
    this.validator,
    required this.items,
    required this.selectedItems,
    required this.onChanged,
  });

  final ValueNotifier<List<T>> selectedItems;

  final bool enabled;
  final bool isRequired;

  final String? title;
  final double? titleSize;
  final Color? titleColor;

  final String? hintText;

  final double borderRadius;

  final List<DropdownItem<T>> items;

  final FormFieldValidator<List<T>>? validator;

  final ValueChanged<List<T>> onChanged;

  @override
  State<CustomFieldMultiDropdown<T>> createState() =>
      _CustomFieldMultiDropdownState<T>();
}

class _CustomFieldMultiDropdownState<T>
    extends State<CustomFieldMultiDropdown<T>> {
  final ValueNotifier<T?> _dropdownValue = ValueNotifier<T?>(null);

  void _toggleItem(T? value) {
    if (value == null) return;

    final list = List<T>.from(widget.selectedItems.value);

    if (list.contains(value)) {
      list.remove(value);
    } else {
      list.add(value);
    }

    widget.selectedItems.value = list;

    widget.onChanged(list);
  }

  @override
  void dispose() {
    _dropdownValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.textTheme.bodyMedium?.color;

    final hintColor = theme.textTheme.bodySmall?.color?.withValues(alpha: .6);

    final borderColor = theme.dividerColor;

    return ValueListenableBuilder<List<T>>(
      valueListenable: widget.selectedItems,

      builder: (context, selected, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            if (widget.title != null) ...[
              RichText(
                text: TextSpan(
                  text: widget.title!,

                  style: TextStyle(
                    color: widget.titleColor ?? textColor,
                    fontSize: widget.titleSize ?? AppSize.font(12),
                    fontWeight: FontWeight.w500,
                  ),

                  children: widget.isRequired
                      ? [
                          TextSpan(
                            text: ' *',

                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: widget.titleSize ?? AppSize.font(12),
                            ),
                          ),
                        ]
                      : [],
                ),
              ),

              SizedBox(height: AppSize.getHeight(6)),
            ],

            DropdownButtonFormField2<T>(
              isExpanded: true,

              items: widget.items.map((item) {
                return DropdownItem<T>(
                  value: item.value,
                  child: StatefulBuilder(
                    builder: (context, menuSetState) {
                      final isItemSelected = widget.selectedItems.value
                          .contains(item.value);

                      return InkWell(
                        onTap: () {
                          _toggleItem(item.value);
                          menuSetState(() {});
                        },

                        child: Row(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            Checkbox(
                              value: isItemSelected,

                              activeColor: AppColors.primary,

                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,

                              onChanged: (_) {
                                _toggleItem(item.value);
                                menuSetState(() {});
                              },
                            ),

                            SizedBox(width: AppSize.getWidth(8)),

                            item.child,
                          ],
                        ),
                      );
                    },
                  ),
                );
              }).toList(),

              valueListenable: _dropdownValue,

              validator: (_) {
                if (widget.isRequired && selected.isEmpty) {
                  return 'validators.required'.tr();
                }

                return widget.validator?.call(selected);
              },

              autovalidateMode: AutovalidateMode.onUserInteraction,

              style: TextStyle(
                color: textColor,

                fontSize: AppSize.font(14),

                fontWeight: FontWeight.w600,
              ),

              hint: selected.isEmpty
                  ? Text(
                      widget.hintText ?? '',

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(color: hintColor).xs,
                    )
                  : Text(
                      selected.join(', '),

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(color: textColor).xs,
                    ),

              onChanged: (_) {},

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

                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
              ),

              decoration: InputDecoration(
                filled: true,

                fillColor: theme.cardColor,

                enabled: widget.enabled,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),

                  borderSide: BorderSide(color: borderColor),
                ),

                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),

                  borderSide: BorderSide(color: borderColor),
                ),

                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),

                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),

                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),

                  borderSide: const BorderSide(color: Colors.red),
                ),

                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(widget.borderRadius),

                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

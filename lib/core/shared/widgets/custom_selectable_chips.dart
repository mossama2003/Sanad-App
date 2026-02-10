import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class CustomSelectableChips extends StatefulWidget {
  final List<String> items;
  final String title;

  /// لو true → Multi select
  /// لو false → Single select
  final bool multiSelect;

  /// initial selected values
  final List<String>? initialSelected;

  /// callback
  final ValueChanged<List<String>>? onChanged;

  const CustomSelectableChips({
    super.key,
    required this.items,
    this.title = '',
    this.multiSelect = true,
    this.initialSelected,
    this.onChanged,
  });

  @override
  State<CustomSelectableChips> createState() => _CustomSelectableChipsState();
}

class _CustomSelectableChipsState extends State<CustomSelectableChips> {
  late List<String> selectedItems;

  @override
  void initState() {
    super.initState();
    selectedItems = List.from(widget.initialSelected ?? []);
  }

  void _onTap(String item) {
    setState(() {
      if (widget.multiSelect) {
        // 🟢 Multi select
        if (selectedItems.contains(item)) {
          selectedItems.remove(item);
        } else {
          selectedItems.add(item);
        }
      } else {
        // 🔵 Single select
        if (selectedItems.contains(item)) {
          selectedItems.clear();
        } else {
          selectedItems
            ..clear()
            ..add(item);
        }
      }
    });

    widget.onChanged?.call(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmpty) ...[
          Text(
            widget.title,
            style: TextStyle(
              color: AppColors.grey700,
              fontSize: AppSize.font(12),
            ),
          ),
          SizedBox(height: AppSize.getHeight(8)),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.items.map((item) {
            final isSelected = selectedItems.contains(item);

            return GestureDetector(
              onTap: () => _onTap(item),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: AppSize.padding(vertical: 6, horizontal: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.grey100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                  ),
                ),
                child: Text(
                  item,
                  style: TextStyle(
                    color: isSelected ? AppColors.white : AppColors.black,
                    fontSize: AppSize.font(13),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

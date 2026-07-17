import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

enum ChipsLayout { scroll, wrap }

class CustomSelectableChips extends StatefulWidget {
  final List<String> items;
  final String title;

  final bool multiSelect;

  final List<String>? initialSelected;

  final ValueChanged<List<String>>? onChanged;

  final Color selectedColor;
  final Color selectedTextColor;
  final Color unSelectedTextColor;
  final Color borderColor;
  final Color? backgroundColor;

  final ChipsLayout layout;

  const CustomSelectableChips({
    super.key,
    required this.items,
    this.title = '',
    this.multiSelect = true,
    this.initialSelected,
    this.onChanged,
    this.selectedColor = AppColors.primary,
    this.selectedTextColor = AppColors.white,
    this.unSelectedTextColor = AppColors.primary,
    this.borderColor = AppColors.primary,
    this.backgroundColor,
    this.layout = ChipsLayout.scroll,
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
        if (selectedItems.contains(item)) {
          selectedItems.remove(item);
        } else {
          selectedItems.add(item);
        }
      } else {
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

  Widget _buildChip(String item) {
    final isSelected = selectedItems.contains(item);

    return GestureDetector(
      onTap: () => _onTap(item),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppSize.padding(vertical: 6, horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? widget.selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: widget.borderColor, width: 1),
        ),
        child: Text(
          item,
          style: TextStyle(
            color: isSelected
                ? widget.selectedTextColor
                : widget.unSelectedTextColor,
            fontSize: AppSize.font(13),
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.isNotEmpty) ...[
            Text(
              widget.title,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppSize.font(12),
              ),
            ),
            SizedBox(height: AppSize.getHeight(8)),
          ],

          widget.layout == ChipsLayout.scroll
              ? SizedBox(
                  height: AppSize.getHeight(30),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: Row(
                      children: widget.items.map((item) {
                        return Padding(
                          padding: AppSize.padding(end: AppSize.getWidth(5)),
                          child: _buildChip(item),
                        );
                      }).toList(),
                    ),
                  ),
                )
              : Wrap(
                  spacing: AppSize.getWidth(5),
                  runSpacing: AppSize.getHeight(8),
                  children: widget.items.map((item) {
                    return _buildChip(item);
                  }).toList(),
                ),
        ],
      ),
    );
  }
}

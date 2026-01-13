import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class CustomRadio<T> extends StatelessWidget {
  const CustomRadio({
    super.key,
    required this.title,
    required this.value,
    required this.onChange,
    required this.groupValue,
  });

  final T value;
  final String title;
  final T? groupValue;
  final Function(T?) onChange;

  @override
  Widget build(BuildContext context) {
    bool isSelected = value == groupValue;
    return Row(
      children: [
        RadioGroup(
          groupValue: groupValue,
          onChanged: onChange,
          child: SizedBox(
            width: AppSize.getSize(24),
            height: AppSize.getSize(24),
            child: Radio<T>(
              value: value,
              activeColor: AppColors.primary,
            ),
          ),
        ),
        SizedBox(width: AppSize.getSize(12)),
        Expanded(
          child: InkWell(
            onTap: () => onChange(value),
            child: Text(
              title,
              style: TextStyle(
                color: AppColors.black,
                fontSize: AppSize.font(16),
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../constant/app_size.dart';

class CustomChip extends StatelessWidget {
  const CustomChip({
    super.key,
    this.name,
    this.onTap,
  });

  final String? name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSize.getSize(16)),
      child: Container(
        padding: AppSize.padding(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xffFFB6CF)),
          color: const Color(0xffFFF5F9),
          borderRadius: BorderRadius.circular(AppSize.getSize(16)),
        ),
        child: Text(
          name ?? 'loading',
          style: TextStyle(
            fontSize: AppSize.getSize(12),
            height: AppSize.fontHeight(12, 20),
            fontWeight: FontWeight.w500,
            color: const Color(0xff851D41),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class CustomSheet extends StatelessWidget {
  const CustomSheet({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CustomSheetHeader(),
            if (padding != null)
              Padding(padding: padding!, child: child)
            else
              child,
          ],
        ),
      ),
    );
  }
}

class _CustomSheetHeader extends StatelessWidget {
  const _CustomSheetHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSize.padding(vertical: 22),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: Center(
        child: Container(
          width: AppSize.getWidth(60),
          height: AppSize.getHeight(6),
          decoration: BoxDecoration(
            color: AppColors.grey200,
            borderRadius: BorderRadius.circular(AppSize.getSize(24)),
          ),
        ),
      ),
    );
  }
}

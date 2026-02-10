import 'package:flutter/material.dart';

import '../../style/app_colors.dart';

class CustomProgressBar extends StatelessWidget {
  final double percent;
  final Color? color;
  final Color? bgColor;
  final double height;

  const CustomProgressBar({
    super.key,
    required this.percent,
    this.color,
    this.bgColor,
    this.height = 11,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (percent / 100).clamp(0.0, 1.0);

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LinearProgressIndicator(
        value: progress,
        minHeight: height,
        backgroundColor: bgColor ?? AppColors.grey200,
        valueColor: AlwaysStoppedAnimation(color ?? AppColors.primary),
      ),
    );
  }
}

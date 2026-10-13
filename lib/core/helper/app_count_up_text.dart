import 'package:flutter/material.dart';

class AppCountUpText extends StatelessWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String suffix;

  const AppCountUpText({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 1000),
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: duration,
      curve: Curves.linear,
      builder: (context, currentValue, child) {
        return Text(
          '$currentValue$suffix',
          style: style,
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}

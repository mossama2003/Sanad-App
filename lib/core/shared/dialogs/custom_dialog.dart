import 'package:flutter/material.dart';

import '../../constant/app_size.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        vertical: AppSize.getHeight(20),
        horizontal: AppSize.getWidth(20),
      ),
      child: SingleChildScrollView(
        padding: AppSize.padding(horizontal: 20, vertical: 30),
        child: Column(mainAxisSize: MainAxisSize.min, children: children),
      ),
    );
  }
}

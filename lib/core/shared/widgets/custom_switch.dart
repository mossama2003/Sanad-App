import 'package:flutter/cupertino.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({super.key, required this.value, this.onChanged});

  final bool value;
  final Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSize.getWidth(44),
      height: AppSize.getHeight(24),
      child: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: AppColors.brand600,
        inactiveTrackColor: AppColors.grey200,
      ),
    );
  }
}

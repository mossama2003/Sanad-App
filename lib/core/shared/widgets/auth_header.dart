import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key, required this.title, required this.desc});

  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textBlack,
            fontSize: AppSize.font(22),
            height: AppSize.fontHeight(22, 28),
          ),
        ),
        SizedBox(height: AppSize.getHeight(8)),
        Text(
          desc,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.textGrey,
            fontSize: AppSize.font(16),
            height: AppSize.fontHeight(16, 22),
          ),
        ),
      ],
    );
  }
}

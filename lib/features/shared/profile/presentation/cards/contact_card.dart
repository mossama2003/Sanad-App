import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/style/app_colors.dart';

class ContactCard extends StatelessWidget {
  final String email;
  final String phone;

  const ContactCard({super.key, required this.email, required this.phone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.grey.withValues(alpha: 0.2),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppSize.padding(all: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'shared.profile.contact_information'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(16),
              fontWeight: FontWeight.w700,
            ),
          ),

          SizedBox(height: AppSize.getHeight(14)),

          _ContactRow(icon: AppIcons.email, text: email),

          SizedBox(height: AppSize.getHeight(10)),

          _ContactRow(icon: AppIcons.phone, text: phone),
        ],
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final String icon;
  final String text;

  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIcon(
          icon: icon,
          color: AppColors.black,
          width: AppSize.getWidth(18),
          height: AppSize.getHeight(18),
        ),
        SizedBox(width: AppSize.getHeight(10)),
        Text(
          text,
          style: TextStyle(fontSize: AppSize.font(13), color: AppColors.black),
        ),
      ],
    );
  }
}

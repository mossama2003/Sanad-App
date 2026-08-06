import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/style/app_colors.dart';

class ReportChatBottomSheet extends StatelessWidget {
  const ReportChatBottomSheet({super.key, required this.onReport});

  final ValueChanged<String?> onReport;

  @override
  Widget build(BuildContext context) {
    final reasonController = TextEditingController();

    return Padding(
      padding: AppSize.padding(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: AppSize.padding(all: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: AppSize.getWidth(40),
                height: AppSize.getHeight(4),
                margin: AppSize.margin(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.grey500,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Text(
              'shared.chat.report_chat'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(18),
                fontWeight: FontWeight.w700,
                color: AppColors.black,
              ),
            ),

            SizedBox(height: AppSize.getHeight(6)),

            Text(
              'shared.chat.report_subtitle'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(13),
                color: AppColors.grey500,
              ),
            ),

            SizedBox(height: AppSize.getHeight(16)),

            CustomFieldText(
              controller: reasonController,
              hintText: 'shared.chat.report_reason_hint'.tr(),
              minLines: 3,
              maxLines: 5,
            ),

            SizedBox(height: AppSize.getHeight(20)),

            CustomButton(
              title: 'shared.chat.report_chat'.tr(),
              bgColor: AppColors.red,
              onTap: () {
                AppNavigator.pop();

                final reason = reasonController.text.trim();

                onReport(reason.isEmpty ? null : reason);
              },
            ),
          ],
        ),
      ),
    );
  }
}

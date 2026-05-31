import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../forms/cases_form.dart';

class SubmitCaseScreen extends StatefulWidget {
  const SubmitCaseScreen({super.key});

  @override
  State<SubmitCaseScreen> createState() => _SubmitCaseScreenState();
}

class _SubmitCaseScreenState extends State<SubmitCaseScreen> {
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => showForm = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: AppSize.padding(horizontal: 16, vertical: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'shared.cases.submit.title'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(20),
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1A1A2E),
                          ),
                        ),
                        SizedBox(height: AppSize.getHeight(4)),
                        Text(
                          'shared.cases.submit.desc'.tr(),
                          style: TextStyle(
                            fontSize: AppSize.font(13),
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => AppNavigator.pop(),
                    child: Container(
                      width: AppSize.getSize(36),
                      height: AppSize.getSize(36),
                      decoration: BoxDecoration(
                        color: AppColors.grey.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: CustomIcon(
                          icon: AppIcons.close,
                          color: AppColors.black,
                          width: AppSize.getSize(25),
                          height: AppSize.getSize(25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────────────
            Expanded(
              child: AnimatedSlide(
                offset: showForm ? Offset.zero : const Offset(0, 0.3),
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                child: AnimatedOpacity(
                  opacity: showForm ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: SingleChildScrollView(
                    padding: AppSize.padding(horizontal: 16, bottom: 24),
                    child: const CasesForm(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

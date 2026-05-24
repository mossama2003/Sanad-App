import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/app_text_style.dart';
import '../../data/models/onboarding_model.dart';

class OnboardingCard extends StatelessWidget {
  final OnboardingModel onboarding;

  const OnboardingCard({super.key, required this.onboarding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              onboarding.image,
              width: double.infinity,
              height: MediaQuery.sizeOf(context).height * 0.38,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            onboarding.titleKey.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.black).xl,
          ),
          const SizedBox(height: 12),
          Text(
            onboarding.descKey.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.grey).sm,
          ),
        ],
      ),
    );
  }
}

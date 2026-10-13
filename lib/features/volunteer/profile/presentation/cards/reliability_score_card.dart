import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/shared/widgets/custom_progress_bar.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_count_up_text.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';

class ReliabilityScoreCard extends StatelessWidget {
  final ReliabilityScoreModel? reliabilityScore;

  const ReliabilityScoreCard({super.key, required this.reliabilityScore});

  double _normalizedPercentage(double? value) {
    final percentage = ((value ?? 0) * 100).round();
    return percentage.clamp(0, 100).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final int score = (reliabilityScore?.totalScore ?? 0).clamp(0, 100).toInt();

    final participation = _normalizedPercentage(
      reliabilityScore?.participationRate,
    );

    final completion = _normalizedPercentage(reliabilityScore?.completionRate);

    final emergency = _normalizedPercentage(
      reliabilityScore?.emergencyResponseRate,
    );

    final cases = _normalizedPercentage(reliabilityScore?.casesEngagementScore);

    final donations = _normalizedPercentage(
      reliabilityScore?.donationsEngagementScore,
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.grey900.withValues(alpha: 0.2),
          width: 0.7,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey900.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: AppSize.padding(all: 15),
      child: Column(
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.starOutlined,
                color: AppColors.white,
                width: AppSize.getSize(18),
                height: AppSize.getSize(18),
              ),

              SizedBox(width: AppSize.getWidth(5)),

              Expanded(
                child: Text(
                  'volunteer.profile.reliability_score'.tr(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSize.font(15),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  AppCountUpText(
                    value: score,
                    duration: const Duration(milliseconds: 800),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),

                  Text(
                    '/100',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(16)),

          CustomProgressBar(
            height: AppSize.getSize(6),
            percent: (score / 100) * 100,
            color: AppColors.white,
            bgColor: AppColors.white.withValues(alpha: 0.2),
          ),

          SizedBox(height: AppSize.getHeight(16)),

          Row(
            children: [
              _ScoreItem(
                title: 'volunteer.profile.attendance_rate'.tr(),
                value: participation,
              ),
              _ScoreItem(
                title: 'volunteer.profile.completion_rate'.tr(),
                value: completion,
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(12)),

          Row(
            children: [
              _ScoreItem(
                title: 'volunteer.profile.emergency_response'.tr(),
                value: emergency,
              ),
              _ScoreItem(
                title: 'volunteer.profile.cases_engagement'.tr(),
                value: cases,
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(12)),

          Row(
            children: [
              _ScoreItem(
                title: 'volunteer.profile.donations_engagement'.tr(),
                value: donations,
              ),
              const Expanded(child: SizedBox()),
            ],
          ),

          SizedBox(height: AppSize.getHeight(16)),

          Container(
            width: double.infinity,
            padding: AppSize.padding(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'volunteer.profile.priority_access'.tr(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSize.font(13),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(4)),

                Text(
                  'volunteer.profile.priority_access_desc'.tr(),
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.75),
                    fontSize: AppSize.font(11),
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(8)),

                Text(
                  score >= 80
                      ? 'volunteer.profile.available'.tr()
                      : 'volunteer.profile.not_available'.tr(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: AppSize.font(13),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String title;
  final double value;

  const _ScoreItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSize.font(12),
              fontWeight: FontWeight.w400,
            ),
          ),

          SizedBox(height: AppSize.getHeight(3)),

          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              AppCountUpText(
                value: value.round(),
                duration: const Duration(milliseconds: 700),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w700,
                ),
                suffix: '%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

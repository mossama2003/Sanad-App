import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/shared/widgets/custom_progress_bar.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';

class ReliabilityScoreCard extends StatelessWidget {
  final ReliabilityScoreModel? reliabilityScore;

  const ReliabilityScoreCard({super.key, required this.reliabilityScore});

  String _percentage(double? value) {
    return '${((value ?? 0) * 100).round()}%';
  }

  @override
  Widget build(BuildContext context) {
    final score = reliabilityScore?.totalScore ?? 0;

    final participation = reliabilityScore?.participationRate ?? 0;

    final completion = reliabilityScore?.completionRate ?? 0;

    final emergency = reliabilityScore?.emergencyResponseRate ?? 0;

    final cases = reliabilityScore?.casesEngagementScore ?? 0;

    final donations = reliabilityScore?.donationsEngagementScore ?? 0;

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

              Text(
                'volunteer.profile.reliability_score'.tr(),
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: AppSize.font(15),
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '$score',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                    TextSpan(
                      text: '/100',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(16)),

          CustomProgressBar(
            height: AppSize.getSize(6),
            percent: ((score / 100).clamp(0.0, 1.0) * 100),
            color: AppColors.white,
            bgColor: AppColors.white.withValues(alpha: 0.2),
          ),

          SizedBox(height: AppSize.getHeight(16)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ScoreItem(
                title: 'volunteer.profile.attendance_rate'.tr(),
                value: _percentage(participation),
              ),
              _ScoreItem(
                title: 'volunteer.profile.completion_rate'.tr(),
                value: _percentage(completion),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(12)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ScoreItem(
                title: 'volunteer.profile.emergency_response'.tr(),
                value: _percentage(emergency),
              ),
              _ScoreItem(
                title: 'volunteer.profile.cases_engagement'.tr(),
                value: _percentage(cases),
              ),
            ],
          ),

          SizedBox(height: AppSize.getHeight(12)),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ScoreItem(
                title: 'volunteer.profile.donations_engagement'.tr(),
                value: _percentage(donations),
              ),
              _ScoreItem(
                title: 'volunteer.profile.priority_access'.tr(),
                value: score >= 80
                    ? 'volunteer.profile.available'.tr()
                    : 'volunteer.profile.not_available'.tr(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreItem extends StatelessWidget {
  final String title;
  final String value;

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
          Text(
            value,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSize.font(13),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/enums/rewards_enum.dart';
import '../../data/models/rewards_model.dart';

class LevelRewardsCard extends StatelessWidget {
  final List<RewardsModel> rewards;

  const LevelRewardsCard({
    super.key,
    required this.rewards,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: textColor.withValues(alpha: .12),
          width: .7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? .2 : .05,
            ),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIcon(
                icon: AppIcons.cup,
                color: AppColors.gold,
                width: AppSize.getWidth(20),
                height: AppSize.getHeight(20),
              ),
              SizedBox(width: AppSize.getWidth(6)),
              Text(
                'shared.rewards.level_rewards'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(16),
                  fontWeight: FontWeight.w700,
                  color: textColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSize.getHeight(14)),
          ...rewards.map(
                (r) => _RewardRow(reward: r),
          ),
        ],
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  final RewardsModel reward;

  const _RewardRow({required this.reward});

  bool get _isUnlocked => reward.status == RewardStatus.unlocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);

    final unlockedBackground =
    AppColors.primary.withValues(alpha: .08);

    final lockedBackground = textColor.withValues(alpha: .06);

    final lockedCircleColor = textColor.withValues(alpha: .12);

    return Padding(
      padding: AppSize.padding(vertical: 6),
      child: Container(
        padding: AppSize.padding(all: 12),
        decoration: BoxDecoration(
          color: _isUnlocked
              ? unlockedBackground
              : lockedBackground,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: AppSize.getSize(40),
              height: AppSize.getSize(40),
              decoration: BoxDecoration(
                color: _isUnlocked
                    ? AppColors.primary
                    : lockedCircleColor,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                '${reward.level}',
                style: TextStyle(
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w700,
                  color: _isUnlocked
                      ? AppColors.white
                      : secondaryColor,
                ),
              ),
            ),
            SizedBox(width: AppSize.getWidth(12)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    style: TextStyle(
                      fontSize: AppSize.font(14),
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  Text(
                    reward.subtitle,
                    style: TextStyle(
                      fontSize: AppSize.font(12),
                      color: secondaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _isUnlocked
                  ? 'shared.rewards.unlocked'.tr()
                  : 'shared.rewards.locked'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(13),
                fontWeight: FontWeight.w600,
                color: _isUnlocked
                    ? AppColors.primary
                    : secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

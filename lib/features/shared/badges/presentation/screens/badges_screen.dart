import 'package:sanad_app/features/shared/badges/presentation/widgets/tab_bar_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../data/models/badges_model.dart';
import '../../data/enums/badges_enum.dart';
import '../cards/collection_card.dart';
import '../cards/badge_card.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  int _selectedTab = 0;

  static const _allBadges = [
    BadgeModel(
      emoji: '🌱',
      name: 'First Steps',
      tier: BadgeTier.bronze,
      status: BadgeStatus.earned,
    ),
    BadgeModel(
      emoji: '🩸',
      name: 'Blood Hero',
      tier: BadgeTier.gold,
      status: BadgeStatus.earned,
    ),
    BadgeModel(
      emoji: '🌳',
      name: 'Tree Hugger',
      tier: BadgeTier.silver,
      status: BadgeStatus.inProgress,
    ),
    BadgeModel(
      emoji: '⭐',
      name: 'Community Star',
      tier: BadgeTier.silver,
      status: BadgeStatus.inProgress,
    ),
    BadgeModel(
      emoji: '🤝',
      name: 'Helping Hand',
      tier: BadgeTier.bronze,
      status: BadgeStatus.earned,
    ),
    BadgeModel(
      emoji: '🏆',
      name: 'Streak Master',
      tier: BadgeTier.gold,
      status: BadgeStatus.inProgress,
      progress: 7,
      total: 30,
    ),
  ];

  List<BadgeModel> get _filteredBadges {
    if (_selectedTab == 1) {
      return _allBadges.where((b) => b.status == BadgeStatus.earned).toList();
    }

    if (_selectedTab == 2) {
      return _allBadges
          .where((b) => b.status == BadgeStatus.inProgress)
          .toList();
    }

    return _allBadges;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);

    final backgroundColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSize.padding(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'shared.badges.badges'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(22),
                  fontWeight: FontWeight.w800,
                  color: textColor,
                ),
              ),
              Text(
                'shared.badges.earn_badges'.tr(),
                style: TextStyle(
                  fontSize: AppSize.font(15),
                  color: secondaryColor,
                ),
              ),
              SizedBox(height: AppSize.getHeight(20)),
              const CollectionCard(
                collected: 5,
                total: 12,
                gold: 1,
                silver: 2,
                bronze: 2,
              ),
              SizedBox(height: AppSize.getHeight(20)),
              TabBarWidget(
                selected: _selectedTab,
                onTap: (i) => setState(() => _selectedTab = i),
                allCount: _allBadges.length,
                earnedCount: _allBadges
                    .where((b) => b.status == BadgeStatus.earned)
                    .length,
                inProgressCount: _allBadges
                    .where((b) => b.status == BadgeStatus.inProgress)
                    .length,
              ),
              SizedBox(height: AppSize.getHeight(20)),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _filteredBadges.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 185,
                ),
                itemBuilder: (_, i) => BadgeCard(badge: _filteredBadges[i]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

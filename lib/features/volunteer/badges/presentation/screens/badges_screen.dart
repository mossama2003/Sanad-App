import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/badges_model.dart';
import '../../data/repos/badges_repo.dart';
import '../cards/collection_card.dart';
import '../cards/badge_card.dart';
import '../controllers/badges_cubit.dart';
import '../widgets/tab_bar_widget.dart';

class BadgesScreen extends StatefulWidget {
  const BadgesScreen({super.key});

  @override
  State<BadgesScreen> createState() => _BadgesScreenState();
}

class _BadgesScreenState extends State<BadgesScreen> {
  late final BadgesCubit cubit;

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    cubit = BadgesCubit(BadgesRepoImpel());
    cubit.getAllBadges();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  List<BadgeModel> _getFilteredBadges(List<BadgeModel> badges) {
    if (_selectedTab == 1) {
      return badges.where((badge) => badge.isEarned).toList();
    }

    return badges;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<BadgesCubit, BadgesState>(
        builder: (context, state) {
          final theme = Theme.of(context);
          final textColor = theme.colorScheme.onSurface;
          final secondaryColor = textColor.withValues(alpha: 0.6);
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
              child: _buildBody(context, state, textColor, secondaryColor),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    BadgesState state,
    Color textColor,
    Color secondaryColor,
  ) {
    // Loading
    if (state is Loading || state is Initial) {
      return const Center(child: CircularProgressIndicator());
    }

    // Error
    if (state is Error) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: AppSize.padding(horizontal: 16),
        children: [
          SizedBox(height: AppSize.getHeight(150)),
          Icon(
            Icons.error_outline,
            size: AppSize.getSize(45),
            color: AppColors.red,
          ),
          SizedBox(height: AppSize.getHeight(12)),
          Padding(
            padding: AppSize.padding(horizontal: 8),
            child: Text(
              'core.error_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor, fontSize: AppSize.font(14)),
            ),
          ),
        ],
      );
    }

    // Success
    if (state is Success) {
      final List<BadgeModel> badges = state.badges;

      final earnedBadges = badges.where((badge) => badge.isEarned).toList();

      final filteredBadges = _getFilteredBadges(badges);

      final totalBadges = cubit.totalCount;

      return RefreshIndicator(
        onRefresh: cubit.refreshBadges,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: AppSize.padding(horizontal: 16, bottom: 24),
          children: [
            // Title
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

            // Collection
            CollectionCard(collected: earnedBadges.length, total: totalBadges),

            SizedBox(height: AppSize.getHeight(20)),

            // Tabs
            TabBarWidget(
              selected: _selectedTab,
              onTap: (index) {
                setState(() {
                  _selectedTab = index;
                });
              },
              allCount: totalBadges,
              earnedCount: earnedBadges.length,
            ),

            SizedBox(height: AppSize.getHeight(20)),

            // Empty state
            if (filteredBadges.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.getHeight(45)),
                child: Column(
                  children: [
                    Icon(
                      Icons.workspace_premium_outlined,
                      size: AppSize.getSize(45),
                      color: secondaryColor,
                    ),
                    SizedBox(height: AppSize.getHeight(12)),
                    Text(
                      _selectedTab == 1
                          ? 'No earned badges yet'
                          : 'No badges found',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppSize.font(14),
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              // Badges grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredBadges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 185,
                ),
                itemBuilder: (context, index) {
                  return BadgeCard(badge: filteredBadges[index]);
                },
              ),
          ],
        ),
      );
    }

    // Fallback
    return const Center(child: CircularProgressIndicator());
  }
}

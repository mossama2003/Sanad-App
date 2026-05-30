import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../rewards/presentation/screens/rewards_screen.dart';
import '../cards/badges_card.dart';
import '../cards/contact_card.dart';
import '../cards/settings_card.dart';
import '../cards/stats_card.dart';
import '../sections/avatar_section.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5F7),
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSize.padding(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              // ── Avatar + Name ──────────────────────────────────────────
              AvatarSection(),
              SizedBox(height: AppSize.getHeight(24)),

              // ── Stats Grid ────────────────────────────────────────────
              GestureDetector(
                onTap: () => AppNavigator.push(RewardsScreen()),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.50,
                  children: [
                    StatCard(
                      icon: AppIcons.voltage,
                      iconColor: Color(0xFF7B5EA7),
                      value: '2,450',
                      label: 'shared.profile.xp'.tr(),
                    ),
                    StatCard(
                      icon: AppIcons.fire,
                      iconColor: Color(0xFFFF6B35),
                      value: '7',
                      label: 'shared.profile.streak'.tr(),
                    ),
                    StatCard(
                      icon: AppIcons.calendar,
                      iconColor: Color(0xFF2ECFA0),
                      value: '24',
                      label: 'shared.profile.attended'.tr(),
                    ),
                    StatCard(
                      icon: AppIcons.donations,
                      iconColor: Color(0xFFE05C5C),
                      value: 'EGP 12.5K',
                      label: 'shared.profile.donations'.tr(),
                      smallValue: true,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSize.getHeight(16)),

              // ── Badges ────────────────────────────────────────────────
              BadgesCard(),
              SizedBox(height: AppSize.getHeight(16)),

              // ── Contact Info ──────────────────────────────────────────
              ContactCard(
                email: 'mossama270@gmail.com',
                phone: '+201129304599',
              ),
              SizedBox(height: AppSize.getHeight(16)),

              // ── Settings ──────────────────────────────────────────
              SettingsCard(),
            ],
          ),
        ),
      ),
    );
  }
}

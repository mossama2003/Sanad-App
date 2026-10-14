import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/constant/app_size.dart';
import '../core/style/app_colors.dart';

class DonationsComingSoonScreen extends StatelessWidget {
  const DonationsComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isCompact = constraints.maxHeight < 650;

            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 40,
              ),
              child: Padding(
                padding: AppSize.padding(horizontal: 24, vertical: 20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 430),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildDonationIllustration(
                          context,
                          height: isCompact ? 240 : 310,
                          isDark: isDark,
                        ),

                        SizedBox(
                          height: AppSize.getHeight(isCompact ? 12 : 24),
                        ),

                        _buildTitle(context, textColor: textColor),

                        SizedBox(height: AppSize.getHeight(12)),

                        _buildDescription(context, textColor: textColor),

                        SizedBox(
                          height: AppSize.getHeight(isCompact ? 20 : 30),
                        ),

                        _buildStatus(context),

                        SizedBox(height: AppSize.getHeight(20)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // Donation Illustration
  // ============================================================

  Widget _buildDonationIllustration(
    BuildContext context, {
    required double height,
    required bool isDark,
  }) {
    final primary = AppColors.primary;
    const green = Color(0xFF35B99A);
    final surface = Theme.of(context).cardColor;

    return SizedBox(
      height: AppSize.getHeight(height),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Background circle
              Container(
                width: constraints.maxWidth * 0.78,
                height: constraints.maxWidth * 0.78,
                constraints: const BoxConstraints(
                  maxWidth: 300,
                  maxHeight: 300,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withValues(alpha: isDark ? 0.10 : 0.06),
                ),
              ),

              // Main donation box
              Center(
                child: Container(
                  width: AppSize.getWidth(180),
                  height: AppSize.getHeight(170),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: primary.withValues(alpha: 0.12)),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.10),
                        blurRadius: 28,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      // Donation box body
                      Positioned(
                        left: 14,
                        right: 14,
                        top: 42,
                        bottom: 14,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                primary,
                                primary.withValues(alpha: 0.80),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(19),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.volunteer_activism_rounded,
                              size: AppSize.getSize(66),
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      // Box lid
                      Positioned(
                        top: 34,
                        left: 8,
                        right: 8,
                        child: Container(
                          height: AppSize.getHeight(22),
                          decoration: BoxDecoration(
                            color: const Color(0xFF35B99A),
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),

                      // Coin entering the box
                      Positioned(
                        top: 0,
                        child: Container(
                          width: AppSize.getSize(40),
                          height: AppSize.getSize(40),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD98C),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFEDAA42),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.attach_money_rounded,
                            color: const Color(0xFFAD741E),
                            size: AppSize.getSize(26),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating heart
              Positioned(
                top: 12,
                right: constraints.maxWidth * 0.10,
                child: _buildFloatingIcon(
                  context,
                  icon: Icons.favorite_rounded,
                  color: const Color(0xFFFF8292),
                  size: 58,
                ),
              ),

              // Floating coins
              Positioned(
                left: constraints.maxWidth * 0.08,
                top: 65,
                child: _buildFloatingIcon(
                  context,
                  icon: Icons.monetization_on_rounded,
                  color: const Color(0xFFFFC85C),
                  size: 48,
                ),
              ),

              // Helping hands
              Positioned(
                right: constraints.maxWidth * 0.06,
                bottom: 10,
                child: _buildFloatingIcon(
                  context,
                  icon: Icons.volunteer_activism_rounded,
                  color: green,
                  size: 54,
                ),
              ),

              // Decorative plant
              Positioned(
                left: 0,
                bottom: 0,
                child: Icon(
                  Icons.eco_rounded,
                  size: AppSize.getSize(58),
                  color: green.withValues(alpha: 0.85),
                ),
              ),

              // Sparkle
              Positioned(
                left: constraints.maxWidth * 0.26,
                top: 10,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  size: AppSize.getSize(24),
                  color: green,
                ),
              ),

              // Small decorative dot
              Positioned(
                right: constraints.maxWidth * 0.25,
                top: 85,
                child: Container(
                  width: AppSize.getSize(9),
                  height: AppSize.getSize(9),
                  decoration: const BoxDecoration(
                    color: green,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // Floating Icon
  // ============================================================

  Widget _buildFloatingIcon(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required double size,
  }) {
    return Container(
      width: AppSize.getSize(size),
      height: AppSize.getSize(size),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(19),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: AppSize.getSize(size * 0.53)),
    );
  }

  // ============================================================
  // Title
  // ============================================================

  Widget _buildTitle(BuildContext context, {required Color textColor}) {
    return Text(
      'coming_soon.donations_coming_soon_title'.tr(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: AppSize.font(25),
        fontWeight: FontWeight.w800,
        color: textColor,
        height: 1.4,
      ),
    );
  }

  // ============================================================
  // Description
  // ============================================================

  Widget _buildDescription(BuildContext context, {required Color textColor}) {
    return Padding(
      padding: AppSize.padding(horizontal: 8),
      child: Text(
        'coming_soon.donations_coming_soon_description'.tr(),
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: AppSize.font(15),
          color: textColor.withValues(alpha: 0.60),
          height: 1.9,
        ),
      ),
    );
  }

  // ============================================================
  // Status Badge
  // ============================================================

  Widget _buildStatus(BuildContext context) {
    const green = Color(0xFF35B99A);

    return Container(
      padding: AppSize.padding(horizontal: 20, vertical: 13),
      decoration: BoxDecoration(
        color: green.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: green.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: AppSize.getSize(21),
            color: green,
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Container(
            width: 1,
            height: AppSize.getHeight(22),
            color: green.withValues(alpha: 0.30),
          ),
          SizedBox(width: AppSize.getWidth(10)),
          Text(
            'coming_soon.status'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(14),
              fontWeight: FontWeight.w700,
              color: green,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/constant/app_size.dart';
import '../core/style/app_colors.dart';

class DashboardComingSoonScreen extends StatelessWidget {
  const DashboardComingSoonScreen({super.key});

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
                        _buildIllustration(
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
  // Illustration
  // ============================================================

  Widget _buildIllustration(
    BuildContext context, {
    required double height,
    required bool isDark,
  }) {
    final primary = AppColors.primary;
    const green = Color(0xFF35B99A);

    return SizedBox(
      height: AppSize.getHeight(height),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Background
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

              // Dashboard mockup
              Positioned(
                left: constraints.maxWidth * 0.08,
                right: constraints.maxWidth * 0.08,
                top: 35,
                bottom: 25,
                child: _DashboardMockup(primary: primary, green: green),
              ),

              // Floating dashboard icon
              Positioned(
                top: 5,
                right: constraints.maxWidth * 0.08,
                child: Container(
                  width: AppSize.getSize(62),
                  height: AppSize.getSize(62),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primary.withValues(alpha: 0.13),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.dashboard_customize_rounded,
                    size: AppSize.getSize(34),
                    color: primary,
                  ),
                ),
              ),

              // Decorative plant
              Positioned(
                left: 0,
                bottom: 0,
                child: Icon(
                  Icons.eco_rounded,
                  size: AppSize.getSize(62),
                  color: green.withValues(alpha: 0.85),
                ),
              ),

              // Construction icon
              Positioned(
                right: 0,
                bottom: 2,
                child: Container(
                  width: AppSize.getSize(46),
                  height: AppSize.getSize(46),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0D8),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(
                    Icons.construction_rounded,
                    color: const Color(0xFFEDAA42),
                    size: AppSize.getSize(27),
                  ),
                ),
              ),

              // Sparkle
              Positioned(
                left: constraints.maxWidth * 0.20,
                top: 15,
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: green,
                  size: AppSize.getSize(24),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ============================================================
  // Title
  // ============================================================

  Widget _buildTitle(BuildContext context, {required Color textColor}) {
    return Text(
      'coming_soon.dashboard_coming_soon_title'.tr(),
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
        'coming_soon.dashoard_coming_soon_description'.tr(),
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

// ============================================================
// Dashboard Mockup
// ============================================================

class _DashboardMockup extends StatelessWidget {
  const _DashboardMockup({required this.primary, required this.green});

  final Color primary;
  final Color green;

  @override
  Widget build(BuildContext context) {
    final surface = Theme.of(context).cardColor;

    return Transform.rotate(
      angle: -0.035,
      child: Container(
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(23),
          border: Border.all(color: primary.withValues(alpha: 0.12)),
          boxShadow: [
            BoxShadow(
              color: primary.withValues(alpha: 0.10),
              blurRadius: 25,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            // Sidebar
            Container(
              width: 43,
              decoration: BoxDecoration(
                color: const Color(0xFF23446F),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _sidebarIcon(Icons.home_rounded, selected: true),
                  _sidebarIcon(Icons.people_alt_rounded),
                  _sidebarIcon(Icons.favorite_rounded),
                  _sidebarIcon(Icons.settings_rounded),
                ],
              ),
            ),

            const SizedBox(width: 9),

            // Dashboard content
            Expanded(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _line(
                      width: 60,
                      color: primary.withValues(alpha: 0.35),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Chart
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: primary.withValues(alpha: 0.055),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _line(
                                  width: 55,
                                  color: primary.withValues(alpha: 0.20),
                                ),
                                const SizedBox(height: 8),
                                _line(
                                  width: 35,
                                  color: primary.withValues(alpha: 0.12),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: CustomPaint(
                              painter: _DashboardChartPainter(color: green),
                              child: const SizedBox.expand(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Stat cards
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(child: _statCard(const Color(0xFF6BA9FF))),
                        const SizedBox(width: 6),
                        Expanded(child: _statCard(green)),
                        const SizedBox(width: 6),
                        Expanded(child: _statCard(const Color(0xFFBD91F5))),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Bottom content
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primary.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(
                                3,
                                (index) => Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: [
                                          primary,
                                          green,
                                          const Color(0xFF55C6B5),
                                        ][index],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: _line(
                                        color: primary.withValues(alpha: 0.13),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        Expanded(
                          flex: 2,
                          child: Center(
                            child: SizedBox(
                              width: 43,
                              height: 43,
                              child: CircularProgressIndicator(
                                value: 0.72,
                                strokeWidth: 6,
                                backgroundColor: primary.withValues(
                                  alpha: 0.10,
                                ),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  green,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebarIcon(IconData icon, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: selected
            ? Colors.white.withValues(alpha: 0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(
        icon,
        size: 17,
        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.60),
      ),
    );
  }

  Widget _statCard(Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(child: _line(color: primary.withValues(alpha: 0.10))),
            ],
          ),
          const SizedBox(height: 7),
          _line(width: 30, color: primary.withValues(alpha: 0.08)),
        ],
      ),
    );
  }

  Widget _line({double? width, required Color color}) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

// ============================================================
// Chart Painter
// ============================================================

class _DashboardChartPainter extends CustomPainter {
  const _DashboardChartPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final points = [
      Offset(0, size.height * 0.78),
      Offset(size.width * 0.20, size.height * 0.58),
      Offset(size.width * 0.40, size.height * 0.68),
      Offset(size.width * 0.62, size.height * 0.30),
      Offset(size.width * 0.80, size.height * 0.42),
      Offset(size.width, size.height * 0.12),
    ];

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final middleX = (previous.dx + current.dx) / 2;

      path.cubicTo(
        middleX,
        previous.dy,
        middleX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DashboardChartPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
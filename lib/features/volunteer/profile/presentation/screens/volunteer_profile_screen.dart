import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../shared/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../../../shared/settings/presentations/screens/settings_screen.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';
import '../../../rewards/presentation/screens/rewards_screen.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/widgets/contact_info_card.dart';
import '../../../../../core/helper/app_number_formatter.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/style/app_colors.dart';
import '../cards/volunteer_profile_card.dart';
import '../cards/reliability_score_card.dart';
import '../cards/past_roles_card.dart';
import '../cards/badges_card.dart';
import '../cards/avatar_card.dart';
import '../cards/stats_card.dart';

class VolunteerProfileScreen extends StatelessWidget {
  const VolunteerProfileScreen({super.key});

  String formatEgyptianPhone(String? phone) {
    if (phone == null || phone.isEmpty) return '';

    if (phone.startsWith('+20')) {
      return '0${phone.substring(3)}';
    }

    if (phone.startsWith('20')) {
      return '0${phone.substring(2)}';
    }

    return phone;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is UserLoggedOut || state is ErrorState) {
          AppNavigator.remove(const SignInScreen());
        }
      },
      builder: (context, state) {
        final cubit = AppCubit.get(context);
        final user = cubit.user;

        final profile = user?.profile is VolunteerProfileModel
            ? user!.profile as VolunteerProfileModel
            : null;

        final level = profile?.level ?? cubit.volunteerLevel;

        final location = [
          profile?.city,
          profile?.state,
          profile?.country,
        ].where((e) => e != null && e.trim().isNotEmpty).join(', ');

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSize.padding(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  AvatarCard(
                    name: '${user?.name ?? ''} ${user?.lastName ?? ''}'.trim(),
                    location: location,
                    createdAt: profile?.created,
                    image: user?.avatar,
                    level: level?.name ?? 'volunteer.profile.level'.tr(),
                  ),

                  SizedBox(height: AppSize.getHeight(24)),

                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => AppNavigator.push(RewardsScreen()),
                              child: StatCard(
                                icon: AppIcons.voltage,
                                iconColor: const Color(0xFF7B5EA7),
                                value: (profile?.xp ?? 0).compact,
                                label: 'volunteer.profile.xp'.tr(),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSize.getWidth(10)),
                          Expanded(
                            child: InkWell(
                              onTap: () => AppNavigator.push(RewardsScreen()),
                              child: StatCard(
                                icon: AppIcons.fire,
                                iconColor: const Color(0xFFFF6B35),
                                value: (profile?.streak ?? 0).compact,
                                label: 'volunteer.profile.streak'.tr(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getWidth(10)),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => AppNavigator.push(RewardsScreen()),
                              child: StatCard(
                                icon: AppIcons.calendar,
                                iconColor: const Color(0xFF2ECFA0),
                                value: '0',
                                label: 'volunteer.profile.attended'.tr(),
                              ),
                            ),
                          ),
                          SizedBox(width: AppSize.getWidth(10)),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Opacity(
                                    opacity: 0.65,
                                    child: StatCard(
                                      icon: AppIcons.donations,
                                      iconColor: const Color(0xFFE05C5C),
                                      value: 'EGP 0',
                                      label: 'volunteer.profile.donations'.tr(),
                                      smallValue: true,
                                    ),
                                  ),

                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: CustomPaint(
                                        painter: _DonationComingSoonPainter(),
                                      ),
                                    ),
                                  ),

                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: Center(
                                        child: Transform.rotate(
                                          angle: -0.45,
                                          child: Container(
                                            width: 180,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            color: Colors.black,
                                            alignment: Alignment.center,
                                            child: const Text(
                                              'COMING SOON',
                                              style: TextStyle(
                                                color: Color(0xFFFFD600),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(16)),

                  BadgesCard(badges: profile?.badges ?? []),

                  SizedBox(height: AppSize.getHeight(16)),

                  ReliabilityScoreCard(
                    reliabilityScore: profile?.reliabilityScore,
                  ),

                  SizedBox(height: AppSize.getHeight(16)),

                  VolunteerProfileCard(profile: profile),

                  SizedBox(height: AppSize.getHeight(16)),

                  PastRolesCard(roles: profile?.roles ?? []),

                  SizedBox(height: AppSize.getHeight(16)),

                  ContactInfoCard(
                    email: user?.email ?? '',
                    phone: formatEgyptianPhone(user?.phone),
                  ),

                  SizedBox(height: AppSize.getHeight(16)),

                  CustomButton(
                    onTap: () => AppNavigator.push(const SettingsScreen()),
                    title: 'volunteer.profile.settings'.tr(),
                    textSize: AppSize.font(14),
                    iconSize: AppSize.getSize(17),
                    icon: AppIcons.settings,
                    textColor: AppColors.primary,
                    bgColor: Colors.transparent,
                    borderColor: AppColors.primary,
                  ),

                  SizedBox(height: AppSize.getHeight(16)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DonationComingSoonPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const stripeWidth = 7.0;

    final yellowPaint = Paint()..color = const Color(0xFFFFD600);

    final blackPaint = Paint()..color = Colors.black;

    canvas.save();
    canvas.clipRect(Offset.zero & size);

    // شريط قطري في اتجاه من أعلى اليسار إلى أسفل اليمين.
    final stripePath = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(stripePath, blackPaint);

    // خطوط صفراء وسوداء مائلة.
    for (
      double x = -size.height;
      x < size.width + size.height;
      x += stripeWidth * 2
    ) {
      final path = Path()
        ..moveTo(x, 0)
        ..lineTo(x + stripeWidth, 0)
        ..lineTo(x + size.height + stripeWidth, size.height)
        ..lineTo(x + size.height, size.height)
        ..close();

      canvas.drawPath(path, yellowPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DonationComingSoonPainter oldDelegate) {
    return false;
  }
}

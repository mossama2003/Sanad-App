import 'package:flutter/material.dart';
import 'package:sanad_app/features/volunteer/home/presentation/screens/volunteer_home_body.dart';
import 'package:sanad_app/features/organization/home/presentation/screens/organization_home_body.dart';

import '../../../../../core/style/app_colors.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnimation = Tween<double>(
      begin: 0.6,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isFirstUse = CacheHelper.get(CacheKeys.firstUse) ?? true;

    if (isFirstUse) {
      AppNavigator.remove(const OnboardingScreen());

      return;
    }

    final token = CacheHelper.get(CacheKeys.accessToken);

    if (token == null) {
      AppNavigator.remove(const SignInScreen());

      return;
    }

    final user = await AppCubit.get(context).getUser();

    if (user == null) {
      AppNavigator.remove(const SignInScreen());

      return;
    }

    if (user.role == "volunteer") {
      AppNavigator.remove(const VolunteerHomeBody());
    } else if (user.role == "organization") {
      AppNavigator.remove(const OrganizationHomeBody());
    } else {
      AppNavigator.remove(const SignInScreen());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.handshake, color: AppColors.white, size: 60),
            ),
          ),
        ),
      ),
    );
  }
}

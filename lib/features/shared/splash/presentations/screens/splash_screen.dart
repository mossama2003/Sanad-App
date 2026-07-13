import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../core/style/app_colors.dart';
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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isFirstUse =
        CacheHelper.get(CacheKeys.firstUse) ?? true;

    if (isFirstUse) {
      AppNavigator.remove(const OnboardingScreen());
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

            child: Text(
              "Sanad",

              style: TextStyle(
                color: AppColors.white,
                fontSize: AppSize.font(42),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:sanad_app/core/style/app_text_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/helper/app_locals.dart';
import '../../../auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../data/models/onboarding_model.dart';
import '../cards/onboarding_card.dart';
import '../controllers/onboarding_cubit.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late OnboardingCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = OnboardingCubit()..updateOnboarding(_pages);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  List<OnboardingModel> get _pages => [
    OnboardingModel(
      image: AppImages.onboardingImage1,
      titleKey: 'shared.onboarding.make_a_difference',
      descKey: 'shared.onboarding.join_thousands_of_volunteers',
    ),
    OnboardingModel(
      image: AppImages.onboardingImage2,
      titleKey: 'shared.onboarding.give_receive',
      descKey: 'shared.onboarding.support_causes',
    ),
    OnboardingModel(
      image: AppImages.onboardingImage3,
      titleKey: 'shared.onboarding.earn_achieve',
      descKey: 'shared.onboarding.track_your_impact',
    ),
  ];

  bool get _isLastPage => _cubit.index == _cubit.onboarding.length - 1; // ✅

  void _toggleLanguage() async {
    final newLang = AppLocales.currentLang == AppLanguage.english
        ? AppLanguage.arabic
        : AppLanguage.english;
    await AppLocales.changeLang(context, newLang);
    setState(() {});
  }

  void _navigateToSignIn() => AppNavigator.remove(SignInScreen());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildPageView(),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: _toggleLanguage,
            child: Text(
              AppLocales.currentLang == AppLanguage.english
                  ? 'العربية'
                  : 'English',
              style: TextStyle(color: AppColors.green).sm,
            ),
          ),
          TextButton(
            onPressed: _navigateToSignIn,
            child: Text(
              'shared.onboarding.skip'.tr(),
              style: TextStyle(color: AppColors.grey).sm,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return Expanded(
      child: PageView.builder(
        controller: _cubit.controller,
        itemCount: _cubit.onboarding.length,
        // ✅
        physics: const BouncingScrollPhysics(),
        onPageChanged: _cubit.updateIndex,
        itemBuilder: (_, index) =>
            OnboardingCard(onboarding: _cubit.onboarding[index]), // ✅
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      // ✅
      bloc: _cubit,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
          child: Column(
            children: [
              SmoothPageIndicator(
                controller: _cubit.controller,
                count: _cubit.onboarding.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.green,
                  dotColor: AppColors.grey.withValues(alpha: 0.3),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  title: _isLastPage
                      ? 'shared.onboarding.get_started'.tr()
                      : 'shared.onboarding.next'.tr(),
                  onTap: _isLastPage ? _navigateToSignIn : _cubit.nextTap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}


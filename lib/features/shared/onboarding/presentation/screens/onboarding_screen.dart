import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:sanad_app/core/style/app_text_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_locals.dart';
import '../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../core/style/app_theme.dart';
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

  bool get _isLastPage => _cubit.index == _cubit.onboarding.length - 1;

  Future<void> _toggleLanguage() async {
    final newLang = AppLocales.currentLang == AppLanguage.english
        ? AppLanguage.arabic
        : AppLanguage.english;

    await AppLocales.changeLang(context, newLang);

    setState(() {});
  }

  Future<void> _toggleTheme() async {
    final currentTheme = CacheHelper.get(CacheKeys.theme) ?? CacheKeys.light;

    final isDark = currentTheme == CacheKeys.dark;

    final newTheme = isDark ? CacheKeys.light : CacheKeys.dark;

    await CacheHelper.save(CacheKeys.theme, newTheme);

    AppTheme.setTheme(
      newTheme == CacheKeys.dark ? AppThemeEnum.dark : AppThemeEnum.light,
    );
  }

  Future<void> _finishOnboarding() async {
    await CacheHelper.save(CacheKeys.firstUse, false);

    AppNavigator.remove(const SignInScreen());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(isDark),
            _buildPageView(),
            _buildBottomNavigation(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(bool isDark) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    return Padding(
      padding: AppSize.padding(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                onTap: _toggleTheme,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: AppSize.padding(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isDark
                            ? Icons.light_mode_rounded
                            : Icons.dark_mode_rounded,
                        size: 18,
                        color: textColor,
                      ),
                      SizedBox(width: AppSize.getWidth(6)),
                      Text(
                        isDark
                            ? 'shared.onboarding.light'.tr()
                            : 'shared.onboarding.dark'.tr(),
                        style: TextStyle(color: textColor).xs,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: AppSize.getWidth(8)),
              TextButton(
                onPressed: _toggleLanguage,
                child: Text(
                  AppLocales.currentLang == AppLanguage.english
                      ? 'العربية'
                      : 'English',
                  style: TextStyle(color: textColor).sm,
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: _finishOnboarding,
            child: Text(
              'shared.onboarding.skip'.tr(),
              style: TextStyle(color: textColor?.withValues(alpha: .6)).sm,
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
        physics: const BouncingScrollPhysics(),
        onPageChanged: _cubit.updateIndex,
        itemBuilder: (_, index) {
          return OnboardingCard(onboarding: _cubit.onboarding[index]);
        },
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
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
                  activeDotColor: AppColors.primary,
                  dotColor: Theme.of(context).dividerColor,
                ),
              ),

              SizedBox(height: AppSize.getHeight(16)),

              SizedBox(
                width: double.infinity,

                child: CustomButton(
                  title: _isLastPage
                      ? 'shared.onboarding.get_started'.tr()
                      : 'shared.onboarding.next'.tr(),

                  onTap: _isLastPage ? _finishOnboarding : _cubit.nextTap,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

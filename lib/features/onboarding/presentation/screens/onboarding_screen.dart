import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:sanad_app/core/style/app_text_style.dart';
import 'package:sanad_app/features/auth/presentation/sign_in/screens/sign_in_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/helper/app_locals.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  bool showImage = false;
  bool showText = false;
  bool isAnimating = false;

  // زر تغيير اللغة
  void _toggleLanguage() async {
    final newLang = AppLocales.currentLang == AppLanguage.english
        ? AppLanguage.arabic
        : AppLanguage.english;

    await AppLocales.changeLang(context, newLang);
    setState(() {}); // يعيد بناء الواجهة بعد تغيير اللغة
  }

  // مفاتيح الصفحات فقط، النصوص يتم ترجمتها في build
  final List<Map<String, String>> pages = [
    {
      'image': AppImages.onboardingImage1,
      'titleKey': 'onboarding.make_a_difference',
      'descKey': 'onboarding.join_thousands_of_volunteers',
    },
    {
      'image': AppImages.onboardingImage2,
      'titleKey': 'onboarding.give_receive',
      'descKey': 'onboarding.support_causes',
    },
    {
      'image': AppImages.onboardingImage3,
      'titleKey': 'onboarding.earn_achieve',
      'descKey': 'onboarding.track_your_impact',
    },
  ];

  void _startAnimations() {
    showImage = false;
    showText = false;

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => showImage = true);
    });

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) setState(() => showText = true);
    });
  }

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSize.padding(all: 20),
          child: Column(
            children: [
              Row(
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
                    onPressed: () {
                      AppNavigator.remove(SignInScreen());
                    },
                    child: Text(
                      'onboarding.skip'.tr(),
                      style: TextStyle(color: AppColors.grey).sm,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: PageView.builder(
                  controller: _controller,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentIndex = index;
                    });
                    _startAnimations();
                  },
                  itemBuilder: (context, index) {
                    final isActive = currentIndex == index;

                    return Column(
                      children: [
                        const Spacer(),
                        AnimatedSlide(
                          offset: showImage && isActive
                              ? Offset.zero
                              : const Offset(0.3, 0),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: showImage && isActive ? 1 : 0,
                            duration: const Duration(milliseconds: 1000),
                            child: Container(
                              width: double.infinity,
                              height: AppSize.getHeight(350),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: DecorationImage(
                                  image: AssetImage(pages[index]['image']!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedSlide(
                          offset: showText && isActive
                              ? Offset.zero
                              : const Offset(0, 0.4),
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: showText && isActive ? 1 : 0,
                            duration: const Duration(milliseconds: 900),
                            child: Column(
                              children: [
                                const SizedBox(height: 25),
                                Text(
                                  pages[index]['titleKey']!.tr(),
                                  style: TextStyle(color: AppColors.black).xl,
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  pages[index]['descKey']!.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppColors.grey).sm,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Spacer(),
                      ],
                    );
                  },
                ),
              ),
              SmoothPageIndicator(
                controller: _controller,
                count: pages.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: AppColors.green,
                  dotColor: AppColors.grey.withValues(alpha: 0.3),
                ),
              ),
              SizedBox(height: AppSize.getHeight(25)),
              CustomButton(
                title: currentIndex == pages.length - 1
                    ? 'onboarding.get_started'.tr()
                    : 'onboarding.next'.tr(),
                onTap: isAnimating
                    ? null
                    : () async {
                        if (currentIndex < pages.length - 1) {
                          setState(() => isAnimating = true);

                          await _controller.nextPage(
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeInOutCubic,
                          );

                          await Future.delayed(
                            const Duration(milliseconds: 300),
                          );

                          if (mounted) {
                            setState(() => isAnimating = false);
                          }
                        } else {
                          AppNavigator.remove(SignInScreen());
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

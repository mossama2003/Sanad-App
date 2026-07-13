import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../../core/style/app_text_style.dart';
import '../../../../../../core/style/app_theme.dart';
import '../forms/sign_in_form.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showIcon = false;
  bool showTexts = false;

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    showIcon = false;
    showTexts = false;

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          showIcon = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          showTexts = true;
        });
      }
    });
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    final secondaryText = Theme.of(context).textTheme.bodySmall?.color;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),

                child: Center(
                  child: Padding(
                    padding: AppSize.padding(all: 10),

                    child: Column(
                      children: [
                        Align(
                          alignment: AlignmentDirectional.topEnd,

                          child: Padding(
                            padding: AppSize.padding(
                              horizontal: 10,
                              vertical: 8,
                            ),

                            child: InkWell(
                              onTap: _toggleTheme,

                              borderRadius: BorderRadius.circular(30),

                              child: Container(
                                padding: AppSize.padding(
                                  horizontal: 12,
                                  vertical: 8,
                                ),

                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,

                                  borderRadius: BorderRadius.circular(30),

                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),

                                child: Row(
                                  mainAxisSize: MainAxisSize.min,

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
                                      isDark ? 'Light' : 'Dark',

                                      style: TextStyle(color: textColor).xs,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        Container(
                          width: double.infinity,

                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,

                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),

                                blurRadius: 10,
                              ),
                            ],

                            borderRadius: BorderRadius.circular(16),
                          ),

                          child: Padding(
                            padding: AppSize.padding(all: 30),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Center(
                                  child: Column(
                                    children: [
                                      AnimatedSlide(
                                        offset: showIcon
                                            ? Offset.zero
                                            : const Offset(0, 0.5),

                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),

                                        curve: Curves.easeOutCubic,

                                        child: AnimatedOpacity(
                                          opacity: showIcon ? 1 : 0,

                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),

                                          child: Container(
                                            width: AppSize.getSize(50),

                                            height: AppSize.getSize(50),

                                            decoration: BoxDecoration(
                                              color: AppColors.primary,

                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),

                                            child: Center(
                                              child: Text(
                                                '🤝',

                                                style: TextStyle(
                                                  fontSize: AppSize.font(25),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      SizedBox(height: AppSize.getHeight(15)),

                                      AnimatedSlide(
                                        offset: showTexts
                                            ? Offset.zero
                                            : const Offset(0, 0.5),

                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),

                                        curve: Curves.easeOutCubic,

                                        child: AnimatedOpacity(
                                          opacity: showTexts ? 1 : 0,

                                          duration: const Duration(
                                            milliseconds: 400,
                                          ),

                                          child: Column(
                                            children: [
                                              Text(
                                                'shared.sign_in.title'.tr(),

                                                style: TextStyle(
                                                  color: AppColors.primary,

                                                  fontSize: AppSize.font(20),

                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              SizedBox(
                                                height: AppSize.getHeight(5),
                                              ),

                                              Text(
                                                'shared.sign_in.desc'.tr(),

                                                style: TextStyle(
                                                  color: secondaryText,

                                                  fontSize: AppSize.font(15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: AppSize.getHeight(25)),

                                SignInForm(),
                              ],
                            ),
                          ),
                        ),
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
}

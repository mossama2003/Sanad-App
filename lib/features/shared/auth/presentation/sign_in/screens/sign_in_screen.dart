import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_size.dart';
import 'package:sanad_app/core/style/app_colors.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
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
                                              child: Icon(
                                                Icons.handshake,
                                                color: AppColors.white,
                                                size: 40,
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

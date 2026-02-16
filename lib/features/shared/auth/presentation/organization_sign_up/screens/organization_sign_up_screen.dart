import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/style/app_colors.dart';
import '../forms/organization_sign_up_form.dart';

class OrganizationSignUpScreen extends StatefulWidget {
  const OrganizationSignUpScreen({super.key});

  @override
  State<OrganizationSignUpScreen> createState() =>
      _OrganizationSignUpScreenState();
}

class _OrganizationSignUpScreenState extends State<OrganizationSignUpScreen> {
  bool showIcon = false;
  bool showTexts = false;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    showIcon = false;
    showTexts = false;

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => showIcon = true);
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => showTexts = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSize.padding(all: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      AnimatedSlide(
                        offset: showIcon ? Offset.zero : const Offset(0, 0.5),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          opacity: showIcon ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: Container(
                            width: AppSize.getSize(50),
                            height: AppSize.getSize(50),
                            decoration: BoxDecoration(
                              color: AppColors.laserBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '🏢',
                                style: TextStyle(fontSize: AppSize.font(25)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSize.getHeight(15)),
                      AnimatedSlide(
                        offset: showTexts ? Offset.zero : const Offset(0, 0.5),
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        child: AnimatedOpacity(
                          opacity: showTexts ? 1 : 0,
                          duration: const Duration(milliseconds: 400),
                          child: Column(
                            children: [
                              Text(
                                'sign_up_organization.title'.tr(),
                                style: TextStyle(
                                  color: AppColors.laserBlue,
                                  fontSize: AppSize.font(20),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppSize.getHeight(5)),
                              Text(
                                'sign_up_organization.desc'.tr(),
                                style: TextStyle(
                                  color: AppColors.black.withValues(alpha: 0.5),
                                  fontSize: AppSize.font(15),
                                  fontWeight: FontWeight.w400,
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
                OrganizationSignUpForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

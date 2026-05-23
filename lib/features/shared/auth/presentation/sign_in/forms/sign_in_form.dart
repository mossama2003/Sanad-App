import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../../core/shared/widgets/custom_svg.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/style/app_text_style.dart';
import '../../../../../../core/validator/app_validators.dart';
import '../../../../../organization/home/presentation/screens/organization_home_body.dart';
import '../../../../../volunteer/home/presentation/screens/volunteer_home_body.dart';
import '../../organization_sign_up/screens/organization_sign_up_screen.dart';
import '../../volunteer_sign_up/screens/volunteer_sign_up_screen.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  bool showTexts = false;
  bool showButtons = false;
  bool showField = false;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    showTexts = false;
    showButtons = false;
    showField = false;

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => showTexts = true);
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => showButtons = true);
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => showField = true);
    });
  }

  void _onSignIn() {
    if (selectedIndex < 0 || selectedIndex > 1) return;

    final screens = [
      const VolunteerHomeBody(),
      const OrganizationHomeBody(),
    ];

    AppNavigator.push(screens[selectedIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSlide(
          offset: showButtons ? Offset.zero : const Offset(0, 0.5),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: showButtons ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.sign_in.i_am'.tr(),
                  style: TextStyle(color: AppColors.grey700).xs,
                ),
                SizedBox(height: AppSize.getHeight(8)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Volunteer
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 0;
                        });
                      },
                      child: Container(
                        width: AppSize.getSize(150),
                        height: AppSize.getSize(50),
                        decoration: BoxDecoration(
                          color: selectedIndex == 0
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedIndex == 0
                                ? AppColors.green
                                : AppColors.grey,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'shared.sign_in.volunteer'.tr(),
                            style: TextStyle(
                              color: selectedIndex == 0
                                  ? AppColors.green
                                  : AppColors.black,
                              fontSize: AppSize.font(15),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Organization
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIndex = 1;
                        });
                      },
                      child: Container(
                        width: AppSize.getSize(150),
                        height: AppSize.getSize(50),
                        decoration: BoxDecoration(
                          color: selectedIndex == 1
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : AppColors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: selectedIndex == 1
                                ? AppColors.green
                                : AppColors.grey,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'shared.sign_in.organization'.tr(),
                            style: TextStyle(
                              color: selectedIndex == 1
                                  ? AppColors.green
                                  : AppColors.black,
                              fontSize: AppSize.font(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: AppSize.getHeight(25)),
        AnimatedSlide(
          offset: showField ? Offset.zero : const Offset(0, 0.5),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: showField ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomFieldText(
                  controller: TextEditingController(),
                  validator: AppValidators.email,
                  hintText: 'shared.sign_in.enter_email_or_phone'.tr(),
                  title: 'shared.sign_in.email_or_phone'.tr(),
                  iconStart: AppIcons.email,
                ),
                SizedBox(height: AppSize.getHeight(15)),
                CustomFieldText(
                  controller: TextEditingController(),
                  validator: AppValidators.password,
                  hintText: 'shared.sign_in.enter_password'.tr(),
                  title: 'shared.sign_in.password'.tr(),
                  iconStart: AppIcons.lock,
                  iconEnd: AppIcons.eyeShow,
                ),
                SizedBox(height: AppSize.getHeight(15)),
                Text(
                  'shared.sign_in.forget_password'.tr(),
                  style: TextStyle(color: AppColors.green).xs,
                ),
                SizedBox(height: AppSize.getHeight(25)),
                _socialIcon(
                  svg: AppSvg.google,
                  onTap: () {},
                  text: 'shared.sign_in.sign_with_google',
                ),
                SizedBox(height: AppSize.getHeight(10)),
                _socialIcon(
                  svg: AppSvg.apple,
                  text: 'shared.sign_in.sign_with_apple',
                  onTap: () {},
                ),
                SizedBox(height: AppSize.getHeight(25)),
                CustomButton(
                  // onTap: () => AppNavigator.push(VolunteerHomeBody()),
                  onTap: _onSignIn,
                  title: 'shared.sign_in.sign_in_button'.tr(),
                ),
                SizedBox(height: AppSize.getHeight(8)),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "shared.sign_in.dont_have_account".tr(),
                    style: TextStyle(color: AppColors.black).xs,
                    children: [
                      TextSpan(
                        text: "shared.sign_in.sign_up_as_volunteer".tr(),
                        style: TextStyle(color: AppColors.green).xs,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              AppNavigator.push(VolunteerSignUpScreen()),
                      ),
                      TextSpan(
                        text: "shared.sign_in.or".tr(),
                        style: TextStyle(color: AppColors.black).xs,
                      ),
                      TextSpan(
                        text: "shared.sign_in.sign_up_as_organization".tr(),
                        style: TextStyle(color: AppColors.green).xs,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () =>
                              AppNavigator.push(OrganizationSignUpScreen()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget _socialIcon({String? svg, VoidCallback? onTap, String? text}) => InkWell(
  borderRadius: BorderRadius.circular(12),
  onTap: onTap!,
  child: Container(
    width: double.infinity,
    height: AppSize.getHeight(45),
    decoration: BoxDecoration(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.grey.withValues(alpha: 0.5)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomSvg(
          svg: svg!,
          width: AppSize.getSize(20),
          height: AppSize.getSize(20),
        ),
        SizedBox(width: AppSize.getWidth(10)),
        Text(text!.tr(), style: TextStyle(color: AppColors.black).sm),
      ],
    ),
  ),
);

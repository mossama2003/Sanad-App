import 'package:sanad_app/features/shared/auth/presentation/sign_in/controllers/sign_in_cubit.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../organization_sign_up/screens/organization_sign_up_screen.dart';
import '../../volunteer_sign_up/screens/volunteer_sign_up_screen.dart';
import '../../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../../core/shared/widgets/custom_svg.dart';
import '../../../../../../core/validator/app_validators.dart';
import '../../../../../../core/style/app_text_style.dart';
import '../../../../../../core/constant/app_assets.dart';
import '../../../../../../core/constant/app_size.dart';
import '../../../data/repos/sign_in/sign_in_repo.dart';
import '../../../../../../core/style/app_colors.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({super.key});

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  late SignInCubit _cubit;

  bool showButtons = false;
  bool showField = false;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _cubit = SignInCubit(SignInRepoImpel());

    _startAnimations();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  void _startAnimations() {
    showButtons = false;
    showField = false;

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          showButtons = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          showField = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor =
        theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;

    // final secondaryText =
    //     theme.textTheme.bodySmall?.color ?? AppColors.textSecondary;
    //
    // final fieldColor = theme.cardColor;

    return BlocBuilder<SignInCubit, SignInState>(
      bloc: _cubit,

      builder: (context, state) {
        return Form(
          key: _cubit.formKey,

          child: Column(
            children: [
              // AnimatedSlide(
              //   offset: showButtons ? Offset.zero : const Offset(0, .5),
              //
              //   duration: const Duration(milliseconds: 400),
              //
              //   child: AnimatedOpacity(
              //     opacity: showButtons ? 1 : 0,
              //
              //     duration: const Duration(milliseconds: 400),
              //
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //
              //       children: [
              //         Text(
              //           'shared.sign_in.i_am'.tr(),
              //
              //           style: TextStyle(color: secondaryText).xs,
              //         ),
              //
              //         SizedBox(height: AppSize.getHeight(8)),
              //
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //
              //           children: [
              //             _buildTypeButton(
              //               title: 'shared.sign_in.volunteer'.tr(),
              //
              //               index: 0,
              //             ),
              //
              //             _buildTypeButton(
              //               title: 'shared.sign_in.organization'.tr(),
              //
              //               index: 1,
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              //
              // SizedBox(height: AppSize.getHeight(25)),
              AnimatedSlide(
                offset: showField ? Offset.zero : const Offset(0, .5),

                duration: const Duration(milliseconds: 400),

                child: AnimatedOpacity(
                  opacity: showField ? 1 : 0,

                  duration: const Duration(milliseconds: 400),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      CustomFieldText(
                        controller: _cubit.emailController,
                        titleSize: AppSize.font(15),
                        titleColor:
                            theme.textTheme.bodyMedium?.color ??
                            AppColors.textPrimary,
                        validator: AppValidators.required,
                        hintText: 'shared.sign_in.enter_email_or_username'.tr(),
                        title: 'shared.sign_in.email_or_username'.tr(),
                        iconStart: AppIcons.email,
                      ),

                      SizedBox(height: AppSize.getHeight(15)),

                      CustomFieldText(
                        controller: _cubit.passwordController,
                        titleSize: AppSize.font(15),
                        titleColor:
                            theme.textTheme.bodyMedium?.color ??
                            AppColors.textPrimary,
                        hintText: 'shared.sign_in.enter_password'.tr(),
                        title: 'shared.sign_in.password'.tr(),
                        iconStart: AppIcons.lock,
                        validator: (value) => AppValidators.passwordIdentical(
                          value,
                          _cubit.passwordController.text,
                        ),
                        obscureText: _cubit.obscurePassword,
                        iconEnd: _cubit.obscurePassword
                            ? AppIcons.eyeShow
                            : AppIcons.eyeOff,
                        iconEndTap: () {
                          _cubit.updateObscurePassword();
                        },
                      ),

                      SizedBox(height: AppSize.getHeight(15)),
                      Text(
                        'shared.sign_in.forget_password'.tr(),
                        style: TextStyle(color: AppColors.primary).xs,
                      ),
                      SizedBox(height: AppSize.getHeight(25)),
                      _socialIcon(
                        svg: AppSvg.google,
                        text: 'shared.sign_in.sign_with_google',
                        onTap: () {},
                      ),

                      // SizedBox(height: AppSize.getHeight(10)),
                      //
                      // _socialIcon(
                      //   svg: AppSvg.apple,
                      //
                      //   text: 'shared.sign_in.sign_with_apple',
                      //
                      //   onTap: () {},
                      // ),
                      SizedBox(height: AppSize.getHeight(25)),
                      CustomButton(
                        loading: state is Loading,
                        onTap: () => _cubit.signIn(),
                        title: 'shared.sign_in.sign_in_button'.tr(),
                      ),
                      SizedBox(height: AppSize.getHeight(8)),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: "shared.sign_in.dont_have_account".tr(),
                          style: TextStyle(color: textColor).xs,
                          children: [
                            TextSpan(
                              text: "shared.sign_in.sign_up_as_volunteer".tr(),
                              style: TextStyle(color: AppColors.primary).xs,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  AppNavigator.push(VolunteerSignUpScreen());
                                },
                            ),

                            TextSpan(
                              text: "shared.sign_in.or".tr(),
                              style: TextStyle(color: textColor).xs,
                            ),

                            TextSpan(
                              text: "shared.sign_in.sign_up_as_organization"
                                  .tr(),
                              style: TextStyle(color: AppColors.primary).xs,
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  AppNavigator.push(OrganizationSignUpScreen());
                                },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget _buildTypeButton({required String title, required int index}) {
  //   final selected = selectedIndex == index;
  //
  //   final theme = Theme.of(context);
  //
  //   return GestureDetector(
  //     onTap: () {
  //       setState(() {
  //         selectedIndex = index;
  //       });
  //     },
  //
  //     child: Container(
  //       width: AppSize.getSize(150),
  //
  //       height: AppSize.getSize(50),
  //
  //       decoration: BoxDecoration(
  //         color: selected
  //             ? AppColors.primary.withValues(alpha: .12)
  //             : theme.cardColor,
  //
  //         borderRadius: BorderRadius.circular(10),
  //
  //         border: Border.all(
  //           color: selected ? AppColors.primary : theme.dividerColor,
  //         ),
  //       ),
  //
  //       child: Center(
  //         child: Text(
  //           title,
  //
  //           style: TextStyle(
  //             color: selected
  //                 ? AppColors.primary
  //                 : theme.textTheme.bodyMedium?.color,
  //           ).sm,
  //         ),
  //       ),
  //     ),
  //   );
  // }
}

Widget _socialIcon({String? svg, VoidCallback? onTap, String? text}) {
  final theme = Theme.of(AppNavigator.key.currentContext!);

  return InkWell(
    borderRadius: BorderRadius.circular(12),

    onTap: onTap,

    child: Container(
      width: double.infinity,

      height: AppSize.getHeight(45),

      decoration: BoxDecoration(
        color: theme.cardColor,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(color: theme.dividerColor),
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

          Text(
            text!.tr(),

            style: TextStyle(color: theme.textTheme.bodyMedium?.color).sm,
          ),
        ],
      ),
    ),
  );
}

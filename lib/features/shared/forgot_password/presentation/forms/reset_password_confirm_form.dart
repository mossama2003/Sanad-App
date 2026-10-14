import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/style/app_colors.dart';
import 'package:sanad_app/features/shared/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../controllers/forgot_password_cubit.dart';

class ResetPasswordConfirmForm extends StatelessWidget {
  final String email;

  const ResetPasswordConfirmForm({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordError) {
          AppToast.error(state.error);
        } else if (state is ForgotPasswordConfirmSuccess) {
          AppToast.success(state.message);
          AppNavigator.remove(const SignInScreen());
        } else if (state is ForgotPasswordRequestSuccess) {
          // If OTP was resent
          AppToast.success(state.message);
        }
      },
      builder: (context, state) {
        final cubit = ForgotPasswordCubit.get(context);
        final isLoading = state is ForgotPasswordConfirmLoading ||
            state is ForgotPasswordRequestLoading;

        return Form(
          key: cubit.confirmFormKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: AppSize.padding(horizontal: 16, vertical: 24),
            child: _buildCard(context, cubit, isLoading),
          ),
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    ForgotPasswordCubit cubit,
    bool isLoading,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor =
        theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;
    final secondaryText =
        theme.textTheme.bodySmall?.color ?? AppColors.textSecondary;

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: .15),
          width: .7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .3 : .05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Instruction
          Text(
            'shared.forgot_password.confirm_title'.tr(),
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppSize.font(20),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppSize.getHeight(6)),
          Text(
            'shared.forgot_password.confirm_desc'.tr(),
            style: TextStyle(
              color: secondaryText,
              fontSize: AppSize.font(14),
              height: 1.4,
            ),
          ),
          SizedBox(height: AppSize.getHeight(24)),

          // OTP Field
          CustomFieldText(
            title: 'shared.forgot_password.otp'.tr(),
            titleSize: AppSize.font(15),
            titleColor: titleColor,
            hintText: 'shared.forgot_password.otp_hint'.tr(),
            controller: cubit.otpController,
            inputFormatters: [LengthLimitingTextInputFormatter(8)],
            iconStart: AppIcons.lock,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'shared.forgot_password.otp_required'.tr();
              }
              if (value.trim().length != 8) {
                return 'shared.forgot_password.otp_length_error'.tr();
              }
              return null;
            },
            onChanged: (_) => cubit.onFieldsChanged(),
          ),

          SizedBox(height: AppSize.getHeight(20)),

          // New Password
          CustomFieldText(
            title: 'shared.forgot_password.new_password'.tr(),
            titleSize: AppSize.font(15),
            titleColor: titleColor,
            hintText: 'shared.forgot_password.new_password_hint'.tr(),
            controller: cubit.newPasswordController,
            obscureText: cubit.obscureNewPassword,
            iconStart: AppIcons.password,
            iconEnd: cubit.obscureNewPassword
                ? AppIcons.eyeShow
                : AppIcons.eyeOff,
            iconEndTap: cubit.toggleNewPasswordVisibility,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'validators.password.required'.tr();
              }
              if (value.length < 8) {
                return 'validators.password.min_length'.tr();
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'validators.password.contain_upper_case'.tr();
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'validators.password.contain_number'.tr();
              }
              return null;
            },
            onChanged: (_) => cubit.onFieldsChanged(),
          ),

          SizedBox(height: AppSize.getHeight(20)),

          // Confirm New Password
          CustomFieldText(
            title: 'shared.forgot_password.confirm_new_password'.tr(),
            titleSize: AppSize.font(15),
            titleColor: titleColor,
            hintText: 'shared.forgot_password.confirm_new_password_hint'.tr(),
            controller: cubit.confirmPasswordController,
            obscureText: cubit.obscureConfirmPassword,
            iconStart: AppIcons.password,
            iconEnd: cubit.obscureConfirmPassword
                ? AppIcons.eyeShow
                : AppIcons.eyeOff,
            iconEndTap: cubit.toggleConfirmPasswordVisibility,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'validators.password.required'.tr();
              }
              if (value != cubit.newPasswordController.text) {
                return 'validators.password.identical'.tr();
              }
              return null;
            },
            onChanged: (_) => cubit.onFieldsChanged(),
          ),

          SizedBox(height: AppSize.getHeight(24)),

          // Visual Rules Checklist
          _buildRuleItem(
            context,
            title: 'shared.change_password.rule_min_length'.tr(),
            isValid: cubit.hasMinLength,
          ),
          SizedBox(height: AppSize.getHeight(8)),
          _buildRuleItem(
            context,
            title: 'shared.change_password.rule_uppercase'.tr(),
            isValid: cubit.hasUppercase,
          ),
          SizedBox(height: AppSize.getHeight(8)),
          _buildRuleItem(
            context,
            title: 'shared.change_password.rule_number'.tr(),
            isValid: cubit.hasNumber,
          ),
          SizedBox(height: AppSize.getHeight(8)),
          _buildRuleItem(
            context,
            title: 'shared.change_password.rule_match'.tr(),
            isValid: cubit.passwordsMatch,
          ),

          SizedBox(height: AppSize.getHeight(16)),

          // Resend Code Option
          if (email.isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: (isLoading || !cubit.canResend)
                      ? null
                      : () => cubit.resendOtp(email),
                  child: Text(
                    cubit.canResend
                        ? 'shared.forgot_password.resend_code'.tr()
                        : 'shared.forgot_password.resend_in'.tr(
                            namedArgs: {'seconds': '${cubit.resendSecondsLeft}'},
                          ),
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AppSize.font(13),
                    ),
                  ),
                ),
              ],
            ),

          SizedBox(height: AppSize.getHeight(20)),

          // Buttons: Cancel / Submit
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  title: 'shared.change_password.cancel'.tr(),
                  height: AppSize.getHeight(44),
                  enable: !isLoading,
                  bgColor: Colors.transparent,
                  textColor: AppColors.primary,
                  borderColor: AppColors.primary,
                  onTap: () => AppNavigator.pop(),
                ),
              ),
              SizedBox(width: AppSize.getWidth(12)),
              Expanded(
                child: CustomButton(
                  title: 'shared.forgot_password.reset_password'.tr(),
                  height: AppSize.getHeight(44),
                  loading: isLoading,
                  enable: cubit.isConfirmFormValid && !isLoading,
                  onTap: cubit.submitConfirmReset,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(
    BuildContext context, {
    required String title,
    required bool isValid,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final Color iconColor = isValid
        ? AppColors.primary
        : (isDark ? Colors.white38 : AppColors.grey);

    final Color textColor = isValid
        ? (theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary)
        : (isDark ? Colors.white38 : AppColors.grey);

    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          size: AppSize.getSize(18),
          color: iconColor,
        ),
        SizedBox(width: AppSize.getWidth(8)),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSize.font(13),
              fontWeight: isValid ? FontWeight.w500 : FontWeight.normal,
              color: textColor,
            ),
          ),
        ),
      ],
    );
  }
}

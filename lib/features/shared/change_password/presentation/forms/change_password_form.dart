import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/validator/app_validators.dart';
import '../controllers/change_password_cubit.dart';

class ChangePasswordForm extends StatelessWidget {
  const ChangePasswordForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) {
        if (state is ChangePasswordSuccess) {
          AppNavigator.pop();
        }
      },
      builder: (context, state) {
        final cubit = ChangePasswordCubit.get(context);
        final isLoading = state is ChangePasswordLoading;

        return Form(
          key: cubit.formKey,
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
    ChangePasswordCubit cubit,
    bool isLoading,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final titleColor =
        theme.textTheme.bodyMedium?.color ?? AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
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
          // Security Notice Banner
          _buildSecurityNotice(context),

          SizedBox(height: AppSize.getHeight(24)),

          // Current Password
          CustomFieldText(
            title: 'shared.change_password.current_password'.tr(),
            titleSize: AppSize.font(15),
            titleColor: titleColor,
            hintText: 'shared.change_password.current_password_hint'.tr(),
            controller: cubit.currentPasswordController,
            obscureText: cubit.obscureCurrentPassword,
            iconStart: AppIcons.lock,
            iconEnd: cubit.obscureCurrentPassword
                ? AppIcons.eyeShow
                : AppIcons.eyeOff,
            iconEndTap: cubit.toggleCurrentPasswordVisibility,
            enabled: !isLoading,
            validator: AppValidators.required,
            onChanged: (_) => cubit.onPasswordFieldsChanged(),
          ),

          SizedBox(height: AppSize.getHeight(20)),

          // New Password
          CustomFieldText(
            title: 'shared.change_password.new_password'.tr(),
            titleSize: AppSize.font(15),
            titleColor: titleColor,
            hintText: 'shared.change_password.new_password_hint'.tr(),
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
              if (value == cubit.currentPasswordController.text) {
                return 'validators.password.old_new_same'.tr();
              }
              return null;
            },
            onChanged: (_) => cubit.onPasswordFieldsChanged(),
          ),

          SizedBox(height: AppSize.getHeight(20)),

          // Confirm New Password
          CustomFieldText(
            title: 'shared.change_password.confirm_password'.tr(),
            titleSize: AppSize.font(15),
            titleColor: titleColor,
            hintText: 'shared.change_password.confirm_password_hint'.tr(),
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
            onChanged: (_) => cubit.onPasswordFieldsChanged(),
          ),

          SizedBox(height: AppSize.getHeight(24)),

          // Plain Rules Checklist (no separate bordered container)
          _buildRuleItem(
            context,
            title: 'shared.change_password.rule_min_length'.tr(),
            isValid: cubit.hasMinLength,
          ),
          SizedBox(height: AppSize.getHeight(10)),
          _buildRuleItem(
            context,
            title: 'shared.change_password.rule_uppercase'.tr(),
            isValid: cubit.hasUppercase,
          ),
          SizedBox(height: AppSize.getHeight(10)),
          _buildRuleItem(
            context,
            title: 'shared.change_password.rule_number'.tr(),
            isValid: cubit.hasNumber,
          ),
          SizedBox(height: AppSize.getHeight(10)),
          _buildRuleItem(
            context,
            title: 'shared.change_password.rule_match'.tr(),
            isValid: cubit.passwordsMatch,
          ),

          SizedBox(height: AppSize.getHeight(32)),

          // Buttons: Cancel (left) | Continue (right) in a Row
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
                  title: 'shared.change_password.continue_btn'.tr(),
                  height: AppSize.getHeight(44),
                  loading: isLoading,
                  enable: cubit.isFormValid && !isLoading,
                  bgColor: AppColors.primary,
                  textColor: Colors.white,
                  onTap: cubit.submitChangePassword,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityNotice(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: AppSize.padding(all: 8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: CustomIcon(
              icon: AppIcons.privacyPolicy,
              color: AppColors.primary,
              width: AppSize.getSize(22),
              height: AppSize.getSize(22),
            ),
          ),
          SizedBox(width: AppSize.getWidth(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.change_password.notice_title'.tr(),
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colors.onSurface,
                  ),
                ),
                SizedBox(height: AppSize.getHeight(4)),
                Text(
                  'shared.change_password.notice_desc'.tr(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurface.withValues(alpha: 0.65),
                    height: 1.4,
                  ),
                ),
              ],
            ),
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
    final colors = theme.colorScheme;

    return Row(
      children: [
        CustomIcon(
          icon: AppIcons.check,
          color: isValid
              ? AppColors.primary
              : colors.onSurface.withValues(alpha: 0.35),
          width: AppSize.getSize(20),
          height: AppSize.getSize(20),
        ),
        SizedBox(width: AppSize.getWidth(10)),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: AppSize.font(13),
              fontWeight: isValid ? FontWeight.w600 : FontWeight.w400,
              color: isValid
                  ? colors.onSurface
                  : colors.onSurface.withValues(alpha: 0.55),
            ),
          ),
        ),
      ],
    );
  }
}

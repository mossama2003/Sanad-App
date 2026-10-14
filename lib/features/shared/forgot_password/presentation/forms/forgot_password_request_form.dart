import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/style/app_text_style.dart';
import '../../../../../core/validator/app_validators.dart';
import '../controllers/forgot_password_cubit.dart';
import '../screens/reset_password_confirm_screen.dart';

class ForgotPasswordRequestForm extends StatelessWidget {
  const ForgotPasswordRequestForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state is ForgotPasswordError) {
          AppToast.error(state.error);
        } else if (state is ForgotPasswordRequestSuccess) {
          AppToast.success(state.message);
          AppNavigator.push(
            ResetPasswordConfirmScreen(email: state.email),
          );
        }
      },
      builder: (context, state) {
        final cubit = ForgotPasswordCubit.get(context);
        final isLoading = state is ForgotPasswordRequestLoading;

        return Form(
          key: cubit.requestFormKey,
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
          Center(
            child: Container(
              width: AppSize.getSize(60),
              height: AppSize.getSize(60),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIcon(
                  icon: AppIcons.lock,
                  color: AppColors.primary,
                  width: AppSize.getSize(30),
                  height: AppSize.getSize(30),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSize.getHeight(16)),
          Center(
            child: Text(
              'shared.forgot_password.request_title'.tr(),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppSize.font(20),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: AppSize.getHeight(8)),
          Center(
            child: Text(
              'shared.forgot_password.request_desc'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryText,
                fontSize: AppSize.font(14),
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: AppSize.getHeight(28)),

          // Email Field
          CustomFieldText(
            title: 'shared.forgot_password.email'.tr(),
            titleSize: AppSize.font(15),
            titleColor: titleColor,
            hintText: 'shared.forgot_password.email_hint'.tr(),
            controller: cubit.emailController,
            keyboardType: TextInputType.emailAddress,
            iconStart: AppIcons.email,
            enabled: !isLoading,
            validator: AppValidators.email,
            onChanged: (_) => cubit.onFieldsChanged(),
          ),

          SizedBox(height: AppSize.getHeight(28)),

          // Submit Button
          CustomButton(
            title: 'shared.forgot_password.send_code'.tr(),
            loading: isLoading,
            onTap: cubit.submitRequestReset,
          ),

          SizedBox(height: AppSize.getHeight(16)),

          // Cancel / Back to Login
          Center(
            child: TextButton(
              onPressed: isLoading ? null : () => AppNavigator.pop(),
              child: Text(
                'shared.forgot_password.back_to_sign_in'.tr(),
                style: TextStyle(color: AppColors.primary).sm,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

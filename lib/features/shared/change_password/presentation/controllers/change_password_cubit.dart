import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../data/params/change_password_param.dart';
import '../../data/repos/change_password_repo.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit(this.repo) : super(ChangePasswordInitial());

  final ChangePasswordRepo repo;

  static ChangePasswordCubit get(BuildContext context) =>
      BlocProvider.of<ChangePasswordCubit>(context);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureCurrentPassword = true;
  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  void toggleCurrentPasswordVisibility() {
    obscureCurrentPassword = !obscureCurrentPassword;
    if (!isClosed) emit(ChangePasswordFormValidationChanged());
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword = !obscureNewPassword;
    if (!isClosed) emit(ChangePasswordFormValidationChanged());
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    if (!isClosed) emit(ChangePasswordFormValidationChanged());
  }

  bool get hasMinLength => newPasswordController.text.length >= 8;
  bool get hasUppercase => newPasswordController.text.contains(RegExp(r'[A-Z]'));
  bool get hasNumber => newPasswordController.text.contains(RegExp(r'[0-9]'));
  bool get passwordsMatch =>
      newPasswordController.text.isNotEmpty &&
      newPasswordController.text == confirmPasswordController.text;

  bool get isFormValid =>
      currentPasswordController.text.isNotEmpty &&
      hasMinLength &&
      hasUppercase &&
      hasNumber &&
      passwordsMatch;

  void onPasswordFieldsChanged() {
    if (!isClosed) emit(ChangePasswordFormValidationChanged());
  }

  Future<void> submitChangePassword() async {
    if (isClosed || state is ChangePasswordLoading) return;
    if (!(formKey.currentState?.validate() ?? false)) return;

    if (!hasMinLength || !hasUppercase || !hasNumber) {
      AppToast.error('validators.password.min_length'.tr());
      return;
    }

    if (!passwordsMatch) {
      AppToast.error('validators.password.identical'.tr());
      return;
    }

    if (currentPasswordController.text == newPasswordController.text) {
      AppToast.error('validators.password.old_new_same'.tr());
      return;
    }

    emit(ChangePasswordLoading());

    final result = await repo.changePassword(
      ChangePasswordParam(
        oldPassword: currentPasswordController.text,
        newPassword1: newPasswordController.text,
        newPassword2: confirmPasswordController.text,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(ChangePasswordError(error: failure.errMessage));
        AppToast.error(failure.errMessage);
      },
      (successDetail) {
        emit(ChangePasswordSuccess(message: successDetail));
        AppToast.success('shared.change_password.success'.tr());
      },
    );
  }

  @override
  Future<void> close() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}

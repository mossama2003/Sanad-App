import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/params/forgot_password_param.dart';
import '../../data/params/reset_password_confirm_param.dart';
import '../../data/repos/forgot_password_repo.dart';

part 'forgot_password_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit(this.repo) : super(ForgotPasswordInitial());

  final ForgotPasswordRepo repo;

  static ForgotPasswordCubit get(BuildContext context) =>
      BlocProvider.of<ForgotPasswordCubit>(context);

  // --- Step 1: Request Password Reset Form ---
  final GlobalKey<FormState> requestFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  // --- Step 2 & 3: Reset Confirm Form ---
  final GlobalKey<FormState> confirmFormKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool obscureNewPassword = true;
  bool obscureConfirmPassword = true;

  static const int resendCooldownSeconds = 60;
  Timer? _resendTimer;
  int resendSecondsLeft = 0;

  bool get canResend => resendSecondsLeft == 0;

  void startResendCooldown() {
    _resendTimer?.cancel();
    resendSecondsLeft = resendCooldownSeconds;
    if (!isClosed) emit(ForgotPasswordValidationChanged());

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }
      resendSecondsLeft--;
      if (resendSecondsLeft <= 0) {
        resendSecondsLeft = 0;
        timer.cancel();
      }
      // CRITICAL: Never overwrite a loading state with a timer tick.
      final busy = state is ForgotPasswordRequestLoading ||
          state is ForgotPasswordConfirmLoading;
      if (!busy) emit(ForgotPasswordValidationChanged());
    });
  }

  void toggleNewPasswordVisibility() {
    obscureNewPassword = !obscureNewPassword;
    if (!isClosed) emit(ForgotPasswordValidationChanged());
  }

  void toggleConfirmPasswordVisibility() {
    obscureConfirmPassword = !obscureConfirmPassword;
    if (!isClosed) emit(ForgotPasswordValidationChanged());
  }

  // --- Validation Rules (Matching ChangePassword) ---
  bool get hasMinLength => newPasswordController.text.length >= 8;

  bool get hasUppercase =>
      newPasswordController.text.contains(RegExp(r'[A-Z]'));

  bool get hasNumber => newPasswordController.text.contains(RegExp(r'[0-9]'));

  bool get passwordsMatch =>
      newPasswordController.text.isNotEmpty &&
      newPasswordController.text == confirmPasswordController.text;

  bool get isRequestFormValid =>
      emailController.text.trim().isNotEmpty &&
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailController.text.trim());

  bool get isConfirmFormValid =>
      otpController.text.trim().isNotEmpty &&
      otpController.text.trim().length == 8 &&
      hasMinLength &&
      hasUppercase &&
      hasNumber &&
      passwordsMatch;

  void onFieldsChanged() {
    if (!isClosed) emit(ForgotPasswordValidationChanged());
  }

  Future<void> submitRequestReset() async {
    if (isClosed || state is ForgotPasswordRequestLoading) return;
    if (!(requestFormKey.currentState?.validate() ?? false)) return;

    emit(ForgotPasswordRequestLoading());

    final email = emailController.text.trim();
    final result = await repo.requestPasswordReset(
      ForgotPasswordParam(email: email),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ForgotPasswordError(error: failure.errMessage)),
      (message) => emit(
        ForgotPasswordRequestSuccess(message: message, email: email),
      ),
    );
  }

  Future<void> resendOtp(String email) async {
    if (isClosed || !canResend || state is ForgotPasswordRequestLoading) return;

    emit(ForgotPasswordRequestLoading());

    final result = await repo.requestPasswordReset(
      ForgotPasswordParam(email: email),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ForgotPasswordError(error: failure.errMessage)),
      (message) {
        startResendCooldown();
        emit(ForgotPasswordRequestSuccess(message: message, email: email));
      },
    );
  }

  Future<void> submitConfirmReset() async {
    if (isClosed || state is ForgotPasswordConfirmLoading) return;
    if (!(confirmFormKey.currentState?.validate() ?? false)) return;

    if (!hasMinLength || !hasUppercase || !hasNumber || !passwordsMatch) {
      return;
    }

    emit(ForgotPasswordConfirmLoading());

    final result = await repo.confirmPasswordReset(
      ResetPasswordConfirmParam(
        otp: otpController.text.trim(),
        newPassword: newPasswordController.text,
        reNewPassword: confirmPasswordController.text,
      ),
    );

    if (isClosed) return;

    result.fold(
      (failure) => emit(ForgotPasswordError(error: failure.errMessage)),
      (message) => emit(ForgotPasswordConfirmSuccess(message: message)),
    );
  }

  @override
  Future<void> close() {
    _resendTimer?.cancel();
    emailController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    return super.close();
  }
}

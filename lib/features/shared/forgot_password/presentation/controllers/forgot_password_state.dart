part of 'forgot_password_cubit.dart';

@immutable
sealed class ForgotPasswordState {}

final class ForgotPasswordInitial extends ForgotPasswordState {}

final class ForgotPasswordRequestLoading extends ForgotPasswordState {}

final class ForgotPasswordRequestSuccess extends ForgotPasswordState {
  final String message;
  final String email;

  ForgotPasswordRequestSuccess({
    required this.message,
    required this.email,
  });
}

final class ForgotPasswordConfirmLoading extends ForgotPasswordState {}

final class ForgotPasswordConfirmSuccess extends ForgotPasswordState {
  final String message;

  ForgotPasswordConfirmSuccess({
    required this.message,
  });
}

final class ForgotPasswordError extends ForgotPasswordState {
  final String error;

  ForgotPasswordError({
    required this.error,
  });
}

final class ForgotPasswordValidationChanged extends ForgotPasswordState {}

part of 'change_password_cubit.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

final class ChangePasswordLoading extends ChangePasswordState {}

final class ChangePasswordSuccess extends ChangePasswordState {
  final String message;

  ChangePasswordSuccess({required this.message});
}

final class ChangePasswordError extends ChangePasswordState {
  final String error;

  ChangePasswordError({required this.error});
}

final class ChangePasswordFormValidationChanged extends ChangePasswordState {}

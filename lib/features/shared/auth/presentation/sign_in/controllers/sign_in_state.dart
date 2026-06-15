part of 'sign_in_cubit.dart';

@immutable
sealed class SignInState {}

final class SignInInitial extends SignInState {}

final class UpdateObscurePassword extends SignInState {}

final class Loading extends SignInState {}

final class Error extends SignInState {}

final class Success extends SignInState {}

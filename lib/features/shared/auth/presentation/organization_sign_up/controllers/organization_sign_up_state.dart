part of 'organization_sign_up_cubit.dart';

@immutable
sealed class OrganizationSignUpState {}

final class OrganizationSignUpInitial extends OrganizationSignUpState {}

final class UpdatePasswordState extends OrganizationSignUpState {}

final class UpdateObscurePassword extends OrganizationSignUpState {}

final class UpdateObscureConfirmedPassword extends OrganizationSignUpState {}

final class Loading extends OrganizationSignUpState {}

final class Error extends OrganizationSignUpState {}

final class Success extends OrganizationSignUpState {}

part of 'volunteer_sign_up_cubit.dart';

@immutable
sealed class VolunteerSignUpState {}

final class SignUpInitial extends VolunteerSignUpState {}

final class UpdateObscurePassword extends VolunteerSignUpState {}

final class UpdateObscureConfirmedPassword extends VolunteerSignUpState {}

final class UpdateInterestsState extends VolunteerSignUpState {}

final class UpdateLocationState extends VolunteerSignUpState {}

final class UpdateNationalIDState extends VolunteerSignUpState {}

final class UpdateVolunteerImageState extends VolunteerSignUpState {}

class UploadLoading extends VolunteerSignUpState {
  final double progress;

  UploadLoading({required this.progress});
}

class UploadSuccess extends VolunteerSignUpState {}

class UploadError extends VolunteerSignUpState {}

final class Loading extends VolunteerSignUpState {}

final class Success extends VolunteerSignUpState {}

final class Error extends VolunteerSignUpState {}

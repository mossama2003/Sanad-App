part of 'volunteer_qr_cubit.dart';

sealed class VolunteerQrState {}

class QrCheckInInitial extends VolunteerQrState {}

class Loading extends VolunteerQrState {}

class Success extends VolunteerQrState {}

class Error extends VolunteerQrState {}

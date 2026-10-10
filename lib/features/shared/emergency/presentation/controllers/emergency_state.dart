part of 'emergency_cubit.dart';

abstract class EmergencyState {}

class EmergencyInitial extends EmergencyState {}

class EmergencyLoading extends EmergencyState {}

class EmergencySuccess extends EmergencyState {}

class EmergencyError extends EmergencyState {}

class EmergencyCreated extends EmergencyState {
  EmergencyCreated(this.emergencyId);

  final int emergencyId;
}

class EmergencyFormChanged extends EmergencyState {}

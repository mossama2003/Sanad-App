part of 'organization_events_cubit.dart';

@immutable
sealed class OrganizationEventsState {}

final class EventsInitial extends OrganizationEventsState {}

final class EventCoverPicked extends OrganizationEventsState {}

final class EventDatePicked extends OrganizationEventsState {}

final class StartTimePicked extends OrganizationEventsState {}

final class EndTimePicked extends OrganizationEventsState {}

final class UpdateLocationState extends OrganizationEventsState {}

final class LoadingLocationData extends OrganizationEventsState {}

final class LoadingSkills extends OrganizationEventsState {}

final class LoadingEvents extends OrganizationEventsState {}

final class EventsLoaded extends OrganizationEventsState {}

final class UpdateSkillsState extends OrganizationEventsState {}

final class EventTimeError extends OrganizationEventsState {
  final String message;

  EventTimeError(this.message);
}

final class EventCoverError extends OrganizationEventsState {
  final String message;

  EventCoverError(this.message);
}

final class EventCoverRemoved extends OrganizationEventsState {}

class Loading extends OrganizationEventsState {
  final CreateOrganizationEventAction action;

  Loading(this.action);
}

final class Error extends OrganizationEventsState {}

final class Success extends OrganizationEventsState {}

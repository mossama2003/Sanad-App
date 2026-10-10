part of 'organization_events_cubit.dart';

@immutable
sealed class OrganizationEventsState {}

final class EventsInitial extends OrganizationEventsState {}

final class Loading extends OrganizationEventsState {}

final class Success extends OrganizationEventsState {}

final class Error extends OrganizationEventsState {}

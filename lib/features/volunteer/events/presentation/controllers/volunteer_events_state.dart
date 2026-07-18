part of 'volunteer_events_cubit.dart';

@immutable
sealed class VolunteerEventsState {}

final class EventsInitial extends VolunteerEventsState {}

final class Loading extends VolunteerEventsState {}

final class Success extends VolunteerEventsState {}

final class Error extends VolunteerEventsState {}

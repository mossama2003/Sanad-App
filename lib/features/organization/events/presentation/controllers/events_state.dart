part of 'events_cubit.dart';

@immutable
sealed class EventsState {}

final class EventsInitial extends EventsState {}

final class EventCoverPicked extends EventsState {}

final class EventDatePicked extends EventsState {}

final class StartTimePicked extends EventsState {}

final class EndTimePicked extends EventsState {}

final class EventTimeError extends EventsState {
  final String message;

  EventTimeError(this.message);
}

final class EventCoverError extends EventsState {
  final String message;

  EventCoverError(this.message);
}

final class EventCoverRemoved extends EventsState {}

final class Loading extends EventsState {}

final class Error extends EventsState {}

final class Success extends EventsState {}

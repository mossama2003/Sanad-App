part of 'badges_cubit.dart';

abstract class BadgesState {}

class Initial extends BadgesState {}

class Loading extends BadgesState {}

class Success extends BadgesState {
  final List<BadgeModel> badges;

  Success(this.badges);
}

class Error extends BadgesState {
  final String message;

  Error(this.message);
}

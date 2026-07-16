part of "app_cubit.dart";

abstract class AppStates {}

class AppInitialState extends AppStates {}

class SuccessState extends AppStates {}

class ErrorState extends AppStates {}

class UserLoggedOut extends AppStates {}

class UserLoaded extends AppStates {
  final UserModel user;

  UserLoaded(this.user);
}

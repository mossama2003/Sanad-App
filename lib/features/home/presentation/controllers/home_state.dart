part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class BottomNavChange extends HomeState {}

class Loading extends HomeState {}

class Success extends HomeState {}

class Error extends HomeState {}

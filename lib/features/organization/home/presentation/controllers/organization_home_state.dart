part of 'organization_home_cubit.dart';

abstract class OrganizationHomeState {}

class HomeInitial extends OrganizationHomeState {}

class BottomNavChange extends OrganizationHomeState {}

class Loading extends OrganizationHomeState {}

class Success extends OrganizationHomeState {}

class Error extends OrganizationHomeState {}

class HomeUpdated extends OrganizationHomeState {}

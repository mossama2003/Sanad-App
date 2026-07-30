part of 'volunteer_community_cubit.dart';

sealed class VolunteerCommunityState {}

final class VolunteerCommunityInitial extends VolunteerCommunityState {}

final class Loading extends VolunteerCommunityState {}

final class Error extends VolunteerCommunityState {}

final class Success extends VolunteerCommunityState {}

final class BottomNavChange extends VolunteerCommunityState {}

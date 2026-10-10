part of 'faq_cubit.dart';

abstract class FaqState {}

class FaqInitial extends FaqState {}

class FaqLoading extends FaqState {}

class FaqSuccess extends FaqState {
  final FaqPaginationModel data;

  FaqSuccess(this.data);
}

class FaqExpandedState extends FaqState {}

class FaqError extends FaqState {}
part of 'terms_cubit.dart';

abstract class TermsState {}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsError extends TermsState {
  final String message;

  TermsError(this.message);
}

class TermsLoaded extends TermsState {
  final List<TermsModel> terms;
  final int count;
  final String? next;
  final String? previous;
  final bool isLoadingMore;

  TermsLoaded({
    required this.terms,
    required this.count,
    this.next,
    this.previous,
    this.isLoadingMore = false,
  });

  TermsLoaded copyWith({
    List<TermsModel>? terms,
    int? count,
    String? next,
    String? previous,
    bool? isLoadingMore,
  }) {
    return TermsLoaded(
      terms: terms ?? this.terms,
      count: count ?? this.count,
      next: next ?? this.next,
      previous: previous ?? this.previous,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}
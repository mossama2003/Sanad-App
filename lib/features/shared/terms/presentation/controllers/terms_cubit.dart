import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/terms_model.dart';
import '../../data/repos/terms_repo.dart';

part 'terms_state.dart';

class TermsCubit extends Cubit<TermsState> {
  TermsCubit(this.repository) : super(TermsInitial());

  final TermsRepo repository;

  static TermsCubit get(context) => BlocProvider.of<TermsCubit>(context);

  final TextEditingController searchController = TextEditingController();

  Timer? _searchDebounce;

  void onSearchChanged(String value) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (isClosed) return;

      fetchTerms(search: value, termType: _termType);
    });
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    searchController.dispose();
    return super.close();
  }

  static const List<String> termTypes = [
    'general',
    'sanad',
    'account',
    'acceptance',
    'termination',
    'eligibility',
    'privacy',
    'copyright',
    'billing',
  ];

  static const int pageSize = 10;

  int _page = 1;
  int _count = 0;
  String? _next;
  String? _search;
  String? _termType;
  bool _isFetching = false;

  List<TermsModel> _terms = [];

  String? get selectedTermType => _termType;

  Future<void> fetchTerms({String? search, String? termType}) async {
    if (_isFetching || isClosed) return;

    _isFetching = true;
    _page = 1;
    _search = search?.trim();
    _termType = termType;
    _terms = [];
    _next = null;

    emit(TermsLoading());

    final result = await repository.getTerms(
      page: _page,
      size: pageSize,
      search: _search,
      termType: _termType,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(TermsError(failure.errMessage));
      },
      (response) {
        _count = response.count;
        _next = response.next;

        // Only display active terms.
        _terms = response.results.where((term) => term.active).toList();

        emit(
          TermsLoaded(
            terms: List.unmodifiable(_terms),
            count: _count,
            next: _next,
          ),
        );
      },
    );

    _isFetching = false;
  }

  Future<void> loadMore() async {
    if (_isFetching || isClosed || _next == null) return;
    if (state is! TermsLoaded) return;

    _isFetching = true;

    final currentState = state as TermsLoaded;
    emit(currentState.copyWith(isLoadingMore: true));

    final result = await repository.getTerms(
      page: _page + 1,
      size: pageSize,
      search: _search,
      termType: _termType,
    );

    if (isClosed) return;

    result.fold(
      (_) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (response) {
        _page++;
        _count = response.count;
        _next = response.next;

        final existingIds = _terms.map((term) => term.id).toSet();

        final newTerms = response.results
            .where((term) => term.active && !existingIds.contains(term.id))
            .toList();

        _terms.addAll(newTerms);

        emit(
          TermsLoaded(
            terms: List.unmodifiable(_terms),
            count: _count,
            next: _next,
          ),
        );
      },
    );

    _isFetching = false;
  }

  Future<void> searchTerms(String query) async {
    await fetchTerms(search: query, termType: _termType);
  }

  Future<void> filterByType(String? type) async {
    await fetchTerms(search: _search, termType: type);
  }

  Future<void> refresh() async {
    await fetchTerms(search: _search, termType: _termType);
  }
}

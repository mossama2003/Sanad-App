import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../data/models/faq_model.dart';
import '../../data/repos/faq_repo.dart';

part 'faq_state.dart';

class FaqCubit extends Cubit<FaqState> {
  FaqCubit(this.repo) : super(FaqInitial());

  final FaqRepo repo;

  static FaqCubit get(BuildContext context) =>
      BlocProvider.of<FaqCubit>(context);

  // ===================== FAQ =====================

  final List<FAQModel> faqs = [];

  int currentPage = 1;
  int maxPages = 1;
  int totalCount = 0;

  String? search;

  int? expandedIndex;

  // ===================== Search =====================

  final TextEditingController searchController = TextEditingController();

  Timer? debounce;

  void onSearchChanged(String value) {
    debounce?.cancel();

    debounce = Timer(const Duration(milliseconds: 500), () {
      search = value.trim().isEmpty ? null : value.trim();

      getFaqs(
        page: 1,
        search: search,
      );
    });
  }

  void clearSearch() {
    debounce?.cancel();

    searchController.clear();

    search = null;

    getFaqs(
      page: 1,
      search: null,
    );
  }

  // ===================== Expand FAQ =====================

  void toggleFaq(int index) {
    if (expandedIndex == index) {
      expandedIndex = null;
    } else {
      expandedIndex = index;
    }

    emit(FaqExpandedState());
  }

  // ===================== Get FAQs =====================

  Future<void> getFaqs({
    int page = 1,
    int size = 20,
    String? search,
  }) async {
    currentPage = page;

    this.search = search?.trim().isEmpty ?? true
        ? null
        : search!.trim();

    expandedIndex = null;

    emit(FaqLoading());

    final result = await repo.getFaqs(
      page: page,
      size: size,
      search: this.search,
    );

    result.fold(
          (failure) {
        emit(FaqError());

        AppToast.error(failure.errMessage);
      },
          (data) {
        faqs
          ..clear()
          ..addAll(data.results);

        maxPages = data.maxPages;
        totalCount = data.count;

        emit(FaqSuccess(data));
      },
    );
  }

  // ===================== Refresh =====================

  Future<void> refreshFaqs() async {
    await getFaqs(
      page: 1,
      search: search,
    );
  }

  // ===================== Next Page =====================

  Future<void> nextPage() async {
    if (currentPage >= maxPages) return;

    await getFaqs(
      page: currentPage + 1,
      search: search,
    );
  }

  @override
  Future<void> close() {
    debounce?.cancel();
    searchController.dispose();

    return super.close();
  }
}

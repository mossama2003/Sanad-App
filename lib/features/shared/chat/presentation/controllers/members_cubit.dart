import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../data/enums/member_role_enum.dart';
import '../../data/models/members_model.dart';
import '../../data/repos/chat_repo.dart';

part 'members_state.dart';

class MembersCubit extends Cubit<MembersState> {
  final ChatRepo chatRepo;
  final int eventId;

  Timer? _debounce;

  MembersCubit({required this.chatRepo, required this.eventId})
      : super(MembersInitial());

  // ── Init / first load ────────────────────────────────────────────────
  Future<void> loadMembers() async {
    emit(MembersLoading());

    final result = await chatRepo.getEventMembers(eventId: eventId, page: 1);

    result.fold(
          (failure) => emit(MembersError(failure.errMessage)),
          (data) => emit(
        MembersLoaded(members: data.results, page: 1, hasMore: data.hasMore, totalCount: data.count),
      ),
    );
  }

  // ── Pagination on scroll ────────────────────────────────────────────
  Future<void> loadMoreMembers() async {
    final current = state;
    if (current is! MembersLoaded || !current.hasMore || current.isLoadingMore) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true));

    final nextPage = current.page + 1;
    final result = await chatRepo.getEventMembers(
      eventId: eventId,
      page: nextPage,
      search: current.searchQuery.isEmpty ? null : current.searchQuery,
    );

    result.fold(
          (failure) {
        emit(current.copyWith(isLoadingMore: false));
        AppToast.error(failure.errMessage);
      },
          (data) => emit(
        current.copyWith(
          members: [...current.members, ...data.results],
          page: nextPage,
          hasMore: data.hasMore,
          isLoadingMore: false,
        ),
      ),
    );
  }

  // ── Retry ────────────────────────────────────────────────────────────
  void retry() => loadMembers();

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}

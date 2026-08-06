import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../data/enums/member_role_enum.dart';
import '../../data/models/member_model.dart';
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

  Future<void> updateMemberRole({
    required int memberId,
    required String newRole,
  }) async {
    final current = state;
    if (current is! MembersLoaded) return;

    final index = current.members.indexWhere((m) => m.id == memberId);
    if (index == -1) return;

    final backup = current.members;

    // Optimistic update
    final updatedMembers = [...current.members];
    updatedMembers[index] = updatedMembers[index].copyWith(role: newRole);
    emit(current.copyWith(members: updatedMembers));

    final result = await chatRepo.updateVolunteerRole(
      memberId: memberId,
      role: newRole,
    );

    result.fold(
          (failure) {
        // Rollback
        final latest = state;
        if (latest is MembersLoaded) {
          emit(latest.copyWith(members: backup));
        }
        AppToast.error(failure.errMessage);
      },
          (savedRole) {
        AppToast.success('shared.chat.role_updated'.tr());
      },
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

import 'dart:async';

import 'package:ably_flutter/ably_flutter.dart' as ably;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../data/params/create_case_param.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../data/models/cases_model.dart';
import '../../data/repos/cases_repo.dart';

part 'case_state.dart';

class CasesCubit extends Cubit<CasesState> {
  CasesCubit(this.repo) : super(Initial());

  final CasesRepo repo;

  static CasesCubit get(BuildContext context) => BlocProvider.of(context);

  // Cases created locally during the current session.
  static final List<CaseListItemModel> _sessionCreatedCases = [];

  final List<CaseCommentModel> comments = [];

  final Set<int> _likingCases = {};
  final Set<int> _completingCases = {};

  bool isUpdatingCase = false;

  final List<CaseListItemModel> _allCases = [];
  final List<CaseListItemModel> _myCases = [];

  bool isMySelected = false;

  List<CaseListItemModel> get casesList => isMySelected ? _myCases : _allCases;

  int currentPage = 1;
  int maxPages = 1;
  bool isLoadingMore = false;

  int myCasesCount = 0;
  int? _currentUserId;

  bool isCommentsLoading = false;
  bool isSendingComment = false;

  ably.Realtime? _ablyRealtime;
  ably.RealtimeChannel? _commentsChannel;
  StreamSubscription<ably.Message>? _commentsSubscription;
  String? _currentClientId;

  bool isLikingCase(int caseId) {
    return _likingCases.contains(caseId);
  }

  bool isCompletingCase(int caseId) {
    return _completingCases.contains(caseId);
  }

  void refreshCurrentList() {
    emit(Success());
  }

  void notifyCasesChanged() {
    emit(Success());
  }

  // ============================================================
  // Helpers
  // ============================================================

  List<CaseListItemModel> _withPendingOwnCases(
      List<CaseListItemModel> server,
      ) {
    final serverIds = server.map((c) => c.id).toSet();

    // Once the server returns a locally-created case,
    // remove it from the temporary session list.
    _sessionCreatedCases.removeWhere((c) => serverIds.contains(c.id));

    final pending = _sessionCreatedCases
        .where((c) => c.creator.id == _currentUserId)
        .toList();

    return [...pending, ...server];
  }

  // Applies any case modification to All Cases, My Cases,
  // and the temporary session list.
  void _updateCaseEverywhere(
      int id,
      CaseListItemModel Function(CaseListItemModel) update,
      ) {
    for (final list in [_allCases, _myCases, _sessionCreatedCases]) {
      final index = list.indexWhere((c) => c.id == id);

      if (index != -1) {
        list[index] = update(list[index]);
      }
    }
  }

  // ============================================================
  // Create Case
  // ============================================================

  Future<void> createCase(
      CreateCaseParam param, {
        required BuildContext context,
      }) async {
    if (isUpdatingCase) return;

    isUpdatingCase = true;

    emit(Loading());

    final result = await repo.createCase(param);

    result.fold(
          (l) {
        isUpdatingCase = false;

        emit(Error());

        AppToast.error(l.errMessage);
      },
          (r) {
        final user = AppCubit.get(context).user;

        _currentUserId ??= user?.id;

        final newCase = CaseListItemModel(
          id: r.id,

          creator: Creator(
            id: user?.id ?? 0,
            name: user?.name ?? '',
            avatar: user?.avatar,
          ),

          paymentDetails: CasePaymentDetails(
            paymentType: r.paymentDetails?.paymentType ?? r.paymentType,

            description: r.paymentDetails?.description ?? r.paymentDescription,

            estimatedAmount:
            r.paymentDetails?.estimatedAmount ?? r.paymentEstimatedAmount,

            raisedAmount:
            r.paymentDetails?.raisedAmount ?? r.paymentRaisedAmount,
          ),

          comments: 0,
          likers: 0,
          isLiked: false,

          // The create API response doesn't contain
          // attachment details, so we keep it empty locally.
          attachments: const [],

          created: r.created,
          modified: r.modified,

          name: r.name,
          description: r.description,
          category: r.category,
          urgency: r.urgency,

          contactName: r.contactName,
          contactPhone: r.contactPhone,

          info: r.info,

          verified: false,

          note: r.note,
          active: r.active,
        );

        // Check if the case already exists BEFORE modifying lists.
        final alreadyExists = _myCases.any(
              (caseItem) => caseItem.id == newCase.id,
        );

        // Remove old local copies if they exist.
        _myCases.removeWhere((caseItem) => caseItem.id == newCase.id);

        _sessionCreatedCases.removeWhere(
              (caseItem) => caseItem.id == newCase.id,
        );

        // Keep a temporary copy so it survives an API refresh
        // until the server starts returning it.
        _sessionCreatedCases.insert(0, newCase);

        // Immediately show it in My Cases.
        _myCases.insert(0, newCase);

        // Update count only if it wasn't already there.
        if (!alreadyExists) {
          myCasesCount++;
        }

        // Automatically switch to My Cases.
        // IMPORTANT: do this BEFORE emit().
        isMySelected = true;

        isUpdatingCase = false;

        debugPrint('======================================');
        debugPrint('CREATE CASE SUCCESS');
        debugPrint('Cubit: ${identityHashCode(this)}');
        debugPrint('Created ID: ${newCase.id}');
        debugPrint('isMySelected: $isMySelected');
        debugPrint('myCasesCount: $myCasesCount');
        debugPrint('My Cases: ${_myCases.map((e) => e.id).toList()}');
        debugPrint('All Cases: ${_allCases.map((e) => e.id).toList()}');
        debugPrint('======================================');

        // Notify both:
        // 1. CasesScreen -> rebuild
        // 2. CasesForm -> pop
        emit(CaseCreated(newCase.id));

        AppToast.success('shared.cases.case_created_successfully'.tr());
      },
    );
  }

  // ============================================================
  // Init Screen
  // ============================================================

  Future<void> initCasesScreen({
    required bool isOrg,
    int? currentUserId,
  }) async {
    _currentUserId = currentUserId;

    if (isOrg) {
      final myResult = await repo.getCases(me: true);

      myResult.fold((l) {}, (r) {
        final merged = _withPendingOwnCases(r.results);

        _myCases
          ..clear()
          ..addAll(merged);

        myCasesCount = r.count + (merged.length - r.results.length);

        emit(Success());
      });
    }

    await getCases(me: false);
  }

  // ============================================================
  // Switch Tab
  // ============================================================

  Future<void> switchTab(bool toMyCases) async {
    isMySelected = toMyCases;

    // Immediately show whatever is already available locally.
    emit(Success());

    await getCases(me: toMyCases);
  }

  // ============================================================
  // Get Cases
  // ============================================================

  Future<void> getCases({required bool me}) async {
    final target = me ? _myCases : _allCases;

    if (target.isEmpty) {
      emit(Loading());
    }

    final result = await repo.getCases(me: me);

    result.fold(
          (l) {
        emit(Error());

        AppToast.error(l.errMessage);
      },
          (r) {
        final merged = me ? _withPendingOwnCases(r.results) : r.results;

        target
          ..clear()
          ..addAll(merged);

        maxPages = r.maxPages;
        currentPage = 1;

        if (me) {
          myCasesCount = r.count + (merged.length - r.results.length);
        }

        emit(Success());
      },
    );
  }

  // ============================================================
  // Comments
  // ============================================================

  Future<void> getCaseComments(int caseId) async {
    isCommentsLoading = true;

    emit(Loading());

    final result = await repo.getCaseComments(caseId);

    isCommentsLoading = false;

    result.fold(
          (l) {
        emit(Error());

        AppToast.error(l.errMessage);
      },
          (r) {
        comments
          ..clear()
          ..addAll(r.results);

        emit(Success());
      },
    );
  }

  // ============================================================
  // Ably
  // ============================================================

  Future<void> connectToCommentsChannel(int caseId) async {
    final tokenResult = await repo.getChatToken(caseId);

    tokenResult.fold(
          (l) {
        AppToast.error(l.errMessage);
      },
          (token) async {
        _currentClientId = token.clientId;

        final tokenRequest = ably.TokenRequest(
          keyName: token.keyName,
          clientId: token.clientId,
          timestamp: DateTime.fromMillisecondsSinceEpoch(token.timestamp),
          nonce: token.nonce,
          mac: token.mac,
          ttl: token.ttl,
          capability: token.capability,
        );

        _ablyRealtime = ably.Realtime(
          options: ably.ClientOptions(clientId: token.clientId)
            ..authCallback = (params) async {
              return tokenRequest;
            },
        );

        _commentsChannel = _ablyRealtime!.channels.get('cases:$caseId');

        _commentsSubscription = _commentsChannel!
            .subscribe(name: 'comment.created')
            .listen(_handleIncomingComment);
      },
    );
  }

  void _handleIncomingComment(ably.Message message) {
    final data = message.data;

    if (data == null || data is! Map) {
      return;
    }

    final incoming = CaseCommentModel.fromJson(
      Map<String, dynamic>.from(data),
    );

    final isOwnMessage =
        incoming.creator?.id.toString() ==
            _currentClientId?.replaceFirst('user:', '');

    if (isOwnMessage) {
      final index = comments.indexWhere(
            (c) => c.status == CommentStatus.sending,
      );

      if (index != -1) {
        comments[index] = incoming.copyWith(status: CommentStatus.sent);

        emit(Success());

        return;
      }

      return;
    }

    comments.insert(0, incoming);

    emit(Success());
  }

  // ============================================================
  // Disconnect
  // ============================================================

  Future<void> disconnectFromCommentsChannel() async {
    await _commentsSubscription?.cancel();

    await _commentsChannel?.detach();

    _ablyRealtime?.close();

    _commentsSubscription = null;
    _commentsChannel = null;
    _ablyRealtime = null;
  }

  // ============================================================
  // Add Comment
  // ============================================================

  Future<void> addCaseComment({
    required int caseId,
    required String comment,
    required BuildContext context,
  }) async {
    final currentUser = AppCubit.get(context).user;

    final localId = DateTime.now().microsecondsSinceEpoch.toString();

    final optimisticComment = CaseCommentModel(
      id: -1,

      creator: currentUser != null
          ? Creator(
        id: currentUser.id ?? 0,
        name: currentUser.name ?? '',
        avatar: currentUser.avatar,
      )
          : null,

      created: DateTime.now(),
      modified: DateTime.now(),

      comment: comment,

      status: CommentStatus.sending,

      localId: localId,
    );

    comments.insert(0, optimisticComment);

    emit(Success());

    final result = await repo.addCaseComment(caseId: caseId, comment: comment);

    result.fold(
          (l) {
        final index = comments.indexWhere((c) => c.localId == localId);

        if (index != -1) {
          comments[index] = comments[index].copyWith(
            status: CommentStatus.failed,
          );

          emit(Success());
        }

        AppToast.error(l.errMessage);
      },
          (r) {
        final index = comments.indexWhere((c) => c.localId == localId);

        if (index != -1) {
          comments[index] = CaseCommentModel(
            id: r.id,
            creator: optimisticComment.creator,
            created: r.created,
            modified: r.modified,
            comment: r.comment,
            status: CommentStatus.sent,
          );

          emit(Success());
        }

        _updateCaseEverywhere(caseId, (c) => c.copyWithCommentsIncremented());
      },
    );
  }

  // ============================================================
  // Retry Comment
  // ============================================================

  Future<void> retryFailedComment({
    required int caseId,
    required String localId,
    required BuildContext context,
  }) async {
    final index = comments.indexWhere((c) => c.localId == localId);

    if (index == -1) return;

    final failedComment = comments[index];

    comments.removeAt(index);

    emit(Success());

    await addCaseComment(
      caseId: caseId,
      comment: failedComment.comment,
      context: context,
    );
  }

  // ============================================================
  // Delete Case
  // ============================================================

  Future<void> deleteCase(int id) async {
    final result = await repo.deleteCase(id);

    result.fold(
          (l) {
        AppToast.error(l.errMessage);
      },
          (r) {
        final wasMine = _myCases.any((c) => c.id == id);

        _allCases.removeWhere((c) => c.id == id);

        _myCases.removeWhere((c) => c.id == id);

        _sessionCreatedCases.removeWhere((c) => c.id == id);

        if (wasMine) {
          myCasesCount = (myCasesCount - 1).clamp(0, 999999);
        }

        emit(Success());

        AppToast.success('shared.cases.card.case_deleted_successfully'.tr());
      },
    );
  }

  // ============================================================
  // Complete Case
  // ============================================================

  Future<void> completeCase(int id) async {
    if (_completingCases.contains(id)) return;

    _completingCases.add(id);

    emit(Success());

    final result = await repo.updateCaseActive(id: id, active: false);

    result.fold(
          (l) {
        _completingCases.remove(id);

        emit(Success());

        AppToast.error(l.errMessage);
      },
          (_) {
        _updateCaseEverywhere(id, (c) => c.copyWith(active: false));

        _completingCases.remove(id);

        emit(Success());

        AppToast.success('shared.cases.card.case_completed'.tr());
      },
    );
  }

  // ============================================================
  // Edit Comment
  // ============================================================

  Future<void> editComment({
    required int commentId,
    required String newComment,
  }) async {
    final result = await repo.editComment(id: commentId, comment: newComment);

    result.fold(
          (l) {
        AppToast.error(l.errMessage);
      },
          (r) {
        final index = comments.indexWhere((c) => c.id == commentId);

        if (index != -1) {
          comments[index] = comments[index].copyWith(comment: r);

          emit(Success());
        }

        AppToast.success('shared.cases.comments.comment_updated'.tr());
      },
    );
  }

  // ============================================================
  // Delete Comment
  // ============================================================

  Future<void> deleteComment({
    required int commentId,
    required int caseId,
  }) async {
    final result = await repo.deleteComment(commentId);

    result.fold(
          (l) {
        AppToast.error(l.errMessage);
      },
          (r) {
        comments.removeWhere((c) => c.id == commentId);

        emit(Success());

        _updateCaseEverywhere(caseId, (c) => c.copyWithCommentsDecremented());

        AppToast.success('shared.cases.comments.comment_deleted'.tr());
      },
    );
  }

  // ============================================================
  // Like
  // ============================================================

  Future<void> likeCase(int caseId) async {
    if (_likingCases.contains(caseId)) {
      return;
    }

    _likingCases.add(caseId);

    emit(Success());

    final result = await repo.likeCase(caseId);

    result.fold(
          (l) {
        _likingCases.remove(caseId);

        emit(Success());

        AppToast.error(l.errMessage);
      },
          (r) {
        _updateCaseEverywhere(
          caseId,
              (c) => c.copyWithLike(likers: r.likers, isLiked: r.isLiked),
        );

        _likingCases.remove(caseId);

        emit(Success());
      },
    );
  }

  // ============================================================
  // Update Case
  // ============================================================

  Future<void> updateCase({
    required int id,
    required CreateCaseParam param,
  }) async {
    if (isUpdatingCase) return;

    isUpdatingCase = true;

    emit(Loading());

    final result = await repo.updateCase(id: id, param: param);

    result.fold(
          (l) {
        isUpdatingCase = false;

        AppToast.error(l.errMessage);

        emit(Error());
      },
          (data) {
        _updateCaseEverywhere(
          id,
              (oldCase) => oldCase.copyWith(
            paymentDetails: CasePaymentDetails.fromJson(
              data['payment_details'],
            ),
            created: DateTime.parse(data['created']),
            modified: DateTime.parse(data['modified']),
            name: data['name'],
            description: data['description'],
            category: data['category'],
            urgency: data['urgency'],
            contactName: data['contact_name'],
            contactPhone: data['contact_phone'],
            info: data['info'],
            note: data['note'],
            active: data['active'],
          ),
        );

        isUpdatingCase = false;

        emit(Success());

        AppToast.success('shared.cases.edit.case_updated'.tr());
      },
    );
  }

  @override
  Future<void> close() {
    disconnectFromCommentsChannel();

    return super.close();
  }
}

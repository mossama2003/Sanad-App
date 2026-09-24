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

  final List<CaseCommentModel> comments = [];

  final Set<int> _likingCases = {};

  bool isUpdatingCase = false;

  final List<CaseListItemModel> casesList = [];
  int currentPage = 1;
  int maxPages = 1;
  bool isLoadingMore = false;

  bool isMySelected = false;
  int myCasesCount = 0;

  bool isCommentsLoading = false;
  bool isSendingComment = false;

  ably.Realtime? _ablyRealtime;
  ably.RealtimeChannel? _commentsChannel;
  StreamSubscription<ably.Message>? _commentsSubscription;
  String? _currentClientId;

  bool isLikingCase(int caseId) {
    return _likingCases.contains(caseId);
  }

  // ===================== Create Case =====================
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
        final user = context.mounted ? AppCubit.get(context).user : null;

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

        casesList.removeWhere((item) => item.id == newCase.id);
        casesList.insert(0, newCase);

        myCasesCount++;
        isUpdatingCase = false;

        emit(Success());

        AppToast.success('shared.cases.case_created_successfully'.tr());
      },
    );
  }

  // ===================== Init Screen =====================
  Future<void> initCasesScreen({required bool isOrg}) async {
    if (isOrg) {
      final myResult = await repo.getCases(me: true);

      myResult.fold((l) {}, (r) => myCasesCount = r.count);
    }

    await getCases(me: false);
  }

  // ===================== Switch Tab (All / My Cases) =====================
  Future<void> switchTab(bool toMyCases) async {
    isMySelected = toMyCases;

    await getCases(me: toMyCases);
  }

  // ===================== Get Cases (List) =====================
  Future<void> getCases({required bool me}) async {
    emit(Loading());

    final result = await repo.getCases(me: me);

    result.fold(
      (l) {
        emit(Error());

        AppToast.error(l.errMessage);
      },
      (r) {
        casesList
          ..clear()
          ..addAll(r.results);

        maxPages = r.maxPages;
        currentPage = 1;

        if (me) myCasesCount = r.count;

        emit(Success());
      },
    );
  }

  // ===================== Get Comments (History) =====================

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

  // ===================== Connect To Ably & Subscribe =====================

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
          options: ably.ClientOptions(
            clientId:
                token.clientId, // 👈 بقى بارامتر في الـ constructor مش cascade
          )..authCallback = (params) async => tokenRequest,
        );

        _commentsChannel = _ablyRealtime!.channels.get('cases:$caseId');

        // 👇 subscribe بيرجع Stream — بنعمل listen ونحتفظ بالـ subscription
        _commentsSubscription = _commentsChannel!
            .subscribe(name: 'comment.created')
            .listen(_handleIncomingComment);
      },
    );
  }

  void _handleIncomingComment(ably.Message message) {
    final data = message.data;

    if (data == null || data is! Map) return;

    final incoming = CaseCommentModel.fromJson(Map<String, dynamic>.from(data));

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

  // ===================== Disconnect =====================

  Future<void> disconnectFromCommentsChannel() async {
    await _commentsSubscription?.cancel();
    await _commentsChannel?.detach();
    _ablyRealtime?.close();

    _commentsSubscription = null;
    _commentsChannel = null;
    _ablyRealtime = null;
  }

  // ===================== Add Comment (Optimistic) =====================

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

        final caseIndex = casesList.indexWhere((c) => c.id == caseId);
        if (caseIndex != -1) {
          casesList[caseIndex] = casesList[caseIndex]
              .copyWithCommentsIncremented();
        }
      },
    );
  }

  // ===================== Retry Failed Comment =====================

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

  Future<void> deleteCase(int id) async {
    final result = await repo.deleteCase(id);

    result.fold(
      (l) {
        AppToast.error(l.errMessage);
      },
      (r) {
        casesList.removeWhere((c) => c.id == id);

        if (isMySelected) myCasesCount = (myCasesCount - 1).clamp(0, 999999);

        emit(Success());

        AppToast.success('shared.cases.card.case_deleted_successfully'.tr());
      },
    );
  }

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

        final caseIndex = casesList.indexWhere((c) => c.id == caseId);
        if (caseIndex != -1) {
          casesList[caseIndex] = casesList[caseIndex]
              .copyWithCommentsDecremented();
        }

        AppToast.success('shared.cases.comments.comment_deleted'.tr());
      },
    );
  }

  Future<void> likeCase(int caseId) async {
    if (_likingCases.contains(caseId)) return;

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
        final index = casesList.indexWhere((c) => c.id == caseId);

        if (index != -1) {
          casesList[index] = casesList[index].copyWithLike(
            likers: r.likers,
            isLiked: r.isLiked,
          );
        }

        _likingCases.remove(caseId);
        emit(Success());
      },
    );
  }

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
        final index = casesList.indexWhere((caseItem) => caseItem.id == id);

        if (index != -1) {
          final oldCase = casesList[index];

          casesList[index] = oldCase.copyWith(
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
          );
        }

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

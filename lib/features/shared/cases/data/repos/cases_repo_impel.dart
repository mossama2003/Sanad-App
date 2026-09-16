part of 'cases_repo.dart';

class CasesRepoImpel implements CasesRepo {
  // ================= CREATE CASE =================
  @override
  Future<Either<Failure, CaseModel>> createCase(CreateCaseParam param) async {
    try {
      final formData = await param.toFormData();

      final response = await DioHelper.post(url: CREATE_CASE, data: formData);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(CaseModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= GET CASES =================
  @override
  Future<Either<Failure, CasesListModel>> getCases({required bool me}) async {
    try {
      final response = await DioHelper.get(url: GET_CASES(me), data: {});

      if (response.statusCode == 200) {
        return right(CasesListModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= GET CASE COMMENTS =================
  @override
  Future<Either<Failure, CaseCommentsListModel>> getCaseComments(
    int caseId,
  ) async {
    try {
      final response = await DioHelper.get(url: GET_CASE_COMMENTS(caseId));

      if (response.statusCode == 200) {
        return right(CaseCommentsListModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= GET CHAT TOKEN =================
  @override
  Future<Either<Failure, CaseChatTokenModel>> getChatToken(int caseId) async {
    try {
      final response = await DioHelper.get(url: GET_CASE_CHAT_TOKEN(caseId));

      if (response.statusCode == 200) {
        return right(CaseChatTokenModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= ADD CASE COMMENT =================
  @override
  Future<Either<Failure, CaseCommentModel>> addCaseComment({
    required int caseId,
    required String comment,
  }) async {
    try {
      final response = await DioHelper.post(
        url: ADD_CASE_COMMENT,
        data: {'case': caseId, 'comment': comment},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(CaseCommentModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= DELETE CASE =================
  @override
  Future<Either<Failure, void>> deleteCase(int id) async {
    try {
      final response = await DioHelper.delete(url: DELETE_CASE(id));

      if (response.statusCode == 204 || response.statusCode == 200) {
        return right(null);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= EDIT COMMENT =================
  @override
  Future<Either<Failure, String>> editComment({
    required int id,
    required String comment,
  }) async {
    try {
      final formData = FormData.fromMap({'comment': comment});

      final response = await DioHelper.patch(
        url: EDIT_CASE_COMMENT(id),
        data: formData,
      );

      if (response.statusCode == 200) {
        return right(response.data['comment']?.toString() ?? comment);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= DELETE COMMENT =================
  @override
  Future<Either<Failure, void>> deleteComment(int id) async {
    try {
      final response = await DioHelper.delete(url: DELETE_CASE_COMMENT(id));

      if (response.statusCode == 204) {
        return right(null);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= LIKE CASE =================
  @override
  Future<Either<Failure, CaseListItemModel>> likeCase(int id) async {
    try {
      final response = await DioHelper.post(url: LIKE_CASE(id), data: {});

      if (response.statusCode == 200) {
        return right(CaseListItemModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= UPDATE CASE =================
  @override
  Future<Either<Failure, Map<String, dynamic>>> updateCase({
    required int id,
    required CreateCaseParam param,
  }) async {
    try {
      final formData = await param.toFormData();

      final response = await DioHelper.patch(
        url: UPDATE_CASE(id),
        data: formData,
      );

      if (response.statusCode == 200) {
        return right(Map<String, dynamic>.from(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../models/cases_model.dart';
import '../params/case_model.dart';
import '../params/create_case_param.dart';

part 'cases_repo_impel.dart';

abstract class CasesRepo {
  Future<Either<Failure, CaseModel>> createCase(CreateCaseParam param);

  Future<Either<Failure, CasesListModel>> getCases({required bool me});

  Future<Either<Failure, void>> deleteCase(int id);

  Future<Either<Failure, CaseCommentsListModel>> getCaseComments(int caseId);

  Future<Either<Failure, CaseChatTokenModel>> getChatToken(int caseId);

  Future<Either<Failure, CaseCommentModel>> addCaseComment({
    required int caseId,
    required String comment,
  });
}

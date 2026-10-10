import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../models/terms_model.dart';

part 'terms_repo_impel.dart';

abstract class TermsRepo {
  Future<Either<Failure, TermsResponseModel>> getTerms({
    int page = 1,
    int size = 10,
    String? search,
    String? termType,
  });
}

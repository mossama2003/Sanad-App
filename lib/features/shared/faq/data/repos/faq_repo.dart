import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../models/faq_model.dart';

part 'faq_repo_impel.dart';

abstract class FaqRepo {
  Future<Either<Failure, FaqPaginationModel>> getFaqs({
    int page,
    int size,
    String? search,
  });
}

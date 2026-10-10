import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';

part 'contact_us_repo_impel.dart';

abstract class ContactUsRepo {
  Future<Either<Failure, void>> submitContactUs({required String comment});
}

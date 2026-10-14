import 'package:easy_localization/easy_localization.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/end_points.dart';
import '../params/change_password_param.dart';

part 'change_password_repo_impel.dart';

abstract class ChangePasswordRepo {
  Future<Either<Failure, String>> changePassword(ChangePasswordParam param);
}

import 'package:dartz/dartz.dart';

import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../shared/auth/data/models/user_model.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/end_points.dart';
import '../params/update_org_profile_param.dart';

part 'edit_org_profile_repo_impel.dart';

abstract class EditOrgProfileRepo {
  Future<Either<Failure, UserModel>> updateAccount(UpdateOrgAccountParam param);

  Future<Either<Failure, UserModel>> updateOrganizationProfile(
    UpdateOrgProfileParam param,
  );
}

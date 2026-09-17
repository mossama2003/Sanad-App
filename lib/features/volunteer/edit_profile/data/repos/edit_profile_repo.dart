import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../shared/auth/data/models/user_model.dart';
import '../params/update_account_param.dart';

part 'edit_profile_repo_impel.dart';

abstract class EditProfileRepo {
  Future<Either<Failure, UserModel>> updateAccount(UpdateAccountParam param);

  Future<Either<Failure, UserModel>> updateVolunteerProfile(
    UpdateVolunteerProfileParam param,
  );
}

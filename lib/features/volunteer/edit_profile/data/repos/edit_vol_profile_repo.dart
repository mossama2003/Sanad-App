import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../shared/auth/data/models/user_model.dart';
import '../params/update_vol_profile_param.dart';

part 'edit_vol_profile_repo_impel.dart';

abstract class EditVolProfileRepo {
  Future<Either<Failure, UserModel>> updateAccount(UpdateVolAccountParam param);

  Future<Either<Failure, UserModel>> updateVolunteerProfile(
    UpdateVolProfileParam param,
  );
}

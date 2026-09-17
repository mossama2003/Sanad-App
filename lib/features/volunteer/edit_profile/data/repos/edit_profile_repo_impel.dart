part of 'edit_profile_repo.dart';

class EditProfileRepoImpel implements EditProfileRepo {
  @override
  Future<Either<Failure, UserModel>> updateAccount(
    UpdateAccountParam param,
  ) async {
    try {
      final formData = await param.toFormData();

      final response = await DioHelper.patch(
        url: UPDATE_ACCOUNT,
        data: formData,
      );

      if (response.statusCode == 200) {
        return right(UserModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateVolunteerProfile(
    UpdateVolunteerProfileParam param,
  ) async {
    try {
      final response = await DioHelper.patch(
        url: UPDATE_VOLUNTEER_PROFILE,
        data: param.toJson(),
      );

      if (response.statusCode == 200) {
        return right(UserModel());
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

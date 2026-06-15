part of 'organization_repo.dart';

class OrganizationRepoImpel implements OrganizationRepo {
  @override
  Future<Either<Failure, bool>> signUpOrganization(
    OrganizationParam param,
  ) async {
    try {
      final formData = FormData.fromMap({
        ...param.toJson(),

        // avatar
        'creator[avatar]': await MultipartFile.fromFile(param.avatar.path),

        // attachments
        for (int i = 0; i < param.attachments.length; i++)
          'creator[attachments][$i]': await MultipartFile.fromFile(
            param.attachments[i].path,
          ),
      });

      final response = await DioHelper.post(
        url: SIGN_UP,
        data: formData,
        options: Options(
          headers: {
            'Account-Type': 'organization',
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.statusCode == 201) {
        return right(true);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

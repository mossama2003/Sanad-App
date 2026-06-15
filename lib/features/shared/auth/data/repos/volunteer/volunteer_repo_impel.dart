part of 'volunteer_repo.dart';

class VolunteerRepoImpel implements VolunteerRepo {
  @override
  Future<Either<Failure, bool>> volunteerSignUp(VolunteerParam param) async {
    try {
      final formData = FormData();

      // ================= CREATOR =================
      formData.fields.addAll([
        MapEntry('creator[name]', param.name),
        MapEntry('creator[email]', param.email),
        MapEntry('creator[phone]', param.phone),
        MapEntry('creator[password]', param.password),
      ]);

      // ================= OTHER FIELDS =================
      formData.fields.addAll([
        MapEntry('gender', param.gender),
        MapEntry('blood_group', param.bloodGroup),
        MapEntry('dob', param.dob),
        MapEntry('nid', param.nid),
        MapEntry('country', param.country),
        MapEntry('state', param.state),
        MapEntry('city', param.city),
        MapEntry('address', param.address),
      ]);

      // ================= INTERESTS =================
      for (int i = 0; i < param.interests.length; i++) {
        formData.fields.add(
          MapEntry('interests[$i]', param.interests[i].toString()),
        );
      }

      // ================= ATTACHMENTS (FIX) =================
      for (int i = 0; i < param.attachments.length; i++) {
        formData.files.add(
          MapEntry(
            'creator[attachments][$i]',
            await MultipartFile.fromFile(
              param.attachments[i].path,
              filename: param.attachments[i].path.split('/').last,
            ),
          ),
        );
      }

      final response = await DioHelper.post(
        url: SIGN_UP,
        data: formData,
        options: Options(
          headers: {'Account-Type': 'volunteer'},
          contentType: 'multipart/form-data',
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

  @override
  Future<Either<Failure, List<SkillsModel>>> getVolunteerSkills() async {
    try {
      final response = await DioHelper.get(url: GET_SKILLS);

      if (response.statusCode == 200) {
        final model = SkillsResponse.fromJson(response.data);

        return right(model.results);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

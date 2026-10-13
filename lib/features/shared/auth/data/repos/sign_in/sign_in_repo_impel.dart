part of 'sign_in_repo.dart';

class SignInRepoImpel implements SignInRepo {
  @override
  Future<Either<Failure, AuthResponseModel>> signIn(SignInParam param) async {
    try {
      final response = await DioHelper.post(url: SIGN_IN, data: param.toJson());

      if (response.statusCode == 200) {
        final model = AuthResponseModel.fromJson(response.data);

        // 🔐 Save token (optional)
        final token = model.access;
        if (token != null && token.isNotEmpty) {
          await AuthCache.saveToken(token);
        }

        return right(model);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

part of 'auth_repo.dart';

class AuthRepoImpel implements AuthRepo {
  @override
  Future<Either<Failure, bool>> signUp(param) async {
    try {
      final response = await DioHelper.post(
        endPoint: REGISTER,
        data: param.toJson(),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(ServerFailure.fromResponse(response));
      }
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> completeProfile(param) async {
    try {
      final response = await DioHelper.put(
        endPoint: USER,
        data: param.toJson(),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(ServerFailure.fromResponse(response));
      }
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyPhoneOtp(param) async {
    try {
      final response = await DioHelper.post(
        endPoint: VERIFY_PHONE_OTP,
        data: param.toJson(),
      );
      if (response.statusCode == 200) {
        final String? token = response.data['data']['token'];
        if (token != null) CacheHelper.save(CacheKeys.token, token);
        return right(true);
      } else {
        return left(ServerFailure.fromResponse(response));
      }
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> signInPhone(param) async {
    try {
      final response = await DioHelper.post(
        endPoint: LOGIN_PHONE,
        data: param.toJson(),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(ServerFailure.fromResponse(response));
      }
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> resetCheck(param) async {
    try {
      final response = await DioHelper.post(
        endPoint: FORGET_PASSWORD,
        data: param.toJson(),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(ServerFailure.fromResponse(response));
      }
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> resetOtp(param) async {
    try {
      final response = await DioHelper.post(
        endPoint: FORGET_VERIFY,
        data: param.toJson(),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(ServerFailure.fromResponse(response));
      }
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(param) async {
    try {
      final response = await DioHelper.post(
        endPoint: RESET_PASSWORD,
        data: param.toJson(),
      );
      if (response.statusCode == 200) {
        return right(true);
      } else {
        return left(ServerFailure.fromResponse(response));
      }
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getAuth() async {
    try {
      final response = await DioHelper.get(endPoint: AUTH);
      if (response.statusCode == 200) {
        return right(UserModel.fromJson(response.data['data']));
      } else {
        return left(ServerFailure.fromResponse(response));
      }
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

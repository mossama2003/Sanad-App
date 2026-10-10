part of 'volunteer_home_repo.dart';

class VolunteerHomeRepoImpel extends VolunteerHomeRepo {
  @override
  Future<Either<Failure, VolunteerHomeModel>> getVolunteerHome() async {
    try {
      final response = await DioHelper.get(url: VOLUNTEER_HOME);

      return Right(VolunteerHomeModel.fromJson(response.data));
    } catch (e) {
      return Left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= JOIN EVENT =================

  @override
  Future<Either<Failure, Unit>> joinEvent(int eventId) async {
    try {
      final response = await DioHelper.post(
        url: JOIN_EVENT,
        data: {"event": eventId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= LEAVE EVENT =================

  @override
  Future<Either<Failure, Unit>> leaveEvent(int eventId) async {
    try {
      final response = await DioHelper.post(
        url: LEAVE_EVENT,
        data: {"event": eventId},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(unit);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

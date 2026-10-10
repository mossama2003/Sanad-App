part of 'emergency_repo.dart';

class EmergencyRepoImpel implements EmergencyRepo {
  @override
  Future<Either<Failure, EmergencyModel>> createEmergency(
    CreateEmergencyParam param,
  ) async {
    try {
      final formData = await param.toFormData();

      final response = await DioHelper.post(
        url: CREATE_EMERGENCY,
        data: formData,
      );

      if (response.statusCode == 201) {
        return right(EmergencyModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, List<EmergencyModel>>> getEmergencies({
    bool me = false,
  }) async {
    try {
      final response = await DioHelper.get(url: GET_EMERGENCY(me));

      if (response.statusCode == 200) {
        final data = response.data;

        final List results;

        if (data is Map<String, dynamic>) {
          results = data['results'] as List? ?? [];
        } else if (data is List) {
          results = data;
        } else {
          results = [];
        }

        return right(
          results
              .map((e) => EmergencyModel.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
        );
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, EmergencyModel>> updateEmergency(
      int id,
      UpdateEmergencyParam param,
      ) async {
    try {
      final formData = await param.toFormData();

      final response = await DioHelper.patch(
        url: UPDATE_EMERGENCY(id),
        data: formData,
      );

      if (response.statusCode == 200) {
        return right(
          EmergencyModel.fromJson(
            Map<String, dynamic>.from(response.data),
          ),
        );
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> joinEmergency(int caseId) async {
    try {
      final response = await DioHelper.post(
        url: JOIN_EMERGENCY,
        data: FormData.fromMap({'case': caseId}),
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
  Future<Either<Failure, bool>> deleteEmergency(int id) async {
    try {
      final response = await DioHelper.delete(url: DELETE_EMERGENCY(id));

      if (response.statusCode == 204) {
        return right(true);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (error) {
      return left(ServerFailure.fromCatchError(error));
    }
  }
}

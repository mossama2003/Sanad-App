part of 'volunteer_events_repo.dart';

class VolunteerEventsRepoImpel implements VolunteerEventsRepo {
  final Box<VolunteerEventDetailsModel> _eventsBox =
      HiveBoxes.volunteerEventsBox;

  // ================= GET EVENTS =================
  @override
  Future<Either<Failure, PaginatedVolunteerEventModel>> getVolunteerEvents(
    GetVolunteerEventsParam param,
  ) async {
    try {
      final response = await DioHelper.get(
        url: GET_EVENTS,
        query: param.toQuery(),
      );

      if (response.statusCode == 200) {
        final model = PaginatedVolunteerEventModel.fromJson(response.data);

        await _saveEvents(model.results);

        return right(model);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= JOIN EVENT =================

  @override
  Future<Either<Failure, Unit>> joinEvent(int eventId) async {
    try {
      final response = await DioHelper.post(
        url: JOIN_EVENT,
        data: {
          "event": eventId,
        },
      );

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        return right(unit);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= LEAVE EVENT =================

  @override
  Future<Either<Failure, dynamic>> leaveEvent(int eventId) async {
    try {
      final response = await DioHelper.post(
        url: LEAVE_EVENT,
        data: {
          "event": eventId,
        },
      );

      if (response.statusCode == 201) {
        return right(response.data);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= HIVE =================
  Future<void> _saveEvents(List<VolunteerEventDetailsModel> events) async {
    await _eventsBox.clear();

    await _eventsBox.addAll(events);
  }
}

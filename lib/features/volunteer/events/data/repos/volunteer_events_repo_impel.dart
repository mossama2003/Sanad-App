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

  // ================= HIVE =================
  Future<void> _saveEvents(List<VolunteerEventDetailsModel> events) async {
    await _eventsBox.clear();

    await _eventsBox.addAll(events);
  }
}

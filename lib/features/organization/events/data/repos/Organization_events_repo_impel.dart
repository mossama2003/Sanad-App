part of 'Organization_events_repo.dart';

class OrganizationEventsRepoImpel implements OrganizationEventsRepo {
  final Box<OrganizationEventDetailsModel> _eventsBox =
      HiveBoxes.organizationEventsBox;

  // ================= CREATE EVENT =================
  @override
  Future<Either<Failure, CreateOrganizationEventModel>> createOrganizationEvent(
    CreateOrganizationEventParam param,
  ) async {
    try {
      final formData = FormData.fromMap({
        ...param.toJson(),

        if (param.cover != null)
          "cover": await MultipartFile.fromFile(
            param.cover!.path,
            filename: param.cover!.path.split('/').last,
          ),
      });

      final response = await DioHelper.post(
        url: CREATE_ORGANIZATION_EVENT,
        data: formData,
      );

      if (response.statusCode == 201) {
        final model = CreateOrganizationEventModel.fromJson(response.data);

        return right(model);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= GET EVENTS =================
  @override
  Future<Either<Failure, PaginatedOrganizationEventModel>>
  getOrganizationEvents(GetOrganizationEventsParam param) async {
    try {
      final response = await DioHelper.get(
        url: GET_ORGANIZATION_EVENTS,
        query: param.toQuery(),
      );

      if (response.statusCode == 200) {
        final model = PaginatedOrganizationEventModel.fromJson(response.data);

        await _saveEvents(model.results);

        return right(model);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= DELETE EVENT =================
  @override
  Future<Either<Failure, void>> deleteOrganizationEvent(int id) async {
    try {
      final response = await DioHelper.delete(
        url: DELETE_ORGANIZATION_EVENT(id),
      );

      if (response.statusCode == 204) {
        await _deleteCachedEvent(id);

        return right(null);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  // ================= HIVE =================
  Future<void> _saveEvents(List<OrganizationEventDetailsModel> events) async {
    await _eventsBox.clear();

    await _eventsBox.addAll(events);
  }

  Future<void> _deleteCachedEvent(int id) async {
    final key = _eventsBox.keys.firstWhere(
      (key) => _eventsBox.get(key)?.id == id,
      orElse: () => null,
    );

    if (key != null) {
      await _eventsBox.delete(key);
    }
  }
}

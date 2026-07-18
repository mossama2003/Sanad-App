part of 'Organization_events_repo.dart';

class OrganizationEventsRepoImpel implements OrganizationEventsRepo {
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
        return right(model);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

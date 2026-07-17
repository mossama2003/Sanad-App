part of 'events_repo.dart';

class EventsRepoImpel implements EventsRepo {
  @override
  Future<Either<Failure, CreateEventModel>> createEvent(
    CreateEventParam param,
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
        url: CREATE_EVENT,
        data: formData,
        options: Options(contentType: "multipart/form-data"),
      );
      if (response.statusCode == 201) {
        final model = CreateEventModel.fromJson(response.data);

        return right(model);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

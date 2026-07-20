part of 'organization_events_repo.dart';

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
        url: GET_EVENTS,
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

  // ================= UPDATE EVENT =================

  @override
  Future<Either<Failure, CreateOrganizationEventModel>> updateOrganizationEvent(
    OrganizationEventUpdateParam param,
  ) async {
    try {
      final formData = await param.toFormData();

      final response = await DioHelper.patch(
        url: UPDATE_ORGANIZATION_EVENT(param.id),
        data: formData,
      );

      if (response.statusCode == 200) {
        final model = CreateOrganizationEventModel.fromJson(response.data);

        await _updateCachedEvent(model);

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

  Future<void> _updateCachedEvent(CreateOrganizationEventModel updated) async {
    final key = _eventsBox.keys.firstWhere(
      (key) => _eventsBox.get(key)?.id == updated.id,
      orElse: () => null,
    );

    if (key != null) {
      final old = _eventsBox.get(key);

      if (old != null) {
        await _eventsBox.put(
          key,
          OrganizationEventDetailsModel(
            id: old.id,
            creator: old.creator,
            location: {
              "url": updated.locationUrl,
              "city": updated.locationCity,
              "state": updated.locationState,
              "description": updated.locationDescription,
            },

            joiners: old.joiners,
            attendees: old.attendees,
            spots: updated.spots,
            joined: old.joined,
            avgRating: old.avgRating,
            unreadChatMessages: old.unreadChatMessages,

            latestMessage: old.latestMessage,

            cover: updated.cover,

            name: updated.name,

            description: updated.description,

            category: updated.category,

            date: updated.date,

            due: updated.due,

            skills: updated.skills,

            status: updated.status,

            qr: updated.qr,

            created: updated.created,

            modified: updated.modified,
          ),
        );
      }
    }
  }
}

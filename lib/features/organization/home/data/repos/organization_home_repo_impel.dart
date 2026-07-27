part of 'organization_home_repo.dart';

class OrganizationHomeRepoImpel implements OrganizationHomeRepo {
  final Box<OrganizationEventDetailsModel> _eventsBox =
      HiveBoxes.organizationEventsBox;

  @override
  Future<Either<Failure, OrganizationHomeModel>> getOrganizationHome() async {
    try {
      final response = await DioHelper.get(url: ORGANIZATION_HOME);

      return Right(OrganizationHomeModel.fromJson(response.data));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
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

  // ================= HIVE =================
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

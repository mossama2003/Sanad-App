part of 'chat_repo.dart';

class ChatRepoImpel implements ChatRepo {
  @override
  Future<Either<Failure, ChatTokenModel>> getChatToken(int eventId) async {
    try {
      final response = await DioHelper.get(url: GET_CHAT_TOKEN(eventId));

      if (response.statusCode == 200) {
        return right(ChatTokenModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedEventChatModel>> getChatHistory({
    required int eventId,
    int page = 1,
  }) async {
    try {
      final response = await DioHelper.get(
        url: GET_CHAT_HISTORY,
        query: {'event': eventId, 'page': page},
      );

      if (response.statusCode == 200) {
        return right(PaginatedEventChatModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, SendChatMessageModel>> sendMessage({
    required int eventId,
    required String message,
    int? parentId,
  }) async {
    try {
      final formData = FormData.fromMap({
        'event': eventId,
        'message': message,
        'parent': ?parentId,
      });

      final response = await DioHelper.post(
        url: SEND_CHAT_MESSAGE,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return right(SendChatMessageModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> updateMemberBatch({
    required int eventId,
    required Map<String, dynamic> body,
  }) async {
    try {
      final response = await DioHelper.patch(
        url: EVENT_MEMBER_BATCH_UPDATE(eventId),
        data: body,
      );

      if (response.statusCode == 200) {
        return right(true);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, SendChatMessageModel>> editMessage({
    required int messageId,
    required String message,
  }) async {
    try {
      final response = await DioHelper.patch(
        url: EDIT_MESSAGE(messageId),
        data: {'message': message},
      );

      if (response.statusCode == 200) {
        // رد الـ Edit بيرجع "message" بس - مفيهوش id
        return right(
          SendChatMessageModel(
            id: messageId,
            event: 0,
            created: DateTime.now(),
            modified: DateTime.now(),
            message: response.data['message'].toString(),
          ),
        );
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, List<int>>> deleteMessages(List<int> ids) async {
    try {
      final formData = FormData();
      for (final id in ids) {
        formData.fields.add(MapEntry('ids', id.toString()));
      }

      final response = await DioHelper.post(
        url: DELETE_MESSAGE,
        data: formData,
      );

      if (response.statusCode == 200) {
        final deletedIds = (response.data['ids'] as List<dynamic>? ?? [])
            .map((e) => e as int)
            .toList();
        return right(deletedIds);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedMemberModel>> getEventMembers({
    required int eventId,
    int page = 1,
    int? size,
    String? search,
    String? ordering,
  }) async {
    try {
      String? currentLocation;
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
          ),
        );
        currentLocation = '${position.longitude},${position.latitude}';
      } catch (_) {}

      final response = await DioHelper.get(
        url: EVENT_MEMBERS,
        query: {
          'event': eventId,
          'page': page,
          'size': ?size,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
          if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
        },
        headers: {'Current-Location': ?currentLocation},
      );

      if (response.statusCode == 200) {
        return right(PaginatedMemberModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, String>> updateVolunteerRole({
    required int memberId,
    required String role,
  }) async {
    try {
      final formData = FormData.fromMap({'role': role});

      final response = await DioHelper.patch(
        url: MANAGE_EVENT_MEMBER(memberId),
        data: formData,
      );

      if (response.statusCode == 200) {
        return right((response.data['role'] ?? role).toString());
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, bool>> leaveEvent(int eventId) async {
    try {
      final response = await DioHelper.post(
        url: LEAVE_EVENT_CHAT,
        data: {'event': eventId},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return right(true);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, EventReportModel>> reportEvent({
    required int eventId,
    String? reason,
  }) async {
    try {
      final response = await DioHelper.post(
        url: REPORT_EVENT_CHAT,
        data: {
          'event': eventId,
          if (reason != null && reason.trim().isNotEmpty)
            'reason': reason.trim(),
        },
      );

      if (response.statusCode == 201) {
        return right(EventReportModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, PaginatedSearchResultModel>> searchMessages({
    required int eventId,
    required String query,
    int page = 1,
  }) async {
    try {
      final response = await DioHelper.get(
        url: SEARCH_CHAT_MESSAGES,
        query: {'event': eventId, 'q': query, 'page': page},
      );

      if (response.statusCode == 200) {
        return right(PaginatedSearchResultModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }

  @override
  Future<Either<Failure, EventChatContextModel>> getMessageContext({
    required int eventId,
    required int messageId,
  }) async {
    try {
      final response = await DioHelper.get(
        url: SEARCH_CHAT_CONTEXT,
        query: {'event': eventId, 'message_id': messageId},
      );

      if (response.statusCode == 200) {
        return right(EventChatContextModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

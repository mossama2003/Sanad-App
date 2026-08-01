part of 'chat_repo.dart';

// chat_repo_impl.dart
class ChatRepoImpel implements ChatRepo {
  @override
  Future<Either<String, ChatTokenModel>> getChatToken(int eventId) async {
    try {
      final response = await DioHelper.get(url: GET_CHAT_TOKEN(eventId));
      return Right(ChatTokenModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        e.response?.data['detail']?.toString() ?? 'chat_token_error'.tr(),
      );
    } catch (_) {
      return Left('something_went_wrong'.tr());
    }
  }

  @override
  Future<Either<String, PaginatedEventChatModel>> getChatHistory({
    required int eventId,
    int page = 1,
  }) async {
    try {
      final response = await DioHelper.get(
        url: GET_CHAT_HISTORY,
        query: {'event': eventId, 'page': page},
      );
      return Right(PaginatedEventChatModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(
        e.response?.data['detail']?.toString() ?? 'chat_history_error'.tr(),
      );
    } catch (_) {
      return Left('something_went_wrong'.tr());
    }
  }

  @override
  Future<Either<String, SendChatMessageModel>> sendMessage({
    required int eventId,
    required String message,
  }) async {
    try {
      final formData = FormData.fromMap({'event': eventId, 'message': message});

      final response = await DioHelper.post(
        url: SEND_CHAT_MESSAGE,
        data: formData,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        return Left(_extractErrorMessage(response.data));
      }

      if (response.data['id'] == null) {
        return Left('send_message_error'.tr());
      }

      return Right(SendChatMessageModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(_extractErrorMessage(e.response?.data));
    } catch (_) {
      return Left('something_went_wrong'.tr());
    }
  }

  String _extractErrorMessage(dynamic data) {
    if (data is Map) {
      if (data['message'] != null) return data['message'].toString();
      if (data['detail'] != null) return data['detail'].toString();

      if (data['errors'] is Map) {
        final errors = data['errors'] as Map;
        final firstKey = errors.keys.firstOrNull;
        if (firstKey != null && errors[firstKey] is List) {
          final list = errors[firstKey] as List;
          if (list.isNotEmpty) return list.first.toString();
        }
      }
    }
    return 'send_message_error'.tr();
  }

  @override
  Future<Either<String, bool>> updateMemberBatch({
    required int eventId,
    required Map<String, dynamic> body,
  }) async {
    try {
      await DioHelper.patch(
        url: EVENT_MEMBER_BATCH_UPDATE(eventId),
        data: body,
      );
      return const Right(true);
    } on DioException catch (e) {
      return Left(
        e.response?.data['detail']?.toString() ?? 'update_failed'.tr(),
      );
    } catch (_) {
      return Left('something_went_wrong'.tr());
    }
  }
}

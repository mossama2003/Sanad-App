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

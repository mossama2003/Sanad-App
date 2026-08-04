import 'package:sanad_app/core/network/remote/api/dio_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/end_points.dart';
import '../models/members_model.dart';
import '../models/chat_model.dart';

part 'chat_repo_impel.dart';

abstract class ChatRepo {
  Future<Either<Failure, ChatTokenModel>> getChatToken(int eventId);

  Future<Either<Failure, PaginatedEventChatModel>> getChatHistory({
    required int eventId,
    int page = 1,
  });

  Future<Either<Failure, bool>> updateMemberBatch({
    required int eventId,
    required Map<String, dynamic> body,
  });

  Future<Either<Failure, SendChatMessageModel>> sendMessage({
    required int eventId,
    required String message,
  });

  Future<Either<Failure, SendChatMessageModel>> editMessage({
    required int messageId,
    required String message,
  });

  Future<Either<Failure, List<int>>> deleteMessages(List<int> ids);

  Future<Either<Failure, PaginatedMembersModel>> getEventMembers({
    required int eventId,
    int page = 1,
    int? size,
    String? search,
    String? ordering,
  });
}

import 'package:sanad_app/core/network/remote/api/dio_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/end_points.dart';
import '../models/event_report_model.dart';
import '../models/member_model.dart';
import '../models/chat_model.dart';
import '../models/search_messages.dart';

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
    int? parentId,
  });

  Future<Either<Failure, SendChatMessageModel>> editMessage({
    required int messageId,
    required String message,
  });

  Future<Either<Failure, List<int>>> deleteMessages(List<int> ids);

  Future<Either<Failure, PaginatedMemberModel>> getEventMembers({
    required int eventId,
    int page = 1,
    int? size,
    String? search,
    String? ordering,
  });

  Future<Either<Failure, String>> updateVolunteerRole({
    required int memberId,
    required String role,
  });

  Future<Either<Failure, bool>> leaveEvent(int eventId);

  Future<Either<Failure, EventReportModel>> reportEvent({
    required int eventId,
    String? reason,
  });

  Future<Either<Failure, PaginatedSearchResultModel>> searchMessages({
    required int eventId,
    required String query,
    int page = 1,
  });

  Future<Either<Failure, EventChatContextModel>> getMessageContext({
    required int eventId,
    required int messageId,
  });
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/network/remote/api/dio_helper.dart';

import '../../../../../core/network/end_points.dart';
import '../models/chat_model.dart';

part 'chat_repo_impel.dart';

abstract class ChatRepo {
  Future<Either<String, ChatTokenModel>> getChatToken(int eventId);

  Future<Either<String, PaginatedEventChatModel>> getChatHistory({
    required int eventId,
    int page = 1,
  });

  Future<Either<String, bool>> updateMemberBatch({
    required int eventId,
    required Map<String, dynamic> body,
  });
}

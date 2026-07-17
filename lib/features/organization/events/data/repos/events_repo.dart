import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../models/create_event_model.dart';
import '../params/create_event_param.dart';

part 'events_repo_impel.dart';

abstract class EventsRepo {
  Future<Either<Failure, CreateEventModel>> createEvent(CreateEventParam param);
}

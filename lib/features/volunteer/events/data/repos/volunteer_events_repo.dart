import 'package:sanad_app/features/volunteer/events/data/models/volunteer_event_details_model.dart';
import 'package:sanad_app/features/volunteer/events/data/params/get_volunteer_events_param.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../../../../core/network/error/failures.dart';
import '../models/paginated_volunteer_event_model.dart';
import '../../../../../core/network/end_points.dart';

part 'volunteer_events_repo_impel.dart';

abstract class VolunteerEventsRepo {
  Future<Either<Failure, PaginatedVolunteerEventModel>> getVolunteerEvents(
    GetVolunteerEventsParam param,
  );
}

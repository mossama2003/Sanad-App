import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../models/create_organization_event_model.dart';
import '../models/get_organization_events_param.dart';
import '../models/organization_event_details_model.dart';
import '../models/paginated_organization_event_model.dart';
import '../params/create_organization_event_param.dart';

part 'Organization_events_repo_impel.dart';

abstract class OrganizationEventsRepo {
  Future<Either<Failure, CreateOrganizationEventModel>> createOrganizationEvent(
    CreateOrganizationEventParam param,
  );

  Future<Either<Failure, PaginatedOrganizationEventModel>>
  getOrganizationEvents(GetOrganizationEventsParam param);

  Future<Either<Failure, void>> deleteOrganizationEvent(int id);
}

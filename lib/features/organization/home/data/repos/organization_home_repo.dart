import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../../events/data/models/create_organization_event_model.dart';
import '../../../events/data/models/organization_event_details_model.dart';
import '../../../events/data/params/organization_event_update_param.dart';
import '../models/organization_home_model.dart';

part 'organization_home_repo_impel.dart';

abstract class OrganizationHomeRepo {
  Future<Either<Failure, OrganizationHomeModel>> getOrganizationHome();

  Future<Either<Failure, void>> deleteOrganizationEvent(int id);

  Future<Either<Failure, CreateOrganizationEventModel>> updateOrganizationEvent(
    OrganizationEventUpdateParam param,
  );
}

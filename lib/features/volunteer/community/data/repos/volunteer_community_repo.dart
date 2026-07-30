import 'package:sanad_app/features/volunteer/events/data/models/volunteer_event_details_model.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/end_points.dart';

part 'volunteer_community_repo_impel.dart';

abstract class VolunteerCommunityRepo {
  Future<Either<Failure, List<VolunteerEventDetailsModel>>> getCommunities({
    required int volunteerId,
    String search = '',
  });
}

import 'package:hive/hive.dart';

import '../../../events/data/models/volunteer_event_details_model.dart';

part 'volunteer_communities_cache.g.dart';

@HiveType(typeId: 5)
class VolunteerCommunitiesCache extends HiveObject {
  @HiveField(0)
  final List<VolunteerEventDetailsModel> communities;

  VolunteerCommunitiesCache({required this.communities});
}

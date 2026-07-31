import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../../../../../core/storage/hive/hive_boxes.dart';
import '../../../events/data/models/volunteer_event_details_model.dart';
import '../../../home/data/enums/volunteer_home_navbar_enum.dart';
import '../../data/model/volunteer_communities_cache.dart';
import '../../data/repos/volunteer_community_repo.dart';
import 'dart:async';

part 'volunteer_community_state.dart';

class VolunteerCommunityCubit extends Cubit<VolunteerCommunityState> {
  VolunteerCommunityCubit(this.repo)
    : _box = HiveBoxes.volunteerCommunitiesBox,
      super(VolunteerCommunityInitial());

  final VolunteerCommunityRepo repo;

  final Box<VolunteerCommunitiesCache> _box;

  List<VolunteerEventDetailsModel> communities = [];

  Timer? _searchDebounce;

  VolunteerHomeNavbarItem selectedItem = VolunteerHomeNavbarItem.home;

  static const String _cacheKey = 'communities';

  Future<void> getCommunities({
    required int volunteerId,
    String search = '',
    String ordering = '-date',
    bool forceRefresh = false,
  }) async {
    /// ================= LOAD CACHE =================

    if (!forceRefresh && search.isEmpty) {
      final cache = _box.get(_cacheKey);

      if (cache != null) {
        communities = List<VolunteerEventDetailsModel>.from(cache.communities);

        emit(Success());
      }
    }

    /// ================= API =================

    final result = await repo.getCommunities(
      volunteerId: volunteerId,
      search: search,
      ordering: ordering,
    );

    result.fold(
      (failure) {
        if (communities.isEmpty) {
          emit(Error());
        }
      },
      (data) async {
        communities = data;

        if (search.isEmpty) {
          await _box.put(
            _cacheKey,
            VolunteerCommunitiesCache(
              communities: List<VolunteerEventDetailsModel>.from(data),
            ),
          );
        }

        emit(Success());
      },
    );
  }

  void search({required int volunteerId, required String query}) {
    _searchDebounce?.cancel();

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      getCommunities(volunteerId: volunteerId, search: query);
    });
  }

  void updateSelectedNavbarItem(VolunteerHomeNavbarItem item) {
    selectedItem = item;
    emit(BottomNavChange());
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();

    return super.close();
  }
}

part of 'rewards_repo.dart';

class RewardsRepoImpel implements RewardsRepo {
  @override
  Future<Either<Failure, List<XpActivityModel>>> getXpActivities({
    required int volunteerId,
    int page = 1,
    int size = 10,
    String? ordering,
  }) async {
    try {
      final List<XpActivityModel> activities = [];
      int currentPage = page;
      int maxPages = 1;

      do {
        final response = await DioHelper.get(
          url: GET_XP_ACTIVITIES(volunteerId),
          query: {
            'page': currentPage,
            'size': size,
            if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
          },
        );

        final data = Map<String, dynamic>.from(response.data as Map);
        final results = data['results'] as List<dynamic>? ?? [];

        activities.addAll(
          results.map(
            (json) => XpActivityModel.fromJson(
              Map<String, dynamic>.from(json as Map),
            ),
          ),
        );

        maxPages = (data['max_pages'] as num?)?.toInt() ?? 1;
        currentPage++;
      } while (currentPage <= maxPages);

      return Right(activities);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LeaderboardModel>>> getLeaderboard({
    int page = 1,
    int size = 10,
  }) async {
    try {
      final response = await DioHelper.get(
        url: GET_LEADERBOARD,
        query: {'page': page, 'size': size},
      );

      final data = Map<String, dynamic>.from(response.data as Map);
      final results = data['results'] as List<dynamic>? ?? [];

      final leaderboard = results.asMap().entries.map((entry) {
        final json = Map<String, dynamic>.from(entry.value as Map);

        return LeaderboardModel.fromJson(json, rank: entry.key + 1);
      }).toList();

      return Right(leaderboard);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

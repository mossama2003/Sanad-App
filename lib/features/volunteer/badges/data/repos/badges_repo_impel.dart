part of 'badges_repo.dart';

class BadgesRepoImpel implements BadgesRepo {
  Future<Either<Failure, List<BadgeModel>>> getAllBadges({
    int page = 1,
    int size = 20,
    String? search,
    String? ordering,
  }) async {
    try {
      final List<BadgeModel> allBadges = [];
      int currentPage = page;
      int maxPages = 1;

      do {
        final response = await DioHelper.get(
          url: GET_ALL_BADGES,
          query: {
            'page': currentPage,
            'size': size,
            if (search != null && search.isNotEmpty) 'search': search,
            if (ordering != null && ordering.isNotEmpty) 'ordering': ordering,
          },
        );

        final data = response.data as Map<String, dynamic>;

        final results = (data['results'] as List<dynamic>? ?? []);

        allBadges.addAll(
          results.map(
            (json) => BadgeModel.fromJson(json as Map<String, dynamic>),
          ),
        );

        maxPages = (data['max_pages'] as num?)?.toInt() ?? 1;
        currentPage++;
      } while (currentPage <= maxPages);

      return Right(allBadges);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

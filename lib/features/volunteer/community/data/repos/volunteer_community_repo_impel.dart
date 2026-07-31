part of 'volunteer_community_repo.dart';

class VolunteerCommunityRepoImpel implements VolunteerCommunityRepo {
  @override
  Future<Either<Failure, List<VolunteerEventDetailsModel>>> getCommunities({
    required int volunteerId,
    String search = '',
    String ordering = '-date',
  }) async {
    try {
      final response = await DioHelper.get(
        url: VOLUNTEER_COMMUNITIES,
        query: {
          'joiners': volunteerId,
          'ordering': '-date',
          if (search.trim().isNotEmpty) 'search': search.trim(),
        },
      );

      final List data = response.data['results'];

      return Right(
        data.map((e) => VolunteerEventDetailsModel.fromJson(e)).toList(),
      );
    } catch (e) {
      return Left(ServerFailure.fromCatchError(e));
    }
  }
}

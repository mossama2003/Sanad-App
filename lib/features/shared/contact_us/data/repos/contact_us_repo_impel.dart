part of 'contact_us_repo.dart';

class ContactUsRepoImpel implements ContactUsRepo {
  @override
  Future<Either<Failure, void>> submitContactUs({
    required String comment,
  }) async {
    try {
      final response = await DioHelper.post(
        url: CONTACT_US,
        data: {'comment': comment, 'response': 'Pending'},
      );

      if (response.statusCode == 201) {
        return right(null);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

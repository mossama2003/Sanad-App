part of 'faq_repo.dart';

class FaqRepoImpel implements FaqRepo {
  @override
  Future<Either<Failure, FaqPaginationModel>> getFaqs({
    int page = 1,
    int size = 20,
    String? search,
  }) async {
    try {
      final response = await DioHelper.get(
        url: FAQS,
        query: {
          'page': page,
          'size': size,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
        },
      );

      if (response.statusCode == 200) {
        return right(FaqPaginationModel.fromJson(response.data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

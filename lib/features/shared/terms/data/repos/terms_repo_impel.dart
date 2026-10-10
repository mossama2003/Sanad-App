part of 'terms_repo.dart';

class TermsRepoImpel implements TermsRepo {
  @override
  Future<Either<Failure, TermsResponseModel>> getTerms({
    int page = 1,
    int size = 10,
    String? search,
    String? termType,
  }) async {
    try {
      final query = <String, dynamic>{
        'page': page,
        'size': size,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
        if (termType != null && termType.isNotEmpty) 'term_type': termType,
      };

      final response = await DioHelper.get(url: TERMS_CONDITIONS, query: query);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        return right(TermsResponseModel.fromJson(data));
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

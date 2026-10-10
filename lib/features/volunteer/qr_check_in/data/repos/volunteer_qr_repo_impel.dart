part of 'volunteer_qr_repo.dart';

class VolunteerQrRepoImpl implements VolunteerQrRepo {
  @override
  Future<Either<Failure, dynamic>> checkInEvent(QrCheckInParam param) async {
    try {
      final response = await DioHelper.post(url: SCAN_QR, data: param.toJson());

      if (response.statusCode == 201) {
        return right(response.data);
      }

      return left(ServerFailure.fromResponse(response));
    } catch (e) {
      return left(ServerFailure.fromCatchError(e));
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../../../core/network/end_points.dart';
import '../../../../../core/network/error/failures.dart';
import '../../../../../core/network/remote/api/dio_helper.dart';
import '../params/qr_check_in_param.dart';

part 'volunteer_qr_repo_impel.dart';

abstract class VolunteerQrRepo {
  Future<Either<Failure, dynamic>> checkInEvent(QrCheckInParam param);
}

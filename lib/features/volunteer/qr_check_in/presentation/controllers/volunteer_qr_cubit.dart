import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../data/params/qr_check_in_param.dart';
import '../../data/repos/volunteer_qr_repo.dart';

part 'volunteer_qr_state.dart';

class VolunteerQrCubit extends Cubit<VolunteerQrState> {
  VolunteerQrCubit(this.repo) : super(QrCheckInInitial());

  final VolunteerQrRepo repo;

  Future<void> checkIn({required String qr, required int eventId}) async {
    emit(Loading());

    final result = await repo.checkInEvent(
      QrCheckInParam(qr: qr, event: eventId),
    );

    result.fold(
      (l) {
        AppToast.error(l.errMessage);

        emit(Error());
      },

      (r) {
        AppToast.success("volunteer.qr_check_in.checked_in_successfully".tr());
        emit(Success());
        AppNavigator.pop();
      },
    );
  }
}

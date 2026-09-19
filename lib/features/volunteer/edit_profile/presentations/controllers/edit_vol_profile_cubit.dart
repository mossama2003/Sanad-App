import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../data/params/update_vol_profile_param.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../data/repos/edit_vol_profile_repo.dart';

part 'edit_vol_profile_state.dart';

class EditVolProfileCubit extends Cubit<EditVolProfileState> {
  EditVolProfileCubit(this.repo) : super(Initial());

  final EditVolProfileRepo repo;

  static EditVolProfileCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> saveVolProfile({
    required BuildContext context,
    required UpdateVolAccountParam accountParam,
    required UpdateVolProfileParam volunteerParam,
  }) async {
    emit(Loading());

    final accountResult = await repo.updateAccount(accountParam);

    if (accountResult.isLeft()) {
      emit(Error());
      accountResult.fold((l) => AppToast.error(l.errMessage), (r) {});
      return;
    }

    final volunteerResult = await repo.updateVolunteerProfile(volunteerParam);

    if (volunteerResult.isLeft()) {
      emit(Error());
      volunteerResult.fold((l) => AppToast.error(l.errMessage), (r) {});
      return;
    }

    if (context.mounted) {
      await AppCubit.get(context).getUser();
    }

    emit(Success());

    AppToast.success(
      'volunteer.edit_profile.profile_updated_successfully'.tr(),
    );

    if (context.mounted) {
      AppNavigator.pop();
    }
  }
}

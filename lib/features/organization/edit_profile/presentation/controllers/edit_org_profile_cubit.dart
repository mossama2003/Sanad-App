import 'package:sanad_app/features/organization/edit_profile/data/params/update_org_profile_param.dart';
import 'package:sanad_app/features/organization/edit_profile/data/repos/edit_org_profile_repo.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/helper/app_toast.dart';

part 'edit_org_profile_state.dart';

class EditOrgProfileCubit extends Cubit<EditOrgProfileState> {
  EditOrgProfileCubit(this.repo) : super(Initial());

  final EditOrgProfileRepo repo;

  static EditOrgProfileCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> saveOrgProfile({
    required BuildContext context,
    required UpdateOrgAccountParam accountParam,
    required UpdateOrgProfileParam organizationParam,
  }) async {
    emit(Loading());

    final accountResult = await repo.updateAccount(accountParam);

    if (accountResult.isLeft()) {
      emit(Error());
      accountResult.fold((l) => AppToast.error(l.errMessage), (r) {});
      return;
    }

    final volunteerResult = await repo.updateOrganizationProfile(
      organizationParam,
    );

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

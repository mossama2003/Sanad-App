import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/features/shared/auth/data/repos/sign_in/sign_in_repo.dart';
import 'package:sanad_app/features/volunteer/home/presentation/screens/volunteer_home_body.dart';

import '../../../../../../core/helper/app_navigator.dart';
import '../../../../../../core/helper/app_toast.dart';
import '../../../../../../core/network/end_points.dart';
import '../../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../../core/network/remote/api/dio_helper.dart';
import '../../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../organization/home/presentation/screens/organization_home_body.dart';
import '../../../data/params/sign_in_param.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.repo) : super(SignInInitial());

  final SignInRepo repo;

  static SignInCubit get(BuildContext context) => BlocProvider.of(context);

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void updateObscurePassword() {
    obscurePassword = !obscurePassword;
    emit(UpdateObscurePassword());
  }

  Future<void> signIn() async {
    if (!formKey.currentState!.validate()) return;

    emit(Loading());

    final appCubit = AppCubit.get(AppNavigator.context);

    final api = await repo.signIn(
      SignInParam(
        email: emailController.text.trim(),
        password: passwordController.text,
      ),
    );

    api.fold(
      (failure) {
        emit(Error());

        AppToast.error(failure.errMessage);
      },

      (auth) async {
        // Save Tokens
        await CacheHelper.save(CacheKeys.accessToken, auth.access);

        await CacheHelper.save(CacheKeys.accessToken, auth.access);

        // Debug cookies
        final cookies = await DioHelper.cookieJar.loadForRequest(
          Uri.parse(BASE_URL),
        );

        debugPrint("LOGIN COOKIES => $cookies");

        debugPrint("ACCESS TOKEN => ${auth.access}");
        debugPrint("REFRESH TOKEN => ${auth.refresh}");

        // Get User Data
        final user = await appCubit.getUser();

        if (user == null) {
          emit(Error());
          AppToast.error('shared.sign_in.user_not_found'.tr());
          return;
        }

        if (user.profile?.id != null) {
          await CacheHelper.save(CacheKeys.profileId, user.profile!.id!);
        }

        emit(Success());

        AppToast.success('shared.sign_in.account_signed_in'.tr());

        final role = user.role;

        if (role == null) {
          AppToast.error('shared.sign_in.user_role_not_found'.tr());

          return;
        }

        switch (role) {
          case 'volunteer':
            AppNavigator.remove(const VolunteerHomeBody());
            break;

          case 'organization':
            AppNavigator.remove(const OrganizationHomeBody());
            break;

          default:
            AppToast.error('Unknown role: $role');
        }
      },
    );
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

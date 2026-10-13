import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/features/shared/auth/data/repos/sign_in/sign_in_repo.dart';
import 'package:sanad_app/features/volunteer/home/presentation/screens/volunteer_home_body.dart';

import '../../../../../../core/helper/app_navigator.dart';
import '../../../../../../core/helper/app_toast.dart';
import '../../../../../../core/network/local/cache/cache_helper.dart';
import '../../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../organization/home/presentation/screens/organization_home_body.dart';
import '../../../data/params/sign_in_param.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this.repo) : super(SignInInitial());

  final SignInRepo repo;

  static SignInCubit get(BuildContext context) =>
      BlocProvider.of<SignInCubit>(context);

  final formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  void updateObscurePassword() {
    obscurePassword = !obscurePassword;
    emit(UpdateObscurePassword());
  }

  Future<void> signIn() async {
    if (formKey.currentState?.validate() != true) return;

    emit(Loading());

    try {
      final appCubit = AppCubit.get(AppNavigator.context);

      final api = await repo.signIn(
        SignInParam(
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );

      await api.fold<Future<void>>(
        (failure) async {
          emit(Error());
          AppToast.error(failure.errMessage);
        },
        (auth) async {
          final accessToken = auth.access;

          if (accessToken!.isEmpty) {
            emit(Error());
            AppToast.error('shared.sign_in.user_not_found'.tr());
            return;
          }

          await CacheHelper.save(CacheKeys.accessToken, accessToken);

          final refreshToken = auth.refresh;

          if (refreshToken != null && refreshToken.isNotEmpty) {
            await CacheHelper.save(CacheKeys.refreshToken, refreshToken);
          } else {
            await CacheHelper.remove(CacheKeys.refreshToken);
          }

          final user = await appCubit.getUser();

          if (user == null) {
            emit(Error());
            AppToast.error('shared.sign_in.user_not_found'.tr());
            return;
          }

          final profileId = user.profile?.id;

          if (profileId != null) {
            await CacheHelper.save(CacheKeys.profileId, profileId);
          }

          final userId = user.id;

          if (userId != null) {
            await CacheHelper.save(CacheKeys.userId, userId);
          }

          final role = user.role;

          if (role == null || role.isEmpty) {
            emit(Error());
            AppToast.error('shared.sign_in.user_role_not_found'.tr());
            return;
          }

          emit(Success());

          AppToast.success('shared.sign_in.account_signed_in'.tr());

          switch (role) {
            case 'volunteer':
              AppNavigator.remove(const VolunteerHomeBody());
              break;

            case 'organization':
              AppNavigator.remove(const OrganizationHomeBody());
              break;

            default:
              emit(Error());
              AppToast.error('Unknown role: $role');
          }
        },
      );
    } catch (e, stackTrace) {
      debugPrint('SIGN IN ERROR: $e');
      debugPrintStack(stackTrace: stackTrace);

      emit(Error());
      AppToast.error('Something went wrong. Please try again.');
    }
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}

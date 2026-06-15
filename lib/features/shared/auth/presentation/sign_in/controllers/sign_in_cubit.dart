import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/features/shared/auth/data/repos/sign_in/sign_in_repo.dart';
import 'package:sanad_app/features/volunteer/home/presentation/screens/volunteer_home_body.dart';

import '../../../../../../core/helper/app_navigator.dart';
import '../../../../../../core/helper/app_toast.dart';
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
      (auth) {
        emit(Success());
        AppToast.success('shared_sign_in.account_signed_in'.tr());

        final user = auth.user;
        final role = user?.role;

        if (role == null) {
          AppToast.error('User role not found');
          return;
        }

        switch (role) {
          case 'volunteer':
            AppNavigator.replace(const VolunteerHomeBody());
            break;

          case 'organization':
            AppNavigator.replace(const OrganizationHomeBody());
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

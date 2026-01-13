import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/auth/data/models/user_model.dart';
import '../../../../features/auth/data/repos/auth_repo.dart';
import '../../../../features/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../../helper/app_navigator.dart';
import '../../../network/local/cache/cache_helper.dart';

part 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  UserModel? user;

  Future<UserModel?> getAuth() async {
    final repo = AuthRepoImpel();
    final api = await repo.getAuth();
    api.fold(
      (error) async {
        await CacheHelper.remove(CacheKeys.token);
        user = null;
      },
      (result) {
        user = result;
      },
    );
    return user;
  }

  Future<void> logoutAuth() async {
    user = null;
    await CacheHelper.remove(CacheKeys.token);
    AppNavigator.remove(SignInScreen());
  }
}

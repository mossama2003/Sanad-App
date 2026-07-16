import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../features/shared/auth/data/models/user_model.dart';
import '../../../network/end_points.dart';
import '../../../network/local/cache/cache_helper.dart';
import '../../../network/remote/api/dio_helper.dart';

part 'app_states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(BuildContext context) => BlocProvider.of(context);

  UserModel? user;

  // ================= GET USER =================
  Future<UserModel?> getUser() async {
    try {
      var accessToken = CacheHelper.get(CacheKeys.accessToken);

      if (accessToken == null) {
        return null;
      }

      Response response = await DioHelper.get(
        url: GET_USER,
        headers: {"Authorization": "Bearer $accessToken"},
      );

      // ================= SUCCESS =================
      if (response.statusCode == 200) {
        user = UserModel.fromJson(response.data);

        emit(UserLoaded(user!));

        return user;
      }

      // ================= TOKEN EXPIRED =================
      if (response.statusCode == 401 || response.statusCode == 403) {
        final refreshed = await refreshToken();

        if (refreshed) {
          accessToken = CacheHelper.get(CacheKeys.accessToken);

          final retryResponse = await DioHelper.get(
            url: GET_USER,
            headers: {"Authorization": "Bearer $accessToken"},
          );

          if (retryResponse.statusCode == 200) {
            user = UserModel.fromJson(retryResponse.data);

            emit(UserLoaded(user!));

            return user;
          }
        }
      }
    } catch (e) {
      debugPrint("GET USER ERROR => $e");
    }

    // ================= LOGOUT =================

    user = null;

    await CacheHelper.remove(CacheKeys.accessToken);
    await CacheHelper.remove(CacheKeys.refreshToken);

    emit(ErrorState());

    return null;
  }

  // ================= REFRESH TOKEN =================
  Future<bool> refreshToken() async {
    try {
      final refresh = CacheHelper.get(CacheKeys.refreshToken);

      if (refresh == null) {
        return false;
      }

      final response = await DioHelper.post(
        url: REFRESH_TOKEN,
        // data: {"refresh": refresh},
      );

      if (response.statusCode == 200) {
        final newAccess = response.data["access"];

        await CacheHelper.save(CacheKeys.accessToken, newAccess);

        // لو الباك بيرجع refresh جديد
        if (response.data["refresh"] != null) {
          await CacheHelper.save(
            CacheKeys.refreshToken,
            response.data["refresh"],
          );
        }

        return true;
      }
    } catch (e) {
      debugPrint("REFRESH TOKEN ERROR => $e");
    }

    return false;
  }

  // ================= LOG OUT =================
  Future<void> logOut() async {
    try {
      final token = CacheHelper.get(CacheKeys.accessToken);

      if (token != null) {
        await DioHelper.post(
          url: LOG_OUT,
          headers: {"Authorization": "Bearer $token"},
        );
      }
    } catch (e) {
      debugPrint("LOG OUT ERROR => $e");
    }

    await CacheHelper.remove(CacheKeys.accessToken);

    await CacheHelper.remove(CacheKeys.refreshToken);

    user = null;

    emit(UserLoggedOut());
  }
}

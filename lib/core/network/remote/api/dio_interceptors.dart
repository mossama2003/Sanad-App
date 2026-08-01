import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../end_points.dart';
import '../../local/cache/cache_helper.dart';

/// An interceptor that handles the error responses from a [DIO] request.
class DioInterceptors extends Interceptor {
  final Dio dio;

  DioInterceptors(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? lang = CacheHelper.get(CacheKeys.lang);

    final String? accessToken = CacheHelper.get(CacheKeys.accessToken);

    debugPrint("TOKEN FROM CACHE => $accessToken");
    debugPrint("PROFILE ID FROM CACHE => ${CacheHelper.get(CacheKeys.profileId)}");
    debugPrint("USER ID FROM CACHE => ${CacheHelper.get(CacheKeys.userId)}");

    if (lang != null && lang.isNotEmpty) {
      options.headers['lang'] = lang;
    }

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      final refreshToken = CacheHelper.get(CacheKeys.refreshToken);

      if (refreshToken != null) {
        try {
          final response = await dio.post(
            REFRESH_TOKEN,
            data: {"refresh": refreshToken},
          );

          if (response.statusCode == 200) {
            final newAccessToken = response.data['access'];

            await CacheHelper.save(CacheKeys.accessToken, newAccessToken);

            final options = err.requestOptions;

            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final retryResponse = await dio.fetch(options);

            return handler.resolve(retryResponse);
          }
        } catch (e) {
          debugPrint("REFRESH TOKEN ERROR => $e");
        }
      }
    }

    return handler.next(err);
  }
}

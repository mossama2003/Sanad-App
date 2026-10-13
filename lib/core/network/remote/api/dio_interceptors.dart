import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../end_points.dart';
import '../../local/cache/cache_helper.dart';

/// An interceptor that handles the error responses from a [DIO] request.
class DioInterceptors extends Interceptor {
  final Dio dio;

  DioInterceptors(this.dio);

  bool _isPublicRequest(RequestOptions options) {
    final path = options.path.toLowerCase();

    return options.extra['skipAuth'] == true ||
        path.endsWith('/auth/login/') ||
        path.endsWith('/auth/register/');
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final lang = CacheHelper.get(CacheKeys.lang)?.toString();
    final skipAuth = _isPublicRequest(options);

    if (lang != null && lang.isNotEmpty) {
      options.headers['lang'] = lang;
    }

    if (skipAuth) {
      options.headers.remove('Authorization');
      options.headers.remove('authorization');
    } else {
      final accessToken = CacheHelper.get(CacheKeys.accessToken)?.toString();

      if (accessToken != null && accessToken.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $accessToken';
      } else {
        options.headers.remove('Authorization');
        options.headers.remove('authorization');
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final statusCode = err.response?.statusCode;

    if (_isPublicRequest(requestOptions)) {
      handler.next(err);
      return;
    }

    if (statusCode != 401) {
      handler.next(err);
      return;
    }

    if (requestOptions.extra['retriedAfterRefresh'] == true) {
      handler.next(err);
      return;
    }

    final refreshToken = CacheHelper.get(CacheKeys.refreshToken)?.toString();

    if (refreshToken == null || refreshToken.isEmpty) {
      handler.next(err);
      return;
    }

    try {
      final refreshResponse = await dio.post(
        REFRESH_TOKEN,
        data: {'refresh': refreshToken},
        options: Options(extra: {'skipAuth': true, 'isTokenRefresh': true}),
      );

      if (refreshResponse.statusCode != 200) {
        handler.next(err);
        return;
      }

      final newAccessToken = refreshResponse.data['access']?.toString();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        handler.next(err);
        return;
      }

      await CacheHelper.save(CacheKeys.accessToken, newAccessToken);

      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

      requestOptions.extra['retriedAfterRefresh'] = true;

      final retryResponse = await dio.fetch(requestOptions);

      handler.resolve(retryResponse);
    } on DioException catch (e) {
      debugPrint('Token refresh failed: ${e.response?.statusCode}');
      handler.next(err);
    } catch (e) {
      debugPrint('Token refresh failed: $e');
      handler.next(err);
    }
  }
}

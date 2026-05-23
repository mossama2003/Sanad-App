import 'package:dio/dio.dart';

import '../../local/cache/cache_helper.dart';

/// An interceptor that handles the error responses from a [DIO] request.
class AppInterceptors extends Interceptor {
  final Dio dio;

  AppInterceptors(this.dio);

  /// On [REQUEST] API
  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final String? lang = CacheHelper.get('lang');
    final String? token = CacheHelper.get('token');
    options.headers.addAll({
      'lang': ?lang,
      if (token != null) 'Authorization': 'Bearer $token',
    });
    return handler.next(options);
  }

  /// On [RESPONSE] API
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    return handler.next(response);
  }
}


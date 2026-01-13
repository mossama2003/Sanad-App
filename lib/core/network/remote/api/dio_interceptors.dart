import 'package:dio/dio.dart';

import '../../../helper/app_locals.dart';
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
    final String? token = await CacheHelper.get(CacheKeys.token);
    options.headers.addAll({
      'Accept': 'application/json',
      'Accept-Language': AppLocales.currentLocaleCode,
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

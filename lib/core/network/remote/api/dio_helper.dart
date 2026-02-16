import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'dio_interceptors.dart';

class DioHelper {
  static Dio? dio;

  /// DIO INITIALIZATION
  static void init() async {
    dio = Dio(
      BaseOptions(
        // baseUrl: BASE_URL,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) => status! < 500,
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 30),
      ),
    );
    dio!.interceptors.addAll([
      AppInterceptors(dio!),
      if (kDebugMode)
        PrettyDioLogger(
          error: true,
          request: true,
          requestBody: true,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
        ),
    ]);
  }

  static Future<Response> post({
    Options? options,
    FormData? formData,
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    return dio!.post(
      endPoint,
      options: options,
      queryParameters: query,
      data: formData ?? data,
    );
  }

  static Future<Response> get({
    Options? options,
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    return dio!.get(endPoint, queryParameters: query, options: options);
  }

  static Future<Response> put({
    Options? options,
    required String endPoint,
    FormData? formData,
    Map<String, dynamic>? data,
    Map<String, dynamic>? query,
  }) async {
    return dio!.put(
      endPoint,
      data: formData ?? data,
      options: options,
      queryParameters: query,
    );
  }

  static Future<Response> delete({
    Options? options,
    required String endPoint,
    Map<String, dynamic>? query,
  }) async {
    return dio!.delete(endPoint, queryParameters: query, options: options);
  }

  static Future<Response> download ({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    Map<String, dynamic>? query,
    Options? options,
  }) async {
    return dio!.download(
      url,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: query,
      options: options,
    );
  }
}

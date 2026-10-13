import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../end_points.dart';
import 'dio_interceptors.dart';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

class DioHelper {
  static Dio? dio;
  static late CookieJar cookieJar;

  static Future<void> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) => status != null && status < 500,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        maxRedirects: 5,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    cookieJar = CookieJar();

    dio!.interceptors.add(CookieManager(cookieJar));
    dio!.interceptors.add(DioInterceptors(dio!));

    if (kDebugMode) {
      dio!.interceptors.add(
        PrettyDioLogger(
          error: true,
          request: true,
          requestBody: false,
          responseBody: true,
          requestHeader: false,
          responseHeader: false,
        ),
      );
    }
  }

  static String _buildUrl(String url, {bool useFullUrl = false}) {
    if (useFullUrl || url.startsWith('http')) {
      return url;
    }

    return '$BASE_URL$url';
  }

  static Options _buildOptions({
    Map<String, dynamic>? headers,
    Options? options,
    bool skipAuth = false,
  }) {
    final currentOptions = options ?? Options();

    return currentOptions.copyWith(
      headers: {...?currentOptions.headers, ...?headers},
      extra: {...?currentOptions.extra, if (skipAuth) 'skipAuth': true},
    );
  }

  static Future<Response> get({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
    bool useFullUrl = false,
    bool skipAuth = false,
  }) async {
    return dio!.get(
      _buildUrl(url, useFullUrl: useFullUrl),
      queryParameters: query,
      data: data,
      options: _buildOptions(
        headers: headers,
        options: options,
        skipAuth: skipAuth,
      ),
    );
  }

  static Future<Response> post({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
    bool useFullUrl = false,
    bool skipAuth = false,
  }) async {
    return dio!.post(
      _buildUrl(url, useFullUrl: useFullUrl),
      data: data,
      queryParameters: query,
      options: _buildOptions(
        headers: headers,
        options: options,
        skipAuth: skipAuth,
      ),
    );
  }

  static Future<Response> put({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
    bool useFullUrl = false,
    bool skipAuth = false,
  }) async {
    return dio!.put(
      _buildUrl(url, useFullUrl: useFullUrl),
      data: data,
      queryParameters: query,
      options: _buildOptions(
        headers: headers,
        options: options,
        skipAuth: skipAuth,
      ),
    );
  }

  static Future<Response> patch({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
    bool useFullUrl = false,
    bool skipAuth = false,
  }) async {
    return dio!.patch(
      _buildUrl(url, useFullUrl: useFullUrl),
      data: data,
      queryParameters: query,
      options: _buildOptions(
        headers: headers,
        options: options,
        skipAuth: skipAuth,
      ),
    );
  }

  static Future<Response> delete({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
    bool useFullUrl = false,
    bool skipAuth = false,
  }) async {
    return dio!.delete(
      _buildUrl(url, useFullUrl: useFullUrl),
      data: data,
      queryParameters: query,
      options: _buildOptions(
        headers: headers,
        options: options,
        skipAuth: skipAuth,
      ),
    );
  }
}

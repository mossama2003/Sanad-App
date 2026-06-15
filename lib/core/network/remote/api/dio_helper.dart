import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../end_points.dart';
import 'dio_interceptors.dart';

class DioHelper {
  static Dio? dio;

  static void init() {
    dio = Dio(
      BaseOptions(
        baseUrl: BASE_URL,
        followRedirects: false,
        receiveDataWhenStatusError: true,
        validateStatus: (status) => status! < 500,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        maxRedirects: 5,
      ),
    );
    dio!.options.headers = {'Content-Type': 'application/json'};
    dio!.interceptors.addAll({
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
    });
  }

  static String _buildUrl(String url, {bool useFullUrl = false}) {
    if (useFullUrl) return url;
    return '$BASE_URL$url';
  }

  /// METHOD [POST]
  static Future<Response> post({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    Options? options,
    bool useFullUrl = false,
  }) async {
    dio!.options.headers = headers ?? {'Content-Type': 'application/json'};
    return await dio!.post(
      _buildUrl(url, useFullUrl: useFullUrl),
      data: data,
      queryParameters: query,
      options: options,
    );
  }

  /// METHOD [GET]
  static Future<Response> get({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    bool useFullUrl = false,
  }) async {
    final isFullUrl = useFullUrl || url.startsWith('http');

    return await dio!.get(
      _buildUrl(url, useFullUrl: isFullUrl),
      queryParameters: query,
      data: data,
      options: Options(headers: headers),
    );
  }

  /// METHOD [DELETE]
  static Future<Response> delete({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    bool useFullUrl = false,
  }) async {
    dio!.options.headers = headers ?? {'Content-Type': 'application/json'};
    return await dio!.delete(
      _buildUrl(url, useFullUrl: useFullUrl),
      data: data,
      queryParameters: query,
    );
  }

  /// METHOD [PATCH]
  static Future<Response> patch({
    required String url,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    dynamic data,
    bool useFullUrl = false,
  }) async {
    dio!.options.headers = headers ?? {'Content-Type': 'application/json'};
    return await dio!.patch(
      _buildUrl(url, useFullUrl: useFullUrl),
      data: data,
      queryParameters: query,
    );
  }

  /// METHOD [PUT]
  static Future<Response> put({
    required String url,
    Map<String, dynamic>? query,
    dynamic data,
    bool useFullUrl = false,
  }) async {
    return await dio!.put(
      _buildUrl(url, useFullUrl: useFullUrl),
      data: data,
      queryParameters: query,
    );
  }

  /// METHOD [DOWNLOAD]
  static Future<void> download({
    required String url,
    required String savePath,
    Map<String, dynamic>? headers,
    ProgressCallback? onReceiveProgress,
    bool useFullUrl = false,
  }) async {
    try {
      dio!.options.headers = headers ?? {'Content-Type': 'application/json'};
      await dio!.download(
        _buildUrl(url, useFullUrl: useFullUrl),
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      throw Exception('Download failed: $e');
    }
  }
}

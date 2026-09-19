import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';

import '../../core/config/api_config.dart';

class ApiService {
  ApiService()
    : dio = Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: const Duration(seconds: 8),
          receiveTimeout: const Duration(seconds: 8),
          sendTimeout: const Duration(seconds: 8),
          headers: const {
            'Content-Type': 'application/json; charset=utf-8',
            'Accept': 'application/json',
          },
        ),
      ) {
    if (kDebugMode) {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            _log('--> ${options.method} ${options.path}');
            _log('baseUrl: ${options.baseUrl}');
            _log('query: ${_safeLogData(options.queryParameters)}');
            _log('body: ${_safeLogData(options.data)}');
            handler.next(options);
          },
          onResponse: (response, handler) {
            _log(
              '<-- ${response.statusCode} '
              '${response.requestOptions.method} ${response.requestOptions.path}',
            );
            _log('response: ${_safeLogData(response.data)}');
            handler.next(response);
          },
          onError: (error, handler) {
            _log(
              '<-- ERROR ${error.response?.statusCode ?? 'NO_RESPONSE'} '
              '${error.requestOptions.method} ${error.requestOptions.path}',
            );
            _log('message: ${error.message}');
            _log('type: ${error.type}');
            _log('response: ${_safeLogData(error.response?.data)}');
            handler.next(error);
          },
        ),
      );
    }
  }

  final Dio dio;

  bool get isConfigured => ApiConfig.baseUrl.trim().isNotEmpty;

  void setUserKey(String userKey) {
    dio.options.headers['X-User-Key'] = userKey;
  }

  void clearUserKey() {
    dio.options.headers.remove('X-User-Key');
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.get<T>(path, queryParameters: queryParameters, options: options);
  }

  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> put<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> patch<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  Future<Response<T>> delete<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) {
    return dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
  }

  void _log(String message) {
    debugPrint('[ICELINK API] $message');
  }

  Object? _safeLogData(Object? data) {
    if (data is Map) {
      return data.map((key, value) {
        final keyText = '$key'.toLowerCase();
        if (keyText == 'x-user-key' ||
            keyText == 'userkey' ||
            keyText == 'authorization') {
          return MapEntry(key, '[redacted]');
        }
        if (keyText == 'answertext') {
          return MapEntry(key, '[redacted-answer-text]');
        }
        return MapEntry(key, _safeLogData(value));
      });
    }
    if (data is List) {
      return data.map(_safeLogData).toList();
    }
    if (data is String && data.length > 500) {
      return '${data.substring(0, 500)}... [truncated]';
    }
    return data;
  }
}

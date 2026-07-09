// core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constants/api_constants.dart';
import '../errors/exceptions.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          seconds: ApiConstants.requestTimeoutSeconds,
        ),
        receiveTimeout: const Duration(
          seconds: ApiConstants.requestTimeoutSeconds,
        ),
        sendTimeout: const Duration(
          seconds: ApiConstants.requestTimeoutSeconds,
        ),
        headers: {
          'Accept': 'application/json',
          if (ApiConstants.demoApiKey.isNotEmpty)
            'x-cg-demo-api-key': ApiConstants.demoApiKey,
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(_LoggingInterceptor());
    }
    dio.interceptors.add(_ErrorInterceptor());
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await dio.get(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw _unwrap(e);
    }
  }

  Exception _unwrap(DioException e) {
    final inner = e.error;
    if (inner is ServerException ||
        inner is NetworkException ||
        inner is TimeoutException) {
      return inner as Exception;
    }
    return ServerException(e.message ?? 'Naməlum xəta');
  }
}

class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('➡️ [${options.method}] ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ [${response.statusCode}] ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ ${err.requestOptions.uri} -> ${err.message}');
    handler.next(err);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        handler.reject(_wrap(err, const TimeoutException()));
        return;
      case DioExceptionType.connectionError:
        handler.reject(_wrap(err, const NetworkException()));
        return;
      case DioExceptionType.badResponse:
        final code = err.response?.statusCode ?? 0;
        if (code == 429) {
          handler.reject(
            _wrap(
              err,
              const ServerException(
                'Çox tez-tez sorğu göndərildi (rate limit). Bir az gözlə.',
              ),
            ),
          );
          return;
        }
        handler.reject(_wrap(err, ServerException('Server xətası: $code')));
        return;
      default:
        handler.next(err);
    }
  }

  DioException _wrap(DioException original, Exception mapped) {
    return DioException(
      requestOptions: original.requestOptions,
      error: mapped,
      type: original.type,
      response: original.response,
    );
  }
}

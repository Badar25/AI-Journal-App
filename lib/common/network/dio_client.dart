import 'package:dio/dio.dart';

import 'api_config.dart';
import 'logger_interceptor.dart';

class DioClient {
  late final Dio _dio;
  static final String _bearerToken =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZGE2NGQzMjZmNzgyM2Q0NzJjMjhkMGIwNTUxMWM2MCIsIm5iZiI6MTczOTM0MDgzMC42MzMsInN1YiI6IjY3YWMzYzFlMDliODU1MWEwNGIwYzVkMyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.aR37iUx8t2pd0WUKhajOeG7mi5H5Bb1c4gBd6yawFmQ';

  DioClient()
      : _dio = Dio(
          BaseOptions(
              headers: ApiConfig.header,
              baseUrl: ApiConfig.baseUrl,
              responseType: ResponseType.json,
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10)),
        )..interceptors.addAll([LoggerInterceptor()]);

  // GET METHOD
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // POST METHOD
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // PUT METHOD
  Future<Response> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // DELETE METHOD
  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

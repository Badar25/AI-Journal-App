import 'package:ai_journal_app/core/api_urls.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'logger_interceptor.dart';

class DioClient {
  late final Dio _dio;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final int _maxRetries = 2; // Maximum number of retry attempts

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiURL.baseURL,
        responseType: ResponseType.json,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.addAll([
      LoggerInterceptor(),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _auth.currentUser?.getIdToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';

          }
          debugPrint('$token');
          // Add retry count to extra options if not present
          options.extra['retryCount'] ??= 0;
          return handler.next(options);
        },
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            final retryCount = (error.requestOptions.extra['retryCount'] as int? ?? 0);

            if (retryCount < _maxRetries) {
              try {
                // Refresh token
                final refreshedToken = await _refreshToken();
                if (refreshedToken != null) {
                  // Update headers with new token
                  error.requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
                  // Increment retry count
                  error.requestOptions.extra['retryCount'] = retryCount + 1;

                  // Retry the request
                  final opts = Options(
                    method: error.requestOptions.method,
                    headers: error.requestOptions.headers,
                  );

                  final cloneReq = await _dio.request(
                    error.requestOptions.path,
                    data: error.requestOptions.data,
                    queryParameters: error.requestOptions.queryParameters,
                    options: opts,
                  );

                  return handler.resolve(cloneReq);
                }
              } catch (e) {
                print('Token refresh failed: $e');
                return handler.next(error);
              }
            }
            // If max retries reached or token refresh failed
            print('Max retries reached or token refresh failed');
            return handler.next(error);
          }
          return handler.next(error);
        },
      ),
    ]);
  }

  Future<String?> _refreshToken() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final token = await user.getIdToken(true); // Force refresh
        print('Token refreshed successfully');
        return token;
      }
      print('No user found for token refresh');
      return null;
    } catch (e) {
      print('Token refresh failed: $e');
      return null;
    }
  }

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
  Future<Response> delete(
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
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
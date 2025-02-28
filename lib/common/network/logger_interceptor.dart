import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

/// This interceptor logs request and response details
class LoggerInterceptor extends Interceptor {
  final Logger logger = Logger(
    printer: PrettyPrinter(methodCount: 0, colors: true, printEmojis: true),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final requestPath = "${options.baseUrl}${options.path}";
    logger.i("${options.method} request ==> $requestPath");
    logger.i("HEADERS: ${options.headers}");
    if (options.data != null) {
      logger.i("BODY: ${options.data}");
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.d("RESPONSE STATUS: ${response.statusCode}");
    logger.d("RESPONSE HEADERS: ${response.headers}");
    logger.d("RESPONSE DATA: ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final requestPath = "${err.requestOptions.baseUrl}${err.requestOptions.path}";
    logger.e("${err.requestOptions.method} request ==> $requestPath");
    logger.e("Error type: ${err.type}, Message: ${err.message}");
    if (err.response != null) {
      logger.e("Response Status: ${err.response?.statusCode}");
      logger.e("Response Data: ${err.response?.data}");
    }
    handler.next(err);
  }
}

/// This interceptor handles authentication tokens
class ApiProviderTokenInterceptor extends Interceptor {
  final Dio dio;

  ApiProviderTokenInterceptor(this.dio);

  @override
  Future<void> onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler,
      ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final token = await user.getIdToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        debugPrint('$token');
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _refreshToken().then((newToken) {
        if (newToken != null) {
          err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          dio.fetch(err.requestOptions).then(
                (r) => handler.resolve(r),
            onError: (e) => handler.next(e),
          );
        } else {
          handler.next(err);
        }
      });
    } else {
      handler.next(err);
    }
  }

  Future<String?> _refreshToken() async {
    try {
      return await FirebaseAuth.instance.currentUser?.getIdToken(true);
    } catch (e) {
      return null;
    }
  }
}

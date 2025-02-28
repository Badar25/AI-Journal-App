import 'package:ai_journal_app/core/app_exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'dio_wrapper.dart';
import 'error_response_body.dart';

class DioHelper {
  /// Converts a Dio response to a [Result] type
  ///
  /// [map] is a function that converts the response data to the desired type
  static Future<Result<T>> toResult<T>(
    Future<Response> futureResponse,
    T Function(dynamic data) map,
  ) async {
    try {
      final response = await futureResponse;
      return Result.success(map(response.data));
    } catch (exception, stacktrace) {
      // Log the error and stacktrace for debugging
      debugPrint('API Error: ${exception.toString()} type: ${exception.runtimeType}');
      // debugPrint('Stacktrace: ${stacktrace.toString()}');

      String? message;

      if (exception is DioException) {
        // Handle different types of Dio exceptions
        switch (exception.type) {
          case DioExceptionType.connectionTimeout:
          case DioExceptionType.receiveTimeout:
          case DioExceptionType.sendTimeout:
          case DioExceptionType.connectionError:
            message = 'No internet connection';
            break;
          default:
            try {
              // Try to parse the error message from the response
              if (exception.response?.data != null) {
                message = APIResponse.fromJson(exception.response?.data).message;
              }
            } catch (_) {
              // If error parsing fails, use a default message
              message = 'Something went wrong';
            }
        }

        if (exception.response?.data["error"] != null) {
          message = exception.response?.data["error"];
        }
      }

      if(exception is CustomException) {
        message = exception.message;
      }

      return Result.failure(message ?? 'Something went wrong');
    }
  }
}

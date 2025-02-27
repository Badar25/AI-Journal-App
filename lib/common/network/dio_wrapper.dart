import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


/// A class representing the structure of success/failure results
/// for API operations.
class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  const Result._({
    this.data,
    this.error,
    required this.isSuccess,
  });

  factory Result.success(T data) => Result._(
    data: data,
    isSuccess: true,
  );

  factory Result.failure(String error) => Result._(
    error: error,
    isSuccess: false,
  );
}

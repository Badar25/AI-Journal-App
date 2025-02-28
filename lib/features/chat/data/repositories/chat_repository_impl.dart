import 'package:dio/dio.dart';

import '../../../../common/network/dio_client.dart';
import '../../../../common/network/dio_helper.dart';
import '../../../../common/network/dio_wrapper.dart';
import '../../../../common/network/error_response_body.dart';
import '../../../../core/api_urls.dart';
import '../../../../core/app_exceptions.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final DioClient dioClient;

  ChatRepositoryImpl({required this.dioClient});

  Future<Result<T>> _handleRequest<T>(Future<Response<dynamic>> futureResponse, T Function(dynamic body) onSuccess) async {
    final response = await DioHelper.toResult(
      futureResponse,
      (body) {
        final parsedResponse = APIResponse.fromJson(body);
        if (parsedResponse.success) {
          return onSuccess(parsedResponse.data);
        } else {
          throw CustomException(message: parsedResponse.message);
        }
      },
    );
    return response;
  }

  @override
  Future<Result<String>> sendMessage(String text) {
    return _handleRequest(
      dioClient.post(
        ApiURL.chat,
        data: {
          'message': text,
        },
      ),
      (data) {
        return data["response"];
      },
    );
  }
}

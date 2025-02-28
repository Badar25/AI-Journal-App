import '../../../../common/network/dio_wrapper.dart';

abstract class ChatRepository {
  Future<Result<String>> sendMessage(String text);
}
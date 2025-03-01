import 'package:ai_journal_app/common/usecase/usecase.dart';
import 'package:ai_journal_app/features/chat/domain/repositories/chat_repository.dart';

import '../../../../common/network/dio_wrapper.dart';

class SendMessageUseCase implements UseCase<String, SendMessageParam> {
  SendMessageUseCase(this._chatRepository);

  final ChatRepository _chatRepository;

  @override
  Future<Result<String>> call(SendMessageParam params) async {
    return await _chatRepository.sendMessage(params.message);
  }
}

class SendMessageParam {
  final String message;

  SendMessageParam({required this.message});
}

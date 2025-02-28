import 'package:ai_journal_app/common/network/dio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';

import '../../../../di.dart';
import '../../domain/usecases/send_message_usecase.dart';

class ChatResponse {
  final bool success;
  final String message;
  final ChatData? data;
  final String? error;

  ChatResponse({
    required this.success,
    required this.message,
    this.data,
    this.error,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? ChatData.fromJson(json['data']) : null,
      error: json['error'] as String?,
    );
  }
}

class ChatData {
  final String response;

  ChatData({required this.response});

  factory ChatData.fromJson(Map<String, dynamic> json) {
    return ChatData(
      response: json['response'] as String,
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'user-id');
  final _bot = const types.User(id: 'bot-id');
  final _dio = getIt<DioClient>();
  final TextEditingController _controller = TextEditingController();
  final sendMessageUseCase = getIt<SendMessageUseCase>();
  bool _isLoading = false; // Track loading state

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().toString(),
      text: text,
    );

    setState(() {
      _messages.insert(0, userMessage);
      _isLoading = true; // Show loading
    });

    try {
      final param = SendMessageParam(message: text);
      final response = await sendMessageUseCase.call(param);

      if (response.isSuccess) {
        final botMessage = types.TextMessage(
          author: _bot,
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: DateTime.now().toString(),
          text: response.data!,
        );

        setState(() {
          _messages.insert(0, botMessage);
        });
      } else {
        _showError(response.error ?? 'Unknown error');
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() {
        _isLoading = false; // Hide loading
      });
      _controller.clear();
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message', style: const TextStyle(color: Colors.white)),
        backgroundColor: CupertinoColors.destructiveRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CupertinoNavigationBar(middle: Text('Journal Chat')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Chat(
                    messages: _messages,
                    user: _user,
                    theme: const DefaultChatTheme(
                      primaryColor: Colors.black,
                      secondaryColor: CupertinoColors.quaternarySystemFill,
                      inputBackgroundColor: Colors.white,
                      backgroundColor: CupertinoColors.white,
                      sentMessageBodyTextStyle: TextStyle(color: Colors.white),
                      receivedMessageBodyTextStyle: TextStyle(color: Colors.black),
                    ),
                    customBottomWidget: Container(),
                    showUserAvatars: false,
                    emptyState: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.chat_bubble, size: 64, color: Colors.black),
                          const SizedBox(height: 16),
                          Text(
                           'Start conversation with me on your journal',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    onSendPressed: (PartialText) {},
                  ),
                  if (_isLoading)
                    Positioned(
                      bottom: 10,
                      left: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: CupertinoColors.quaternarySystemFill,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoActivityIndicator(color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Thinking...',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildCustomInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: CupertinoTextField(
              controller: _controller,
              placeholder: 'Type your message...',
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              style: const TextStyle(color: Colors.black),
              placeholderStyle: TextStyle(color: Colors.grey.shade500),
              onSubmitted: _sendMessage,
            ),
          ),
          const SizedBox(width: 8),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: const Icon(CupertinoIcons.paperplane_fill, color: Colors.black),
            onPressed: () => _sendMessage(_controller.text),
          ),
        ],
      ),
    );
  }
}

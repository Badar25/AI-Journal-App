import 'package:ai_journal_app/common/network/dio_client.dart';
import 'package:ai_journal_app/common/network/dio_helper.dart';
import 'package:ai_journal_app/common/network/dio_wrapper.dart';
import 'package:ai_journal_app/features/journals/data/models/journal.dart';
import 'package:ai_journal_app/features/journals/domain/repositories/journal_repository.dart';
import 'package:dio/dio.dart';

import '../../../../common/network/error_response_body.dart';
import '../../../../core/api_urls.dart';

class JournalRepositoryImpl implements JournalRepository {
  final DioClient dioClient;

  JournalRepositoryImpl({required this.dioClient});

  Future<Result<T>> _handleRequest<T>(
    Future<Response<dynamic>> futureResponse,
    T Function(dynamic body) onSuccess,
  ) async {
    final response = await DioHelper.toResult(
      futureResponse,
      (body) {
        final parsedResponse = APIResponse.fromJson(body);
        if (parsedResponse.success) {
          return onSuccess(parsedResponse.data);
        } else {
          throw Exception(parsedResponse.message);
        }
      },
    );
    return response;
  }

  @override
  Future<Result<Journal>> createJournal({String? title, String? content}) async {
    return _handleRequest(
      dioClient.post(
        ApiURL.createJournal,
        data: {
          'title': title,
          'content': content,
        },
      ),
      (data) {
        final id = data["id"];
        return Journal(
          id: id,
          title: title,
          content: content,
          date: DateTime.now(),
        );
      },
    );
  }

  @override
  Future<Result<bool>> deleteJournal(String id) async {
    return _handleRequest(
      dioClient.delete(ApiURL.deleteJournal(id)),
      (_) => true,
    );
  }

  @override
  Future<Result<Journal>> getJournal(String id) async {
    return _handleRequest(
      dioClient.get(ApiURL.getJournal(id)),
      (data) => Journal.fromJson(data),
    );
  }

  @override
  Future<Result<List<Journal>>> getJournals() async {
    return _handleRequest(
      dioClient.get(ApiURL.getJournals),
      (data) => (data as List).map((journal) => Journal.fromJson(journal)).toList(),
    );
  }

  @override
  Future<Result<bool>> updateJournal({required String id, String? title, String? content}) async {
    return _handleRequest(
      dioClient.put(
        ApiURL.updateJournal(id),
        data: {
          if (title != null) 'title': title,
          if (content != null) 'content': content,
        },
      ),
      (_) => true,
    );
  }
}

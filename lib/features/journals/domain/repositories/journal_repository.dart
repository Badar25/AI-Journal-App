import 'package:ai_journal_app/common/network/dio_wrapper.dart';

import '../../data/models/journal.dart';

abstract class JournalRepository {
  Future<Result<List<Journal>>> getJournals();

  Future<Result<Journal>> getJournal(String id);

  Future<Result<Journal>> createJournal({String? title, String? content});

  Future<Result<bool>> updateJournal({required String id, String? title, String? content});

  Future<Result<bool>> deleteJournal(String id);
}

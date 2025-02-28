import 'package:ai_journal_app/common/usecase/usecase.dart';

import '../../../../common/network/dio_wrapper.dart';
import '../../data/models/journal.dart';
import '../repositories/journal_repository.dart';

class SummarizeJournalsUseCase implements UseCase<String, dynamic> {
  SummarizeJournalsUseCase(this._journalRepository);

  final JournalRepository _journalRepository;

  @override
  Future<Result<String>> call([_]) async {
    return await _journalRepository.summarizeJournal();
  }
}
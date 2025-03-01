import 'package:ai_journal_app/common/usecase/usecase.dart';

import '../../../../common/network/dio_wrapper.dart';
import '../../data/models/journal.dart';
import '../repositories/journal_repository.dart';

class CreateJournalUseCase implements UseCase<Journal, CreateJournalParams> {
  CreateJournalUseCase(this._journalRepository);

  final JournalRepository _journalRepository;

  @override
  Future<Result<Journal>> call(CreateJournalParams params) async {
    return await _journalRepository.createJournal(
      title: params.title,
      content: params.content,
    );
  }
}

class CreateJournalParams {
  CreateJournalParams({required this.title, required this.content});

  final String title;
  final String content;
}

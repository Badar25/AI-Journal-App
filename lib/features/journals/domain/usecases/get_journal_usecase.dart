import 'package:ai_journal_app/common/usecase/usecase.dart';

import '../../../../common/network/dio_wrapper.dart';
import '../../data/models/journal.dart';
import '../repositories/journal_repository.dart';

class UpdateJournalUseCase implements UseCase<bool, UpdateJournalParams> {
  UpdateJournalUseCase(this._journalRepository);

  final JournalRepository _journalRepository;

  @override
  Future<Result<bool>> call(UpdateJournalParams params) async {
    return await _journalRepository.updateJournal(
      id: params.id,
      title: params.title,
      content: params.content,
    );
  }
}

class UpdateJournalParams {
  UpdateJournalParams({required this.title, required this.content, required this.id});

  final String id;
  final String title;
  final String content;
}

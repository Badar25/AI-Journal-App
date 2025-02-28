import 'package:ai_journal_app/common/usecase/usecase.dart';

import '../../../../common/network/dio_wrapper.dart';
import '../repositories/journal_repository.dart';

class DeleteJournalUseCase implements UseCase<bool, DeleteJournalParams> {
  DeleteJournalUseCase(this._journalRepository);

  final JournalRepository _journalRepository;

  @override
  Future<Result<bool>> call(DeleteJournalParams params) async {
    return await _journalRepository.deleteJournal(params.id);
  }
}

class DeleteJournalParams {
  DeleteJournalParams({required this.id});

  final String id;
}

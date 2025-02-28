import 'package:ai_journal_app/common/usecase/usecase.dart';

import '../../../../common/network/dio_wrapper.dart';
import '../../data/models/journal.dart';
import '../repositories/journal_repository.dart';

class GetJournalsUseCase implements UseCase<List<Journal>, dynamic> {
  GetJournalsUseCase(this._journalRepository);

  final JournalRepository _journalRepository;

  @override
  Future<Result<List<Journal>>> call([_]) async {
    return await _journalRepository.getJournals();
  }
}
import 'package:ai_journal_app/common/controllers/base_controller_wrapper.dart';
import 'package:ai_journal_app/features/journals/data/models/journal.dart';

import '../../domain/usecases/get_journal_usecase.dart';

class JournalDetailController extends BaseController {
  final Journal journal;
  final UpdateJournalUseCase updateUseCase;

  JournalDetailController(
    this.journal, {
    required this.updateUseCase,
  });
}

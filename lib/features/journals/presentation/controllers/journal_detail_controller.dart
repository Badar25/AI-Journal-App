import 'dart:ui';

import 'package:ai_journal_app/common/controllers/base_controller_wrapper.dart';
import 'package:ai_journal_app/features/journals/data/models/journal.dart';
import 'package:get/get.dart';

import '../../domain/usecases/delete_journal_usecase.dart';
import '../../domain/usecases/update_journal_usecase.dart';

class JournalDetailController extends BaseController {
  Journal journal;
  final UpdateJournalUseCase updateUseCase;
  final DeleteJournalUseCase deleteUseCase;

  JournalDetailController(this.journal, {required this.updateUseCase, required this.deleteUseCase});

  static JournalDetailController get to => Get.find<JournalDetailController>();

  bool isEditingMode = false;

  void toggleEditingMode() {
    isEditingMode = !isEditingMode;
    update();
  }

  void updateJournal({String? title, String? content, required VoidCallback onSuccess}) async {
    setLoading(true);
    journal = journal.copyWith(title: title, content: content);
    final params = UpdateJournalParams(
      id: journal.id,
      title: journal.title,
      content: journal.content,
    );
    final result = await updateUseCase.call(params);
    setLoading(false);
    if (result.isSuccess) {
      toggleEditingMode();
      onSuccess();
    } else {
      setErrorMessage(result.error);
    }
  }

  void deleteJournal(VoidCallback onSuccess) {
    setLoading(true);
    final params = DeleteJournalParams(id: journal.id);
    deleteUseCase.call(params).then((result) {
      setLoading(false);
      if (result.isSuccess) {
        onSuccess();
      } else {
        setErrorMessage(result.error);
      }
    });
  }
}
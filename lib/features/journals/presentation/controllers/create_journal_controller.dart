import 'dart:ui' show VoidCallback;

import 'package:ai_journal_app/features/journals/data/models/journal.dart';
import 'package:ai_journal_app/features/journals/domain/usecases/create_journal_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/controllers/base_controller_wrapper.dart';

class CreateJournalController extends BaseController {
  final CreateJournalUseCase _createJournalUseCase;

  CreateJournalController(this._createJournalUseCase);

  static CreateJournalController get to => Get.find<CreateJournalController>();
  Journal? newJournal;

  Future<void> createJournal(String title, String content, VoidCallback onSuccess) async {
    setLoading(true);
    try {
      final params = CreateJournalParams(title: title, content: content);
      final result = await _createJournalUseCase.call(params);

      if (result.isSuccess) {

        newJournal = result.data;
        onSuccess();
      } else {
        setErrorMessage(result.error);
      }
    } catch (_, st) {
      debugPrint(st.toString());
      setErrorMessage("Failed to create journal");
    } finally {
      setLoading(false);
    }
  }
}

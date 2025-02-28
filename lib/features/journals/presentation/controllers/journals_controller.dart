import 'package:ai_journal_app/common/controllers/base_controller_wrapper.dart';
import 'package:get/get.dart';

import '../../data/models/journal.dart';

class JournalsController extends BaseController {

  static JournalsController get to => Get.find<JournalsController>();

  List<Journal> journals = Journal.seedMultipleJournals();


  void addJournal(Journal journal) {
    journals.add(journal);
    update();
  }

}
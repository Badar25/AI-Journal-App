import 'package:ai_journal_app/common/controllers/base_controller_wrapper.dart';
import 'package:get/get.dart';

import '../../data/models/journal.dart';
import '../../domain/usecases/get_journals_usecase.dart';

class JournalsController extends BaseController {
  final GetJournalsUseCase getJournalsUseCase;

  JournalsController({required this.getJournalsUseCase});
  static JournalsController get to => Get.find<JournalsController>();

  List<Journal> journals = const [];

  @override
  void onInit() {
    getJournals();
    super.onInit();
  }

  void addJournal(Journal journal) {
    journals.add(journal);
    update();
  }

  void removeJournal(Journal journal) {
    journals.remove(journal);
    update();
  }

  void getJournals() async {
    setLoading(true);
    final result = await getJournalsUseCase.call();
    setLoading(false);
    if (result.isSuccess) {
      journals = result.data!;
    } else {
      setErrorMessage(result.error);
    }
  }

}
import 'package:ai_journal_app/di.dart';
import 'package:ai_journal_app/features/journals/data/models/journal.dart';
import 'package:flutter/cupertino.dart';
 import 'package:get/get.dart';

import '../controllers/journal_detail_controller.dart';
class JournalDetailView extends StatelessWidget {
  final Journal journal;
  const JournalDetailView({super.key, required this.journal});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(journal.title ?? '<No title>'),
      ),
      child: GetBuilder<JournalDetailController>(
        init: JournalDetailController(journal, updateUseCase: getIt()),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(controller.journal.title ?? controller.journal.content ?? '<No content>'),
          );
        }
      ),
    );
  }
}

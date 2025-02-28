import 'package:ai_journal_app/features/journals/presentation/controllers/journals_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'journal_detail_view.dart';

class JournalsView extends StatefulWidget {
  const JournalsView({super.key});

  @override
  State<JournalsView> createState() => _JournalsViewState();
}

class _JournalsViewState extends State<JournalsView> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<JournalsController>(builder: (controller) {
      return CupertinoPageScaffold(
        child: ListView.builder(
          itemCount: controller.journals.length,
          itemBuilder: (context, index) {
            final journal = controller.journals[index];
            return CupertinoListTile(
              onTap: () {
                /// push as root navigator
                Get.to(JournalDetailView(journal: journal));
              },
              title: Text(journal.title ?? '<No title>'),
              subtitle: Text(journal.content ?? '<No content>'),
            );
          },
        ),
      );
    });
  }
}

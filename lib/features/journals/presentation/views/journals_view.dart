import 'package:ai_journal_app/core/app_utils.dart';
import 'package:ai_journal_app/features/journals/presentation/controllers/journals_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/journal.dart';
import 'journal_detail_view.dart';

class JournalsView extends StatelessWidget {
  const JournalsView({super.key});

  void _onJournalTap(Journal journal) {
    Get.to(JournalDetailView(journal: journal));
  }

  void _onRefresh() {
    JournalsController.to.getJournals();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JournalsController>(
      builder: (controller) {
        return CupertinoPageScaffold(
          child: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Material(child: Text(controller.errorMessage!, style: const TextStyle(color: Colors.red))),
                          CupertinoButton(
                            child: const Text('Retry'),
                            onPressed: () => _onRefresh(),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => controller.getJournals(),
                      child: controller.journals.isEmpty
                          ? Center(child: Material(child: Text("No journals yet")))
                          : ListView.builder(
                              itemCount: controller.journals.length,
                              itemBuilder: (context, index) {
                                final journal = controller.journals[index];
                                bool hasTitle = journal.title?.isNotEmpty ?? false;
                                bool hasContent = journal.content?.isNotEmpty ?? false;

                                return CupertinoListTile(
                                  onTap: () => _onJournalTap(journal),
                                  title: Text(
                                    hasTitle ? (journal.title ?? "") : (journal.content ?? ''),
                                    style: TextStyle(
                                      fontWeight: hasTitle ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                  subtitle: hasTitle && hasContent
                                      ? Text(
                                          journal.content ?? "",
                                          style: const TextStyle(fontWeight: FontWeight.normal),
                                        )
                                      : null,
                                  trailing: Material(child: Text(timeAgoFormatter(journal.date) ?? "")),
                                );
                              },
                            ),
                    ),
        );
      },
    );
  }
}

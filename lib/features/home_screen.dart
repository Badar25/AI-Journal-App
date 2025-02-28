import 'package:ai_journal_app/features/chat/presentation/views/chat_screen.dart';
import 'package:ai_journal_app/features/journals/data/models/journal.dart';
import 'package:ai_journal_app/features/journals/presentation/views/create_journal_view.dart';
import 'package:ai_journal_app/features/journals/presentation/views/journals_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'journals/presentation/controllers/journals_controller.dart';
import 'journals/presentation/views/summarize_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _showAddJournalPopup(BuildContext context) async {
    final newJournal = await showCupertinoSheet<Journal?>(
      context: context,
      pageBuilder: (context) => CreateJournalView(),
    );

    if (newJournal != null) {
      debugPrint('New Journal: $newJournal');
      JournalsController.to.addJournal(newJournal);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar:   CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () => Get.to(() => SummarizeView()),
          child: Icon(CupertinoIcons.wand_rays, size: 20),
        ),
        middle: Text('AI Journal'),
        backgroundColor: CupertinoColors.inactiveGray,
        trailing: GestureDetector(
            onTap: ()=>Get.to(()=>ChatScreen()),
          child: Icon(
            CupertinoIcons.chat_bubble,
            size: 20,
          ),
        ),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            CupertinoTabScaffold(
              tabBar: CupertinoTabBar(
                height: 60,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.book),
                    label: 'Journals',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.settings),
                    label: 'Settings',
                  ),
                ],
              ),
              tabBuilder: (context, index) {
                return CupertinoTabView(
                  builder: (context) {
                    switch (index) {
                      case 0:
                        return JournalsView();
                      case 1:
                        return Text('Settings');
                      default:
                        return const Center(child: Text('Journals'));
                    }
                  },
                );
              },
            ),

            // Floating Action Button (FAB)
            Positioned(
              bottom: 30,
              left: MediaQuery.of(context).size.width / 2 - 28,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => _showAddJournalPopup(context),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: CupertinoColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    CupertinoIcons.add,
                    color: CupertinoColors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
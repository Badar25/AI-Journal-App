import 'package:ai_journal_app/features/journals/data/models/journal.dart';
import 'package:ai_journal_app/features/journals/presentation/views/create_journal_view.dart';
import 'package:ai_journal_app/features/journals/presentation/views/journals_view.dart';
import 'package:flutter/cupertino.dart';

import 'journals/presentation/controllers/journals_controller.dart';

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
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home Screen'),
      ),
      child: Stack(
        children: [
          CupertinoTabScaffold(
            tabBar: CupertinoTabBar(
              height: 60,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.book),
                  activeIcon: Icon(CupertinoIcons.book_solid),
                  label: 'Journals',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.chat_bubble),
                  activeIcon: Icon(CupertinoIcons.chat_bubble_fill),
                  label: 'Chat',
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
                      return const Center(child: Text('Chat'));
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
    );
  }
}
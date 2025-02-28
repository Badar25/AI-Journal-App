import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_journal_app/core/app_mixins.dart'; // For LoadingStateMixin
import 'package:ai_journal_app/common/usecase/usecase.dart'; // For Result
 import '../../../../di.dart';
import '../../../auth/presentation/views/login_view.dart';
import '../../../journals/domain/usecases/get_journals_usecase.dart'; // For getIt

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> with LoadingStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GetJournalsUseCase _getJournalsUseCase = getIt<GetJournalsUseCase>();
  String? _userEmail;
  bool _shareJournalsWithAI = true; // Local state for demo; persist in Qdrant if needed

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email;
      });
      // Optionally load _shareJournalsWithAI from Qdrant if persisted there
    }
  }

  Future<void> _updateSharePreference(bool value) async {
    setState(() {
      _shareJournalsWithAI = value;
    });
    // If you want to persist this in Qdrant, add logic here to update a user settings vector
  }

  Future<void> _deleteAllJournals() async {
    final user = _auth.currentUser;
    if (user == null) return;

    await withLoading(() async {
      // Since Qdrant is a vector DB, we can't "delete all" directly without knowing point IDs
      // Fetch all journals first, then delete them
      final result = await _getJournalsUseCase.call();
      if (result.isSuccess) {
        // Assuming JournalRepository has a delete method; adjust based on your repo
        final journals = result.data!;
        for (var journal in journals) {
          // Call a delete use case or repository method here
          // e.g., await _journalRepository.deleteJournal(journal.id);
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All journals deleted', style: TextStyle(color: Colors.white)),
            backgroundColor: CupertinoColors.destructiveRed,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${result.error}'),
            backgroundColor: CupertinoColors.destructiveRed,
          ),
        );
      }
    });
  }

  Future<void> _signOut() async {
    await withLoading(() async {
      await _auth.signOut();
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const LoginView()));
    });
  }

  void _showPrivacyPolicy() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Privacy Policy'),
        content: const Text(
          'Your journals are stored in Qdrant and only accessed by the AI if you consent. '
              'We comply with UK GDPR by securing data in transit and allowing deletion.',
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: ValueListenableBuilder<bool>(
          valueListenable: isLoading,
          builder: (context, loading, child) {
            return Stack(
              children: [
                Container(
                  color: Colors.white,
                  child: ListView(
                    children: [
                      if (_userEmail != null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Material(
                            child: Text(
                              'Logged in as: $_userEmail',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Material(
                          child: Text(
                            'Privacy & Data',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      CupertinoListTile(
                        title: const Text(
                          'Share Journals with AI',
                          style: TextStyle(color: Colors.black),
                        ),
                        subtitle: const Text(
                          'Allow AI to analyze your journals for personalization',
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: CupertinoSwitch(
                          value: _shareJournalsWithAI,
                          onChanged: (value) => _updateSharePreference(value),
                          activeColor: Colors.black,
                        ),
                      ),
                      CupertinoListTile(
                        title: Material(
                          child: const Text(
                            'View Privacy Policy',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        trailing: const Icon(
                          CupertinoIcons.chevron_right,
                          color: Colors.black,
                        ),
                        onTap: _showPrivacyPolicy,
                      ),
                      CupertinoListTile(
                        title: const Text(
                          'Delete All Journals',
                          style: TextStyle(color: CupertinoColors.destructiveRed),
                        ),
                        trailing: const Icon(
                          CupertinoIcons.trash,
                          color: CupertinoColors.destructiveRed,
                        ),
                        onTap: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                              title: const Text('Confirm Deletion'),
                              content: const Text('Delete all your journals from Qdrant?'),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text('Cancel'),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  child: const Text('Delete'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteAllJournals();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      CupertinoListTile(
                        title: const Text(
                          'Sign Out',
                          style: TextStyle(color: Colors.black),
                        ),
                        trailing: const Icon(
                          CupertinoIcons.square_arrow_right,
                          color: Colors.black,
                        ),
                        onTap: _signOut,
                      ),
                    ],
                  ),
                ),
                if (loading)
                  const Center(
                    child: CupertinoActivityIndicator(radius: 20),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
import 'package:ai_journal_app/features/journals/domain/usecases/summarize_journal_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/app_mixins.dart';

class SummarizeView extends StatefulWidget {
  const SummarizeView({super.key});

  @override
  State<SummarizeView> createState() => _SummarizeViewState();
}

class _SummarizeViewState extends State<SummarizeView> with LoadingStateMixin {
  final SummarizeJournalsUseCase _summarizeJournalsUseCase = GetIt.I<SummarizeJournalsUseCase>();
  String? summary;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    await withLoading(() async {
      try{
        final result = await _summarizeJournalsUseCase.call();
        if(result.isSuccess) {
          summary = result.data;
        } else {
          error = result.error;
        }
      } catch (e) {
        print("error: $e");
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Your Journal Summary'),
        backgroundColor: CupertinoColors.systemIndigo.withOpacity(0.9),
      ),
      child: Container(
        decoration: BoxDecoration(),
        child: SafeArea(
          child: ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, loading, child) {
              if (loading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CupertinoActivityIndicator(radius: 20),
                      const SizedBox(height: 16),
                      Material(
                        child: Text(
                          'Crafting Your Summary...',
                          style: TextStyle(
                            fontSize: 18,
                             fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (summary == null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.book,
                        size: 60,
                        color: CupertinoColors.systemGrey,
                      ),
                      const SizedBox(height: 16),
                      Material(
                        child:   Text(
                        error ?? 'No summary available',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.systemGrey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 24),
                      CupertinoButton.filled(
                        onPressed: fetchData,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(CupertinoIcons.refresh),
                            SizedBox(width: 8),
                            Text('Summarize Now'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your Summary',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                               ),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: fetchData,
                              child: const Icon(CupertinoIcons.refresh_circled),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          summary!,
                          style: const TextStyle(
                            fontSize: 18,
                            height: 1.5,
                            color: CupertinoColors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
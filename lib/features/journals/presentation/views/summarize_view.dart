import 'package:flutter/cupertino.dart';
 class SummarizeView extends StatelessWidget {
  const SummarizeView({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Summarize'),
        backgroundColor: CupertinoColors.inactiveGray,
      ),
      child: SafeArea(
        child: Center(
          child: Text('Summarize View'),
        ),
      ),
    );
  }
}

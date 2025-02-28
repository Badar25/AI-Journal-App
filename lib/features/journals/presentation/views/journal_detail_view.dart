import 'package:ai_journal_app/di.dart';
import 'package:ai_journal_app/features/journals/data/models/journal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../../common/widget/app_buttons.dart';
import '../../domain/usecases/delete_journal_usecase.dart';
import '../../domain/usecases/update_journal_usecase.dart';
import '../controllers/journal_detail_controller.dart';

class JournalDetailView extends StatefulWidget {
  final Journal journal;

  const JournalDetailView({super.key, required this.journal});

  @override
  State<JournalDetailView> createState() => _JournalDetailViewState();
}

class _JournalDetailViewState extends State<JournalDetailView> {
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _contentC = TextEditingController();
  final _formKey = GlobalKey<ShadFormState>();

  void _onSaveTap() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // Close keyboard
      JournalDetailController.to.updateJournal(
        title: _titleC.text,
        content: _contentC.text,
        onSuccess: () {},
      );
    }
  }

  void _onDeleteTap() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Delete Journal'),
          content: const Text('Are you sure you want to delete this journal?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              child: const Text('Delete'),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
                // JournalDetailController.to.deleteJournal(
                //   onSuccess: () {
                //     Navigator.pop(context);
                //   },
                // );
              },
              // onPressed: _deleteJournal,
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _titleC.text = widget.journal.title ?? '';
    _contentC.text = widget.journal.content ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<JournalDetailController>(
      init: JournalDetailController(
        widget.journal,
        updateUseCase: getIt<UpdateJournalUseCase>(),
        deleteUseCase: getIt<DeleteJournalUseCase>(),
      ),
      builder: (controller) {
        return Scaffold(
          appBar: CupertinoNavigationBar(
            leading: controller.isEditingMode
                ? AppTextButton(
                    text: 'Cancel',
                    isLoading: controller.isLoading,
                    takeFullWidth: false,
                    onPressed: controller.toggleEditingMode,
                  )
                : null,
            middle: Text(controller.isEditingMode ? 'Edit Journal' : '${widget.journal.title ?? 'Untitled'}'),
            trailing: controller.isEditingMode
                ? AppTextButton(
                    text: 'Done',
                    isLoading: controller.isLoading,
                    takeFullWidth: false,
                    onPressed: _onSaveTap,
                  )
                : AppTextButton(
                    text: 'Edit',
                    takeFullWidth: false,
                    isLoading: false,
                    onPressed: controller.toggleEditingMode,
                  ),
          ),
          body: SafeArea(
            bottom: false,
            minimum: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: controller.isEditingMode ? _buildEditForm(controller) : _buildViewMode(controller),
            ),
          ),
        );
      },
    );
  }

  Widget _buildViewMode(JournalDetailController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        SelectableText(
          widget.journal.title ?? 'Untitled',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        SelectableText(
          widget.journal.content ?? 'No content',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildEditForm(JournalDetailController controller) {
    return ShadForm(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          ShadInputFormField(
            id: 'title',
            controller: _titleC,
            label: const Text('Title'),
            placeholder: const Text('Add title'),
          ),
          const SizedBox(height: 20),
          ShadInputFormField(
            id: 'content',
            controller: _contentC,
            maxLines: 20,
            maxLength: 999,
            label: const Text('Content'),
            placeholder: const Text("What's on your mind?"),
            validator: (value) {
              if (value.isEmpty && _titleC.text.isEmpty) {
                return 'Either title or content is required';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          if (controller.errorMessage?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                controller.errorMessage!,
                style: const TextStyle(color: CupertinoColors.systemRed),
              ),
            ),
          ShadButton.destructive(
            width: double.infinity,
            onPressed: _onDeleteTap,
            child: const Text('Delete'),
          )
        ],
      ),
    );
  }
}
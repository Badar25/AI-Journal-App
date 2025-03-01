import 'package:ai_journal_app/common/widget/app_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../controllers/create_journal_controller.dart';

class CreateJournalView extends StatefulWidget {
  const CreateJournalView({super.key});

  @override
  State<CreateJournalView> createState() => _CreateJournalViewState();
}

class _CreateJournalViewState extends State<CreateJournalView> {
  final TextEditingController _titleC = TextEditingController();
  final TextEditingController _contentC = TextEditingController();
  final _formKey = GlobalKey<ShadFormState>();

  void _onCreateTap() {
    if (_formKey.currentState!.validate()) {
      /// close keyboard
      FocusScope.of(context).unfocus();
      CreateJournalController.to.createJournal(
        _titleC.text,
        _contentC.text,
        () {
          Navigator.pop(context, CreateJournalController.to.newJournal);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateJournalController>(builder: (controller) {
      return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: Text('Create Journal'),
          transitionBetweenRoutes: false,
          automaticBackgroundVisibility: false,
          trailing: AppTextButton(
            text: 'Done',
            isLoading: controller.isLoading,
            takeFullWidth: false,
            onPressed: _onCreateTap,
          ),
        ),
        body: SafeArea(
          bottom: false,
          minimum: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: ShadForm(
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
                    AppPrimaryButton(
                    text: 'Create',
                    isLoading: controller.isLoading,
                      takeFullWidth: false,
                      onPressed: _onCreateTap,
                  )
                ],
                ),
              ),
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _titleC.dispose();
    _contentC.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AppPrimaryButton({super.key, required this.text, required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ShadButton(
      width: double.infinity,
      onPressed: onPressed,
      leading: isLoading
          ? SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: ShadTheme.of(context).colorScheme.primaryForeground),
            )
          : null,
      child: Text(text),
    );
  }
}

class AppSecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const AppSecondaryButton({super.key, required this.text, required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ShadButton.secondary(
      width: double.infinity,
      onPressed: onPressed,
      leading: isLoading
          ? SizedBox.square(
              dimension: 16,
              child: CircularProgressIndicator(strokeWidth: 2, color: ShadTheme.of(context).colorScheme.primaryForeground),
            )
          : null,
      child: Text(text),
    );
  }
}

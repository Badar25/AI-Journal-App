import 'package:flutter/material.dart';

/// A mixin that provides loading state management for StatefulWidget.
/// Automatically handles showing/hiding loading state and proper disposal.
mixin LoadingStateMixin<T extends StatefulWidget> on State<T> {
  /// Notifies about the current loading state
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  /// Executes a callback while showing a loading state.
  /// Automatically handles setting loading to true before execution
  /// and false after completion, even if an error occurs.
  Future<void> withLoading(Future<void> Function() callback) async {
    isLoading.value = true;
    try {
      await callback();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    isLoading.dispose();
    super.dispose();
  }
}
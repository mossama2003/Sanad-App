import 'package:flutter/material.dart';

class AppThrottler {
  final int durationSeconds;
  DateTime _lastExecution = DateTime.fromMillisecondsSinceEpoch(0);

  AppThrottler({required this.durationSeconds});

  /// Executes [action] if the specified [durationSeconds] has passed since the last execution.
  /// Returns `true` if the action was executed, `false` otherwise.
   bool run(VoidCallback action) {
    final now = DateTime.now();
    if (now.difference(_lastExecution) > Duration(seconds: durationSeconds)) {
      _lastExecution = now;
      action();
      return true;
    } else {
      return false;
    }
  }
}

import 'dart:async';

import 'package:flutter/material.dart';

class AppDebouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? _timer;

  AppDebouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}

import 'package:flutter/material.dart';

class AppNavigator {
  AppNavigator._();

  static final key = GlobalKey<NavigatorState>();

  static BuildContext get context {
    if (key.currentContext == null) {
      throw Exception('Context is not available');
    }
    return key.currentContext!;
  }

  static Future<void> push(Widget screen) {
    if (key.currentState == null) return Future.value();
    return key.currentState!.push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void replace(Widget screen) async {
    await key.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static void remove(Widget screen) async {
    await key.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => screen),
      (route) => false,
    );
  }

  static void pop() => key.currentState?.pop();

  static void sheet(Widget sheet, {bool canClose = true}) {
    showModalBottomSheet(
      context: context,
      enableDrag: canClose,
      isDismissible: canClose,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: sheet,
      ),
    );
  }

  static void dialog(Widget dialog, {bool canClose = true}) {
    showDialog(
      context: context,
      barrierDismissible: canClose,
      builder: (_) => dialog,
    );
  }
}

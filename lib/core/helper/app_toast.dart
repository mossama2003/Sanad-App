import 'package:flutter/material.dart';

import '../constant/app_size.dart';
import 'app_navigator.dart';

class AppToast {
  static void error(String msg) {
    final ctx = AppNavigator.key.currentContext;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSize.font(14),
            fontWeight: FontWeight.w400,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void success(String msg) {
    final ctx = AppNavigator.key.currentContext;
    if (ctx == null) return;
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          msg,
          style: TextStyle(
            color: Colors.white,
            fontSize: AppSize.font(14),
            fontWeight: FontWeight.w400,
          ),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../constant/app_size.dart';
import '../style/app_colors.dart';
import 'app_navigator.dart';

class AppToast {
  static void error(String msg) {
    final overlay = AppNavigator.key.currentState?.overlay;
    if (overlay == null) return;

    showTopSnackBar(
      overlay,
      Material(
        color: Colors.transparent,
        child: Container(
          margin: AppSize.padding(horizontal: 16, vertical: 20),
          padding: AppSize.padding(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSize.font(14),
            ),
          ),
        ),
      ),
    );
  }

  static void success(String msg) {
    final overlay = AppNavigator.key.currentState?.overlay;
    if (overlay == null) return;

    showTopSnackBar(
      overlay,
      Material(
        color: Colors.transparent,
        child: Container(
          margin: AppSize.padding(horizontal: 16, vertical: 20),
          padding: AppSize.padding(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.green,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSize.font(14),
            ),
          ),
        ),
      ),
    );
  }

  static void info(String msg) {
    final overlay = AppNavigator.key.currentState?.overlay;
    if (overlay == null) return;

    showTopSnackBar(
      overlay,
      Material(
        color: Colors.transparent,
        child: Container(
          margin: AppSize.padding(horizontal: 16, vertical: 20),
          padding: AppSize.padding(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            msg,
            style: TextStyle(
              color: AppColors.white,
              fontSize: AppSize.font(14),
            ),
          ),
        ),
      ),
    );
  }
}

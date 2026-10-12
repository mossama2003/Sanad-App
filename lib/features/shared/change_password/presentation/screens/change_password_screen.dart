import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Text(
          'shared.settings.change_password'.tr(),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: const SafeArea(
        child: Center(child: Text('Change Password (placeholder)')),
      ),
    );
  }
}

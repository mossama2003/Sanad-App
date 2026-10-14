import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_size.dart';
import '../../data/repos/forgot_password_repo.dart';
import '../controllers/forgot_password_cubit.dart';
import '../forms/forgot_password_request_form.dart';

class ForgotPasswordRequestScreen extends StatelessWidget {
  const ForgotPasswordRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => ForgotPasswordCubit(ForgotPasswordRepoImpel()),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleSpacing: 0,
          title: Text(
            'shared.forgot_password.request_title'.tr(),
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppSize.font(18),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: const SafeArea(child: ForgotPasswordRequestForm()),
      ),
    );
  }
}

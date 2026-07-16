import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_size.dart';
import '../forms/organization_sign_up_form.dart';

class OrganizationSignUpScreen extends StatefulWidget {
  const OrganizationSignUpScreen({super.key});

  @override
  State<OrganizationSignUpScreen> createState() =>
      _OrganizationSignUpScreenState();
}

class _OrganizationSignUpScreenState extends State<OrganizationSignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: AppSize.padding(all: 30),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [OrganizationSignUpForm()],
            ),
          ),
        ),
      ),
    );
  }
}

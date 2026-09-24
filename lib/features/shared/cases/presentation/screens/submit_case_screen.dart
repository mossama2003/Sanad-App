import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constant/app_size.dart';
import '../../data/models/cases_model.dart';
import '../controllers/case_cubit.dart';
import '../forms/cases_form.dart';

class SubmitCaseScreen extends StatefulWidget {
  final CaseListItemModel? caseItem;
  final CasesCubit casesCubit;

  const SubmitCaseScreen({
    super.key,
    this.caseItem,
    required this.casesCubit,
  });

  bool get isEdit => caseItem != null;

  @override
  State<SubmitCaseScreen> createState() => _SubmitCaseScreenState();
}

class _SubmitCaseScreenState extends State<SubmitCaseScreen> {
  bool showForm = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => showForm = true);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);
    final closeBackgroundColor = textColor.withValues(alpha: .08);

    return BlocProvider.value(
      value: widget.casesCubit,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: AppSize.padding(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.isEdit
                                ? 'shared.cases.edit.title'.tr()
                                : 'shared.cases.submit.title'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(20),
                              fontWeight: FontWeight.w800,
                              color: textColor,
                            ),
                          ),
                          SizedBox(
                            height: AppSize.getHeight(4),
                          ),
                          Text(
                            widget.isEdit
                                ? 'shared.cases.edit.desc'.tr()
                                : 'shared.cases.submit.desc'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(13),
                              color: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => AppNavigator.pop(),
                      child: Container(
                        width: AppSize.getSize(36),
                        height: AppSize.getSize(36),
                        decoration: BoxDecoration(
                          color: closeBackgroundColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: CustomIcon(
                            icon: AppIcons.close,
                            color: textColor,
                            width: AppSize.getSize(25),
                            height: AppSize.getSize(25),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSlide(
                  offset: showForm
                      ? Offset.zero
                      : const Offset(0, 0.3),
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutCubic,
                  child: AnimatedOpacity(
                    opacity: showForm ? 1 : 0,
                    duration: const Duration(milliseconds: 400),
                    child: SingleChildScrollView(
                      padding: AppSize.padding(
                        horizontal: 16,
                        bottom: 24,
                      ),
                      child: CasesForm(
                        caseItem: widget.caseItem,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
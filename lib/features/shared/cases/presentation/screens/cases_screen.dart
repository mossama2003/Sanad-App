import 'package:sanad_app/features/shared/cases/presentation/screens/submit_case_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/helper/app_number_formatter.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/constant/app_size.dart';
import '../../data/models/cases_model.dart';
import '../../data/repos/cases_repo.dart';
import '../cards/verified_info_card.dart';
import '../controllers/case_cubit.dart';
import '../cards/cases_card.dart';

class CasesScreen extends StatefulWidget {
  const CasesScreen({super.key});

  @override
  State<CasesScreen> createState() => _CasesScreenState();
}

class _CasesScreenState extends State<CasesScreen> {
  late final CasesCubit casesCubit;
  late final bool isOrg;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    casesCubit = CasesCubit(CasesRepoImpel());

    final user = AppCubit.get(context).user;
    isOrg = user?.role == 'organization';
    currentUserId = user?.id;

    casesCubit.initCasesScreen(isOrg: isOrg);
  }

  @override
  void dispose() {
    casesCubit.close();
    super.dispose();
  }

  void _confirmDelete(int id) {
    AppNavigator.dialog(
      ConfirmDialog(
        title: 'shared.cases.card.confirm_delete_title'.tr(),
        message: 'shared.cases.card.confirm_delete_desc'.tr(),
        confirmText: 'shared.cases.card.delete'.tr(),
        isDestructive: true,
        onConfirm: () => casesCubit.deleteCase(id),
      ),
    );
  }

  Future<void> _editCase(CaseListItemModel caseItem) async {
    await AppNavigator.push(
      SubmitCaseScreen(caseItem: caseItem, casesCubit: casesCubit),
    );

    if (mounted) {
      await casesCubit.getCases(me: casesCubit.isMySelected);
    }
  }

  Future<void> openCreateCase(BuildContext context) async {
    await AppNavigator.push(SubmitCaseScreen(casesCubit: casesCubit));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .7);

    return BlocProvider.value(
      value: casesCubit,
      child: SingleChildScrollView(
        padding: AppSize.padding(
          horizontal: AppSize.getWidth(12),
          top: AppSize.getHeight(15),
          bottom: AppSize.getHeight(60),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'shared.cases.title'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(22),
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),

            SizedBox(height: AppSize.getHeight(3)),

            Text(
              'shared.cases.desc'.tr(),
              style: TextStyle(
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w300,
                color: secondaryColor,
              ),
            ),

            SizedBox(height: AppSize.getHeight(15)),

            if (isOrg) ...[
              BlocBuilder<CasesCubit, CasesState>(
                buildWhen: (previous, current) {
                  return current is Success ||
                      current is Loading ||
                      current is Error;
                },
                builder: (context, state) {
                  return CasesTabSelector(
                    isMySelected: casesCubit.isMySelected,
                    myCasesCount: casesCubit.myCasesCount,
                    onChanged: casesCubit.switchTab,
                  );
                },
              ),

              SizedBox(height: AppSize.getHeight(15)),
            ],

            const VerifiedInfoCard(),

            SizedBox(height: AppSize.getHeight(15)),

            BlocBuilder<CasesCubit, CasesState>(
              builder: (context, state) {
                if (state is Loading && casesCubit.casesList.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (casesCubit.casesList.isEmpty) {
                  return Center(
                    child: Text(
                      'shared.cases.no_cases'.tr(),
                      style: TextStyle(color: textColor),
                    ),
                  );
                }

                return Column(
                  children: [
                    for (int i = 0; i < casesCubit.casesList.length; i++) ...[
                      CasesCard(
                        caseItem: casesCubit.casesList[i],
                        isOwner:
                            isOrg &&
                            casesCubit.casesList[i].creator.id == currentUserId,
                        onDelete: () =>
                            _confirmDelete(casesCubit.casesList[i].id),
                        onEdit: () => _editCase(casesCubit.casesList[i]),
                      ),

                      if (i < casesCubit.casesList.length - 1)
                        SizedBox(height: AppSize.getHeight(15)),
                    ],
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CasesTabSelector extends StatelessWidget {
  final bool isMySelected;
  final int myCasesCount;
  final ValueChanged<bool> onChanged;

  const CasesTabSelector({
    super.key,
    required this.isMySelected,
    required this.myCasesCount,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final backgroundColor = textColor.withValues(alpha: .08);

    return Container(
      padding: AppSize.padding(all: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Expanded(
            child: _CasesTabItem(
              label: 'shared.cases.all_cases'.tr(),
              isSelected: !isMySelected,
              onTap: () => onChanged(false),
            ),
          ),
          Expanded(
            child: _CasesTabItem(
              label:
                  '${'shared.cases.my_cases'.tr()} (${myCasesCount.compact})',
              isSelected: isMySelected,
              onTap: () => onChanged(true),
            ),
          ),
        ],
      ),
    );
  }
}

class _CasesTabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CasesTabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.colorScheme.onSurface;

    final selectedColor = theme.cardColor;
    final unselectedColor = textColor.withValues(alpha: .6);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: AppSize.padding(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? .25 : .06),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: AppSize.font(13),
            fontWeight: FontWeight.w600,
            color: isSelected ? textColor : unselectedColor,
          ),
        ),
      ),
    );
  }
}

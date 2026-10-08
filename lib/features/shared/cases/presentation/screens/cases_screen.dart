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
import '../cards/verified_info_card.dart';
import '../controllers/case_cubit.dart';
import '../cards/cases_card.dart';

class CasesScreen extends StatelessWidget {
  final CasesCubit casesCubit;
  final bool isOrg;

  const CasesScreen({super.key, required this.casesCubit, required this.isOrg});

  // ============================================================
  // Create
  // ============================================================

  Future<void> _createCase(BuildContext context) async {
    await AppNavigator.push(
      BlocProvider.value(
        value: casesCubit,
        child: SubmitCaseScreen(casesCubit: casesCubit),
      ),
    );

    if (!context.mounted) return;

    // Refresh the currently selected tab after returning.
    await casesCubit.getCases(me: casesCubit.isMySelected);
  }

  // ============================================================
  // Delete
  // ============================================================

  void _confirmDelete(BuildContext context, int id) {
    AppNavigator.dialog(
      ConfirmDialog(
        title: 'shared.cases.card.confirm_delete_title'.tr(),
        message: 'shared.cases.card.confirm_delete_desc'.tr(),
        confirmText: 'shared.cases.card.delete'.tr(),
        isDestructive: true,
        onConfirm: () {
          casesCubit.deleteCase(id, context: context);
        },
      ),
    );
  }

  // ============================================================
  // Complete
  // ============================================================

  void _confirmComplete(BuildContext context, int id) {
    AppNavigator.dialog(
      ConfirmDialog(
        title: 'shared.cases.card.confirm_complete_title'.tr(),
        message: 'shared.cases.card.confirm_complete_desc'.tr(),
        confirmText: 'shared.cases.card.complete'.tr(),
        onConfirm: () {
          casesCubit.completeCase(id, context: context);
        },
      ),
    );
  }

  // ============================================================
  // Edit
  // ============================================================

  Future<void> _editCase(
    BuildContext context,
    CaseListItemModel caseItem,
  ) async {
    await AppNavigator.push(
      BlocProvider.value(
        value: casesCubit,
        child: SubmitCaseScreen(caseItem: caseItem, casesCubit: casesCubit),
      ),
    );

    if (!context.mounted) return;

    // Refresh after returning from edit.
    await casesCubit.getCases(me: casesCubit.isMySelected);
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textColor = theme.colorScheme.onSurface;

    final secondaryColor = textColor.withValues(alpha: .7);

    return SingleChildScrollView(
      padding: AppSize.padding(
        horizontal: AppSize.getWidth(12),
        top: AppSize.getHeight(15),
        bottom: AppSize.getHeight(60),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // Title
          // ============================================================

          Text(
            'shared.cases.title'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(22),
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),

          SizedBox(height: AppSize.getHeight(3)),

          // ============================================================
          // Description
          // ============================================================
          Text(
            'shared.cases.desc'.tr(),
            style: TextStyle(
              fontSize: AppSize.font(15),
              fontWeight: FontWeight.w300,
              color: secondaryColor,
            ),
          ),

          SizedBox(height: AppSize.getHeight(15)),

          // ============================================================
          // Content
          // ============================================================
          BlocBuilder<CasesCubit, CasesState>(
            bloc: casesCubit,
            builder: (context, state) {
              return Column(
                children: [
                  // ========================================================
                  // Tabs
                  // ========================================================

                  if (isOrg) ...[
                    CasesTabSelector(
                      isMySelected: casesCubit.isMySelected,
                      myCasesCount: casesCubit.myCasesCount,
                      onChanged: casesCubit.switchTab,
                    ),

                    SizedBox(height: AppSize.getHeight(15)),
                  ],

                  // ========================================================
                  // Verified Info
                  // ========================================================
                  const VerifiedInfoCard(),

                  SizedBox(height: AppSize.getHeight(15)),

                  // ========================================================
                  // Cases
                  // ========================================================
                  _buildCasesList(context, state, textColor),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Cases List
  // ============================================================

  Widget _buildCasesList(
    BuildContext context,
    CasesState state,
    Color textColor,
  ) {
    final cases = casesCubit.casesList;

    // ============================================================
    // Loading
    // ============================================================

    if (state is Loading && cases.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // ============================================================
    // Empty
    // ============================================================

    if (cases.isEmpty) {
      return Center(
        child: Text(
          'shared.cases.no_cases'.tr(),
          style: TextStyle(color: textColor),
        ),
      );
    }

    final currentUserId = AppCubit.get(context).user?.id;

    // ============================================================
    // List
    // ============================================================

    return Column(
      children: [
        for (int i = 0; i < cases.length; i++) ...[
          CasesCard(
            key: ValueKey(cases[i].id),

            caseItem: cases[i],

            // Use the same Cubit instance.
            casesCubit: casesCubit,

            isOwner: isOrg && cases[i].creator.id == currentUserId,

            // ========================================================
            // Delete
            // ========================================================
            onDelete: () {
              _confirmDelete(context, cases[i].id);
            },

            // ========================================================
            // Edit
            // ========================================================
            onEdit: () {
              _editCase(context, cases[i]);
            },

            // ========================================================
            // Complete
            // ========================================================
            onComplete: () {
              _confirmComplete(context, cases[i].id);
            },
          ),

          if (i < cases.length - 1) SizedBox(height: AppSize.getHeight(15)),
        ],
      ],
    );
  }
}

// ============================================================================
// Cases Tabs
// ============================================================================

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
          // ==========================================================
          // All Cases
          // ==========================================================

          Expanded(
            child: _CasesTabItem(
              label: 'shared.cases.all_cases'.tr(),
              isSelected: !isMySelected,
              onTap: () {
                onChanged(false);
              },
            ),
          ),

          // ==========================================================
          // My Cases
          // ==========================================================
          Expanded(
            child: _CasesTabItem(
              label:
                  '${'shared.cases.my_cases'.tr()} '
                  '(${myCasesCount.compact})',
              isSelected: isMySelected,
              onTap: () {
                onChanged(true);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Tab Item
// ============================================================================

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

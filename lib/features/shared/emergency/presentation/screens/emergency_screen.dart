import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../core/helper/app_number_formatter.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../data/models/emergency_model.dart';
import '../../data/repos/emergency_repo.dart';
import '../controllers/emergency_cubit.dart';
import '../dialogs/emergency_details_dialog.dart';
import '../forms/report_emergency_form.dart';
import '../cards/emergency_card.dart';

class EmergencyScreen extends StatefulWidget {
  final bool isOrg;

  const EmergencyScreen({super.key, required this.isOrg});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  late final EmergencyCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = EmergencyCubit(EmergencyRepoImpel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getEmergencies(me: false);

      if (widget.isOrg) {
        _cubit.getEmergencies(me: true);
      }
    });
  }

  // ============================================================
  // Report Emergency
  // ============================================================

  Future<void> _reportEmergency() async {
    await AppNavigator.push(
      BlocProvider.value(
        value: _cubit,
        child: OrganizationEmergencyForm(emergencyCubit: _cubit),
      ),
    );

    if (!mounted) return;

    await _cubit.getEmergencies(me: _cubit.isMySelected);
  }

  void _openDetails(EmergencyModel emergency) {
    AppNavigator.dialog(
      EmergencyDetailsDialog(
        emergency: emergency,
        emergencyCubit: _cubit,
        isOrg: widget.isOrg,
        currentUserId: AppCubit.get(context).user?.id,
      ),
    );
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,

        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: AppColors.red),
          titleSpacing: 0,
        ),

        body: SafeArea(
          child: RefreshIndicator(
            color: AppColors.red,
            onRefresh: _cubit.refresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: AppSize.padding(
                horizontal: AppSize.getWidth(12),
                bottom: AppSize.getHeight(30),
              ),
              child: BlocBuilder<EmergencyCubit, EmergencyState>(
                bloc: _cubit,
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // ==================================================
                      // Description
                      // ==================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIcon(
                            icon: AppIcons.siren,
                            color: AppColors.red,
                            width: AppSize.getWidth(24),
                            height: AppSize.getHeight(24),
                          ),
                          SizedBox(width: AppSize.getWidth(8)),
                          Text(
                            'shared.emergency.title'.tr(),
                            style: TextStyle(
                              fontSize: AppSize.font(18),
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSize.getHeight(10)),

                      Text(
                        'shared.emergency.desc'.tr(),
                        style: TextStyle(
                          fontSize: AppSize.font(15),
                          fontWeight: FontWeight.w300,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: .7,
                          ),
                        ),
                      ),

                      SizedBox(height: AppSize.getHeight(15)),

                      // ==================================================
                      // Report Emergency
                      // Organization Only
                      // ==================================================
                      if (widget.isOrg) ...[
                        CustomButton(
                          onTap: _reportEmergency,
                          title: 'shared.emergency.button'.tr(),
                          bgColor: AppColors.red,
                          icon: AppIcons.add,
                          height: AppSize.getHeight(50),
                        ),

                        SizedBox(height: AppSize.getHeight(20)),

                        // ==================================================
                        // Tabs
                        // ==================================================
                        EmergencyTabSelector(
                          isMySelected: _cubit.isMySelected,
                          myEmergenciesCount: _cubit.myEmergenciesCount,
                          onChanged: _cubit.switchTab,
                        ),

                        SizedBox(height: AppSize.getHeight(15)),
                      ],

                      // ==================================================
                      // Emergencies
                      // ==================================================
                      _buildEmergenciesList(context, state),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Emergency List
  // ============================================================

  Widget _buildEmergenciesList(BuildContext context, EmergencyState state) {
    final list = widget.isOrg && _cubit.isMySelected
        ? _cubit.myEmergencies
        : _cubit.emergencies;

    // ============================================================
    // Loading
    // ============================================================

    if (state is EmergencyLoading && list.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // ============================================================
    // Empty
    // ============================================================

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSize.padding(vertical: 40),
          child: Text(
            'shared.emergency.no_emergencies'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: AppSize.font(14),
            ),
          ),
        ),
      );
    }

    // ============================================================
    // Cards
    // ============================================================

    return Column(
      children: [
        for (int i = 0; i < list.length; i++) ...[
          EmergencyCard(emergency: list[i], onTap: () => _openDetails(list[i])),
          if (i < list.length - 1) SizedBox(height: AppSize.getHeight(15)),
        ],
      ],
    );
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }
}

class EmergencyTabSelector extends StatelessWidget {
  final bool isMySelected;
  final int myEmergenciesCount;
  final ValueChanged<bool> onChanged;

  const EmergencyTabSelector({
    super.key,
    required this.isMySelected,
    required this.myEmergenciesCount,
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
          // All Emergencies
          // ==========================================================

          Expanded(
            child: _EmergencyTabItem(
              label: 'shared.emergency.all'.tr(),
              isSelected: !isMySelected,
              onTap: () {
                onChanged(false);
              },
            ),
          ),

          // ==========================================================
          // My Emergencies
          // ==========================================================
          Expanded(
            child: _EmergencyTabItem(
              label:
                  '${'shared.emergency.my'.tr()} '
                  '(${myEmergenciesCount.compact})',
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

class _EmergencyTabItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _EmergencyTabItem({
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
          textAlign: TextAlign.center,
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

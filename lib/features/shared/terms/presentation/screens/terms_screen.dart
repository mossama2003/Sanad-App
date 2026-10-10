import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_search_field.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/repos/terms_repo.dart';
import '../controllers/terms_cubit.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TermsCubit(TermsRepoImpel())..fetchTerms(),
      child: const _TermsAndConditionsView(),
    );
  }
}

class _TermsAndConditionsView extends StatefulWidget {
  const _TermsAndConditionsView();

  @override
  State<_TermsAndConditionsView> createState() =>
      _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<_TermsAndConditionsView> {
  late final TermsCubit _cubit;
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _cubit = TermsCubit.get(context);
    _scrollController = ScrollController()..addListener(_handleScroll);
  }

  void _handleScroll() {
    if (!_scrollController.hasClients) return;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _cubit.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'shared.terms.title'.tr(),
          style: TextStyle(
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search and filters
            Padding(
              padding: AppSize.padding(horizontal: 12, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchField(
                    controller: _cubit.searchController,
                    hint: 'shared.terms.search_hint'.tr(),
                    borderColor: AppColors.grey300,
                    borderRadius: 20,
                    borderWidth: 1,
                    onChanged: _cubit.onSearchChanged,
                  ),
                  SizedBox(height: AppSize.getHeight(14)),
                  SizedBox(
                    height: 42,
                    child: BlocBuilder<TermsCubit, TermsState>(
                      bloc: _cubit,
                      builder: (context, state) {
                        final selectedType = _cubit.selectedTermType;

                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildTypeChip(
                              context,
                              label: 'shared.terms.all'.tr(),
                              selected: selectedType == null,
                              onTap: () => _cubit.filterByType(null),
                            ),
                            ...TermsCubit.termTypes.map(
                              (type) => _buildTypeChip(
                                context,
                                label: 'shared.terms.types.$type'.tr(),
                                selected: selectedType == type,
                                onTap: () => _cubit.filterByType(type),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Terms list
            Expanded(
              child: BlocBuilder<TermsCubit, TermsState>(
                bloc: _cubit,
                builder: (context, state) {
                  if (state is TermsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TermsError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 42,
                              color: colors.error,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _cubit.refresh,
                              child: Text('shared.terms.retry'.tr()),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (state is! TermsLoaded) {
                    return const SizedBox.shrink();
                  }

                  if (state.terms.isEmpty) {
                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: _cubit.refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        children: [
                          SizedBox(
                            height: AppSize.getHeight(200),
                            child: Center(
                              child: Text(
                                'shared.terms.empty'.tr(),
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: colors.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: _cubit.refresh,
                    child: ListView.separated(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: AppSize.padding(horizontal: 12, vertical: 8),
                      itemCount:
                          state.terms.length + (state.next != null ? 1 : 0),
                      separatorBuilder: (_, _) =>
                          SizedBox(height: AppSize.getHeight(12)),
                      itemBuilder: (context, index) {
                        // Load more
                        if (index == state.terms.length) {
                          return Padding(
                            padding: AppSize.padding(vertical: 16),
                            child: Center(
                              child: state.isLoadingMore
                                  ? const CircularProgressIndicator()
                                  : TextButton(
                                      onPressed: _cubit.loadMore,
                                      child: Text(
                                        'shared.terms.load_more'.tr(),
                                      ),
                                    ),
                            ),
                          );
                        }

                        final term = state.terms[index];

                        return Container(
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.5),
                            ),
                          ),
                          child: ExpansionTile(
                            key: PageStorageKey('term_${term.id}'),
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            childrenPadding: const EdgeInsets.fromLTRB(
                              16,
                              0,
                              16,
                              18,
                            ),
                            leading: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.gavel_rounded,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(
                              term.title,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                'shared.terms.types.${term.termType}'.tr(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colors.onSurface.withValues(
                                    alpha: 0.6,
                                  ),
                                ),
                              ),
                            ),
                            children: [
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: SelectableText(
                                  term.description,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    height: 1.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeChip(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        labelStyle: TextStyle(
          color: selected ? AppColors.primary : colors.onSurface,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
        ),
        side: BorderSide(
          color: selected ? AppColors.primary : colors.outlineVariant,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}

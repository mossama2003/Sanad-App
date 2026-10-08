import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/shared/widgets/custom_search_field.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/models/faq_model.dart';
import '../../data/repos/faq_repo.dart';
import '../controllers/faq_cubit.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({super.key});

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  late FaqCubit _cubit;

  @override
  void initState() {
    super.initState();

    _cubit = FaqCubit(FaqRepoImpel());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getFaqs();
    });
  }

  @override
  void dispose() {
    _cubit.close();

    super.dispose();
  }

  Widget _searchField() {
    return CustomSearchField(
      controller: _cubit.searchController,
      hint: 'shared.faq.search_hint'.tr(),
      borderColor: AppColors.grey300,
      borderRadius: 20,
      borderWidth: 1,
      onChanged: _cubit.onSearchChanged,
    );
  }

  Widget _faqCard(FAQModel faq, int index) {
    final theme = Theme.of(context);

    final isExpanded = _cubit.expandedIndex == index;

    return Container(
      margin: AppSize.margin(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(AppSize.getSize(14)),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: .07),
        ),
      ),
      child: Theme(
        data: theme.copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (value) {
            if (value) {
              _cubit.toggleFaq(index);
            } else if (_cubit.expandedIndex == index) {
              _cubit.toggleFaq(index);
            }
          },
          tilePadding: AppSize.padding(horizontal: 15, vertical: 2),
          childrenPadding: AppSize.padding(horizontal: 15, bottom: 15),
          iconColor: theme.colorScheme.primary,
          collapsedIconColor: theme.colorScheme.onSurface.withValues(alpha: .5),
          title: Text(
            faq.question,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppSize.font(14),
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          children: [
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                faq.answer,
                style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: .6),
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w400,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    final theme = Theme.of(context);

    return Padding(
      padding: AppSize.padding(horizontal: 20, vertical: 60),
      child: Center(
        child: Column(
          children: [
            Icon(
              Icons.help_outline_rounded,
              size: AppSize.getSize(50),
              color: theme.colorScheme.onSurface.withValues(alpha: .25),
            ),

            SizedBox(height: AppSize.getHeight(15)),

            Text(
              'shared.faq.no_results'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppSize.font(15),
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: AppSize.getHeight(6)),

            Text(
              'shared.faq.no_results_desc'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: .5),
                fontSize: AppSize.font(13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactSupport() {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: AppSize.padding(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: .07),
        borderRadius: BorderRadius.circular(AppSize.getSize(15)),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: .1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: AppSize.getSize(42),
            height: AppSize.getSize(42),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIcon(
                icon: AppIcons.contactSupport,
                color: theme.colorScheme.primary,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
            ),
          ),

          SizedBox(width: AppSize.getWidth(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'shared.faq.still_need_help'.tr(),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: AppSize.font(14),
                    fontWeight: FontWeight.w600,
                  ),
                ),

                SizedBox(height: AppSize.getHeight(4)),

                Text(
                  'shared.faq.contact_support_desc'.tr(),
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: .5),
                    fontSize: AppSize.font(12),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: AppSize.getWidth(5)),

          InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              // AppNavigator.push(const ContactSupportScreen());
            },
            child: Padding(
              padding: AppSize.padding(horizontal: 5, vertical: 8),
              child: CustomIcon(
                icon: AppIcons.rightArrow,
                color: theme.colorScheme.primary,
                width: AppSize.getSize(20),
                height: AppSize.getSize(20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: AppSize.padding(horizontal: 25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: AppColors.red,
              size: AppSize.getSize(50),
            ),

            SizedBox(height: AppSize.getHeight(12)),

            Text(
              'shared.faq.error'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppSize.font(14),
              ),
            ),

            SizedBox(height: AppSize.getHeight(15)),

            TextButton(
              onPressed: () {
                _cubit.getFaqs(page: 1, search: _cubit.search);
              },
              child: Text(
                'shared.common.retry'.tr(),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: AppSize.font(13),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

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
          titleSpacing: 0,
          title: Text(
            'shared.faq.title'.tr(),
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: AppSize.font(18),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: SafeArea(
          child: BlocBuilder<FaqCubit, FaqState>(
            bloc: _cubit,
            builder: (context, state) {
              if (state is FaqLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is FaqError) {
                return _errorState();
              }

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async {
                  await _cubit.refreshFaqs();
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: AppSize.padding(horizontal: 12, top: 15, bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _searchField(),

                      SizedBox(height: AppSize.getHeight(20)),

                      if (_cubit.faqs.isEmpty)
                        _emptyState()
                      else
                        ...List.generate(
                          _cubit.faqs.length,
                          (index) => _faqCard(_cubit.faqs[index], index),
                        ),

                      SizedBox(height: AppSize.getHeight(10)),

                      _contactSupport(),

                      SizedBox(height: AppSize.getHeight(20)),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

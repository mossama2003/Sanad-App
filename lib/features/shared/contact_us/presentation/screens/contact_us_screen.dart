import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_dropdown.dart';

import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../../core/validator/app_validators.dart';
import '../../data/repos/contact_us_repo.dart';
import '../controllers/contact_us_cubit.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ContactUsCubit(ContactUsRepoImpel()),
      child: const _ContactUsView(),
    );
  }
}

class _ContactUsView extends StatefulWidget {
  const _ContactUsView();

  @override
  State<_ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<_ContactUsView> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return BlocConsumer<ContactUsCubit, ContactUsState>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = ContactUsCubit.get(context);
        final isLoading = state is ContactUsLoading;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,

          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            titleSpacing: 0,
            title: Text(
              'shared.contact_us.title'.tr(),
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: AppSize.font(18),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
              key: cubit.formKey,
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(context),

                    SizedBox(height: AppSize.getHeight(28)),

                    // Form title
                    Text(
                      'shared.contact_us.form_title'.tr(),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(6)),
                    Text(
                      'shared.contact_us.form_description'.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurface.withValues(alpha: 0.6),
                      ),
                    ),

                    SizedBox(height: AppSize.getHeight(22)),

                    // Name
                    CustomFieldText(
                      title: 'shared.contact_us.name'.tr(),
                      hintText: 'shared.contact_us.name_hint'.tr(),
                      controller: cubit.nameController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.name,
                      isRequired: true,
                      borderRadius: 15,
                      padding: AppSize.padding(horizontal: 16, vertical: 17),
                      validator: cubit.validateRequired,
                    ),

                    SizedBox(height: AppSize.getHeight(20)),

                    // Email
                    CustomFieldText(
                      title: 'shared.contact_us.email'.tr(),
                      hintText: 'shared.contact_us.email_hint'.tr(),
                      controller: cubit.emailController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.emailAddress,
                      isRequired: true,
                      borderRadius: 15,
                      padding: AppSize.padding(horizontal: 16, vertical: 17),
                      validator: cubit.validateEmail,
                    ),

                    SizedBox(height: AppSize.getHeight(20)),

                    // Phone
                    CustomFieldText(
                      controller: cubit.phoneController,
                      title: 'shared.contact_us.phone'.tr(),
                      hintText: '1xxxxxxxxx',
                      enabled: !isLoading,
                      isRequired: true,
                      titleSize: AppSize.font(15),
                      borderRadius: 20,
                      keyboardType: TextInputType.phone,
                      prefixText: '+20 ',
                      validator: AppValidators.egyptianPhoneWithoutZero,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.deny(RegExp(r'^0')),
                      ],
                    ),

                    SizedBox(height: AppSize.getHeight(20)),

                    // Category
                    Text(
                      'shared.contact_us.category'.tr(),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: AppSize.getHeight(9)),

                    CustomFieldDropdown<String>(
                      title: 'shared.contact_us.category'.tr(),
                      hintText: 'shared.contact_us.category_hint'.tr(),
                      selected: cubit.selectedCategory,
                      enabled: !isLoading,
                      isRequired: true,
                      borderRadius: 15,
                      items: ContactUsCubit.categories.map((category) {
                        return DropdownItem<String>(
                          value: category,
                          child: Text(
                            'shared.contact_us.categories.$category'.tr(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'shared.contact_us.validation.required'.tr();
                        }
                        return null;
                      },
                      onChanged: cubit.changeCategory,
                    ),

                    SizedBox(height: AppSize.getHeight(20)),

                    // Message
                    CustomFieldText(
                      title: 'shared.contact_us.message'.tr(),
                      hintText: 'shared.contact_us.message_hint'.tr(),
                      controller: cubit.messageController,
                      enabled: !isLoading,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 8,
                      isRequired: true,
                      borderRadius: 15,
                      padding: AppSize.padding(horizontal: 16, vertical: 17),
                      validator: cubit.validateRequired,
                    ),

                    SizedBox(height: AppSize.getHeight(28)),

                    // Submit button
                    CustomButton(
                      title: isLoading
                          ? 'shared.contact_us.sending'.tr()
                          : 'shared.contact_us.send'.tr(),
                      height: AppSize.getHeight(40),
                      loading: isLoading,
                      enable: !isLoading,
                      bgColor: AppColors.primary,
                      textColor: Colors.white,
                      textSize: 16,
                      onTap: cubit.submitContactUs,
                    ),

                    SizedBox(height: AppSize.getHeight(12)),

                    // Cancel button
                    CustomButton(
                      title: 'shared.contact_us.cancel'.tr(),
                      height: AppSize.getHeight(40),
                      enable: !isLoading,
                      bgColor: Colors.transparent,
                      textColor: colors.onSurface,
                      borderColor: theme.dividerColor,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),

                    SizedBox(height: AppSize.getHeight(20)),

                    // Privacy note
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          size: AppSize.getSize(15),
                          color: colors.onSurface.withValues(alpha: 0.5),
                        ),
                        SizedBox(width: AppSize.getWidth(6)),
                        Flexible(
                          child: Text(
                            'shared.contact_us.privacy_note'.tr(),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colors.onSurface.withValues(alpha: 0.55),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSize.getSize(54),
            height: AppSize.getSize(54),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.support_agent_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          SizedBox(height: AppSize.getHeight(16)),
          Text(
            'shared.contact_us.heading'.tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: AppSize.getHeight(8)),
          Text(
            'shared.contact_us.description'.tr(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

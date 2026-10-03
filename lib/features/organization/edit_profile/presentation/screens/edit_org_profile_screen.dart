import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/shared/widgets/custom_field_phone.dart';
import '../../../../shared/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../../../../core/shared/widgets/custom_field_dropdown.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../data/repos/edit_org_profile_repo.dart';
import '../../../../../core/constant/app_assets.dart';
import '../controllers/edit_org_profile_cubit.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';

class EditOrgProfileScreen extends StatefulWidget {
  const EditOrgProfileScreen({super.key});

  @override
  State<EditOrgProfileScreen> createState() => _EditOrgProfileScreenState();
}

class _EditOrgProfileScreenState extends State<EditOrgProfileScreen> {
  late final EditOrgProfileCubit editProfileCubit;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    editProfileCubit = EditOrgProfileCubit(EditOrgProfileRepoImpel());

    final user = AppCubit.get(context).user;

    editProfileCubit.initialize(user);
  }

  String? _validateSocialUsername(
    String? value, {
    required String platformName,
  }) {
    final username = value?.trim() ?? '';

    if (username.isEmpty) {
      return null;
    }

    if (username.contains(' ') ||
        username.contains('/') ||
        username.contains('://')) {
      return 'Please enter a valid $platformName username';
    }

    return null;
  }

  String? _validateFacebookUsername(String? value) {
    return _validateSocialUsername(value, platformName: 'Facebook');
  }

  String? _validateTwitterUsername(String? value) {
    return _validateSocialUsername(value, platformName: 'Twitter / X');
  }

  String? _validateInstagramUsername(String? value) {
    return _validateSocialUsername(value, platformName: 'Instagram');
  }

  String? _validateLinkedInUsername(String? value) {
    return _validateSocialUsername(value, platformName: 'LinkedIn');
  }

  void _submit() {
    editProfileCubit.submit(context: context, formKey: _formKey);
  }

  Widget _sectionTitle(BuildContext context, String text) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;

    return Padding(
      padding: AppSize.padding(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSize.font(13),
          fontWeight: FontWeight.w600,
          color: textColor.withValues(alpha: .6),
        ),
      ),
    );
  }

  Widget _whiteCard({
    required BuildContext context,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? .2 : .05),
            blurRadius: 6,
          ),
        ],
        border: Border.all(
          color: textColor.withValues(alpha: isDark ? .08 : .04),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = textColor.withValues(alpha: .6);
    final backgroundColor = theme.scaffoldBackgroundColor;

    return BlocProvider.value(
      value: editProfileCubit,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => AppNavigator.pop(),
            icon: Icon(Icons.arrow_back, color: textColor),
          ),
          title: Text(
            'organization.edit_profile.title'.tr(),
            style: TextStyle(
              color: textColor,
              fontSize: AppSize.font(18),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: AppSize.padding(horizontal: 16, bottom: 24),
              child: BlocBuilder<EditOrgProfileCubit, EditOrgProfileState>(
                builder: (context, state) {
                  final cubit = EditOrgProfileCubit.get(context);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: AppSize.getHeight(10)),
                      _whiteCard(
                        context: context,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  cubit.newLogo != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: Image.file(
                                            cubit.newLogo!,
                                            width: AppSize.getWidth(50),
                                            height: AppSize.getWidth(50),
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : cubit.existingLogoUrl != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          child: CachedNetworkImage(
                                            imageUrl: cubit.existingLogoUrl!,
                                            width: AppSize.getWidth(50),
                                            height: AppSize.getWidth(50),
                                            fit: BoxFit.cover,
                                            errorWidget:
                                                (context, url, error) =>
                                                    _logoPlaceholder(context),
                                          ),
                                        )
                                      : _logoPlaceholder(context),

                                  if (cubit.newLogo != null ||
                                      (cubit.existingLogoUrl != null &&
                                          !cubit.logoRemoved))
                                    Positioned(
                                      top: -4,
                                      right: -4,
                                      child: GestureDetector(
                                        onTap: cubit.removeLogo,
                                        child: Container(
                                          padding: const EdgeInsets.all(3),
                                          decoration: const BoxDecoration(
                                            color: Colors.black54,
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: AppSize.getSize(12),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              SizedBox(width: AppSize.getWidth(12)),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'organization.edit_profile.logo_cover'
                                          .tr(),
                                      style: TextStyle(
                                        fontSize: AppSize.font(15),
                                        fontWeight: FontWeight.w700,
                                        color: textColor,
                                      ),
                                    ),
                                    SizedBox(height: AppSize.getHeight(3)),
                                    Text(
                                      'organization.edit_profile.represent_org'
                                          .tr(),
                                      style: TextStyle(
                                        fontSize: AppSize.font(12),
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: AppSize.getWidth(80),
                                child: CustomButton(
                                  height: AppSize.getHeight(32),
                                  title: 'organization.edit_profile.logo'.tr(),
                                  bgColor: Colors.transparent,
                                  borderColor: AppColors.primary,
                                  textColor: AppColors.primary,
                                  textSize: AppSize.font(12),
                                  onTap: cubit.pickLogo,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(20)),
                      _sectionTitle(
                        context,
                        'organization.edit_profile.org_information'.tr(),
                      ),
                      _whiteCard(
                        context: context,
                        children: [
                          CustomFieldText(
                            controller: cubit.orgNameController,
                            title: 'organization.edit_profile.org_name'.tr(),
                            hintText: '',
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                          ),
                          SizedBox(height: AppSize.getHeight(15)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CustomFieldDropdown<String>(
                                  title: 'organization.edit_profile.type'.tr(),
                                  hintText: '',
                                  selected: cubit.selectedType,
                                  items: cubit.organizationTypes,
                                  onChanged: cubit.selectOrganizationType,
                                ),
                              ),
                              SizedBox(width: AppSize.getWidth(10)),
                              Expanded(
                                child: CustomFieldText(
                                  controller: cubit.registrationNoController,
                                  title:
                                      'organization.edit_profile.registration_no'
                                          .tr(),
                                  hintText: '',
                                  titleSize: AppSize.font(13),
                                  borderRadius: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: AppSize.getHeight(15)),
                          CustomFieldText(
                            controller: cubit.aboutController,
                            title: 'organization.edit_profile.about'.tr(),
                            hintText: '',
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                            minLines: 3,
                            maxLines: 3,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(20)),
                      _sectionTitle(
                        context,
                        'organization.edit_profile.contact_information'.tr(),
                      ),
                      _whiteCard(
                        context: context,
                        children: [
                          CustomFieldText(
                            controller: cubit.emailController,
                            title: 'organization.edit_profile.email'.tr(),
                            hintText: '',
                            keyboardType: TextInputType.emailAddress,
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                          ),
                          SizedBox(height: AppSize.getHeight(15)),
                          CustomFieldPhone(
                            controller: cubit.phoneController,
                            titleSize: AppSize.font(13),
                            titleColor: textColor,
                            title: 'organization.edit_profile.phone'.tr(),
                            hintText: 'organization.edit_profile.phone'.tr(),
                            initialCountryCode: 'EG',
                            onPhoneChanged: cubit.onPhoneChanged,
                            onCountryChanged: cubit.onCountryChanged,
                          ),
                          SizedBox(height: AppSize.getHeight(15)),
                          CustomFieldText(
                            controller: cubit.websiteController,
                            title: 'organization.edit_profile.website'.tr(),
                            hintText: '',
                            keyboardType: TextInputType.url,
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(20)),
                      _sectionTitle(
                        context,
                        'organization.edit_profile.location'.tr(),
                      ),
                      _whiteCard(
                        context: context,
                        children: [
                          CustomFieldDropdown<String>(
                            title: 'organization.edit_profile.governorate'.tr(),
                            hintText: '',
                            selected: cubit.selectedGovernorate,
                            items: cubit.governorates,
                            onChanged: cubit.selectGovernorate,
                          ),
                          SizedBox(height: AppSize.getHeight(15)),
                          CustomFieldText(
                            controller: cubit.addressController,
                            title: 'organization.edit_profile.address'.tr(),
                            hintText: '',
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(20)),
                      _sectionTitle(
                        context,
                        'organization.edit_profile.social_media'.tr(),
                      ),
                      _whiteCard(
                        context: context,
                        children: [
                          CustomFieldText(
                            controller: cubit.facebookController,
                            title: 'organization.edit_profile.facebook'.tr(),
                            hintText: 'Username',
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                            keyboardType: TextInputType.text,
                            validator: _validateFacebookUsername,
                          ),
                          SizedBox(height: AppSize.getHeight(15)),
                          CustomFieldText(
                            controller: cubit.twitterController,
                            title: 'organization.edit_profile.twitter'.tr(),
                            hintText: 'Username',
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                            keyboardType: TextInputType.text,
                            validator: _validateTwitterUsername,
                          ),
                          SizedBox(height: AppSize.getHeight(15)),
                          CustomFieldText(
                            controller: cubit.instagramController,
                            title: 'organization.edit_profile.instagram'.tr(),
                            hintText: 'Username',
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                            keyboardType: TextInputType.text,
                            validator: _validateInstagramUsername,
                          ),
                          SizedBox(height: AppSize.getHeight(15)),
                          CustomFieldText(
                            controller: cubit.linkedinController,
                            title: 'organization.edit_profile.linkedin'.tr(),
                            hintText: 'Username',
                            titleSize: AppSize.font(13),
                            borderRadius: 14,
                            keyboardType: TextInputType.text,
                            validator: _validateLinkedInUsername,
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(20)),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              onTap: () => AppNavigator.pop(),
                              title: 'organization.edit_profile.cancel'.tr(),
                              bgColor: Colors.transparent,
                              borderColor: AppColors.primary,
                              textColor: AppColors.primary,
                              height: AppSize.getHeight(45),
                            ),
                          ),
                          SizedBox(width: AppSize.getWidth(10)),
                          Expanded(
                            child: CustomButton(
                              title: 'organization.edit_profile.save_changes'
                                  .tr(),
                              loading: state is Loading,
                              bgColor: cubit.hasChanges
                                  ? AppColors.primary
                                  : AppColors.primary.withValues(alpha: .35),
                              textColor: cubit.hasChanges
                                  ? AppColors.white
                                  : AppColors.white.withValues(alpha: .6),
                              height: AppSize.getHeight(45),
                              onTap: cubit.hasChanges && state is! Loading
                                  ? _submit
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(12)),
                      CustomButton(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => ConfirmDialog(
                              title: 'organization.edit_profile.delete_org'
                                  .tr(),
                              message:
                                  'organization.edit_profile.delete_org_desc'
                                      .tr(),
                              confirmText: 'core.delete'.tr(),
                              isDestructive: true,
                              onConfirm: () async {
                                await AppCubit.get(context).deleteAccount();

                                if (!context.mounted) {
                                  return;
                                }

                                AppNavigator.remove(const SignInScreen());
                              },
                            ),
                          );
                        },
                        title: 'organization.edit_profile.delete_org'.tr(),
                        icon: AppIcons.delete,
                        iconSize: AppSize.getSize(17),
                        textColor: AppColors.red,
                        textSize: AppSize.font(14),
                        bgColor: AppColors.red.withValues(alpha: .08),
                        borderColor: Colors.transparent,
                        height: AppSize.getHeight(45),
                      ),
                      SizedBox(height: AppSize.getHeight(16)),
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

  Widget _logoPlaceholder(BuildContext context) {
    return Container(
      width: AppSize.getWidth(50),
      height: AppSize.getWidth(50),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: CustomIcon(
          icon: AppIcons.organization,
          color: AppColors.white,
          width: AppSize.getSize(26),
          height: AppSize.getSize(26),
        ),
      ),
    );
  }

  @override
  void dispose() {
    editProfileCubit.close();
    super.dispose();
  }
}

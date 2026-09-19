import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/helper/app_navigator.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_button.dart';
import '../../../../../core/shared/widgets/custom_field_dropdown.dart';
import '../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';
import '../../../../shared/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../data/params/update_org_profile_param.dart';
import '../../data/repos/edit_org_profile_repo.dart';
import '../controllers/edit_org_profile_cubit.dart';

class EditOrgProfileScreen extends StatefulWidget {
  const EditOrgProfileScreen({super.key});

  @override
  State<EditOrgProfileScreen> createState() =>
      _EditOrganizationProfileScreenState();
}

class _EditOrganizationProfileScreenState extends State<EditOrgProfileScreen> {
  late final EditOrgProfileCubit editProfileCubit;

  File? newLogo;
  String? existingLogoUrl;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController registrationNoController =
      TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  final TextEditingController governorateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final TextEditingController facebookController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();

  final ValueNotifier<String?> selectedType = ValueNotifier(null);
  final ValueNotifier<String?> selectedGovernorate = ValueNotifier(null);

  final List<DropdownItem<String>> organizationTypes = [
    DropdownItem(value: 'Non-Profit', child: Text('Non-Profit')),
    DropdownItem(value: 'NGO', child: Text('NGO')),
    DropdownItem(value: 'Charity', child: Text('Charity')),
    DropdownItem(value: 'Foundation', child: Text('Foundation')),
    DropdownItem(value: 'Community Group', child: Text('Community Group')),
  ];

  final List<DropdownItem<String>> governorates = [
    'Cairo',
    'Giza',
    'Alexandria',
    'Qalyubia',
    'Sharqia',
    'Dakahlia',
    'Beheira',
    'Minya',
    'Assiut',
    'Aswan',
    'Luxor',
  ].map((g) => DropdownItem(value: g, child: Text(g))).toList();

  @override
  void initState() {
    super.initState();
    editProfileCubit = EditOrgProfileCubit(EditOrgProfileRepoImpel());
    _fillFromCurrentUser();
  }

  void _fillFromCurrentUser() {
    final user = AppCubit.get(context).user;

    if (user == null) return;

    orgNameController.text = user.name ?? '';
    emailController.text = user.email ?? '';
    phoneController.text = user.phone ?? '';
    existingLogoUrl = user.avatar;

    final org = user.profile as OrganizationProfileModel?;

    if (org != null) {
      websiteController.text = org.website ?? '';
      governorateController.text = org.state ?? '';

      if (org.state != null && org.state!.isNotEmpty) {
        final exists = governorates.any((item) => item.value == org.state);
        if (!exists) {
          governorates.add(
            DropdownItem(value: org.state!, child: Text(org.state!)),
          );
        }
      }

      selectedGovernorate.value = org.state;

      addressController.text = org.headquarters ?? '';
      aboutController.text = org.bio ?? '';

      selectedType.value = (org.organizationType?.isNotEmpty ?? false)
          ? org.organizationType
          : null;

      if (selectedType.value != null) {
        final typeExists = organizationTypes.any(
          (item) => item.value == selectedType.value,
        );
        if (!typeExists) {
          organizationTypes.add(
            DropdownItem(
              value: selectedType.value!,
              child: Text(selectedType.value!),
            ),
          );
        }
      }

      registrationNoController.text = org.registerationNo ?? '';

      facebookController.text = org.socialMediaLinks?['facebook'] ?? '';
      twitterController.text = org.socialMediaLinks?['twitter'] ?? '';
      instagramController.text = org.socialMediaLinks?['instagram'] ?? '';
      linkedinController.text = org.socialMediaLinks?['linkedin'] ?? '';
    }
  }

  Future<void> _pickLogo() async {
    final file = await FilePicker.pickFile(type: FileType.image);

    if (file != null && file.path != null) {
      setState(() => newLogo = File(file.path!));
    }
  }

  String? _validateSocialUrl(
    String? value, {
    required List<String> allowedHosts,
    required String platformName,
  }) {
    final url = value?.trim() ?? '';

    if (url.isEmpty) {
      return null;
    }

    final uri = Uri.tryParse(url);

    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return 'Please enter a valid $platformName URL';
    }

    final host = uri.host.toLowerCase();

    final isValidHost = allowedHosts.any(
      (allowedHost) => host == allowedHost || host.endsWith('.$allowedHost'),
    );

    if (!isValidHost) {
      return 'Please enter a valid $platformName URL';
    }

    return null;
  }

  String? _validateFacebookUrl(String? value) {
    return _validateSocialUrl(
      value,
      allowedHosts: ['facebook.com', 'fb.com'],
      platformName: 'Facebook',
    );
  }

  String? _validateTwitterUrl(String? value) {
    return _validateSocialUrl(
      value,
      allowedHosts: ['twitter.com', 'x.com'],
      platformName: 'Twitter / X',
    );
  }

  String? _validateInstagramUrl(String? value) {
    return _validateSocialUrl(
      value,
      allowedHosts: ['instagram.com'],
      platformName: 'Instagram',
    );
  }

  String? _validateLinkedInUrl(String? value) {
    return _validateSocialUrl(
      value,
      allowedHosts: ['linkedin.com'],
      platformName: 'LinkedIn',
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final accountParam = UpdateOrgAccountParam(
      email: emailController.text.trim(),
      lastName: orgNameController.text.trim(),
      phone: phoneController.text.trim(),
      avatar: newLogo,
    );

    final orgParam = UpdateOrgProfileParam(
      website: websiteController.text.trim().isEmpty
          ? null
          : websiteController.text.trim(),
      state: selectedGovernorate.value,
      city: cityController.text.trim().isEmpty
          ? null
          : cityController.text.trim(),
      headquarters: addressController.text.trim().isEmpty
          ? null
          : addressController.text.trim(),
      bio: aboutController.text.trim().isEmpty
          ? null
          : aboutController.text.trim(),
      organizationType: selectedType.value,
      registerationNo: registrationNoController.text.trim().isEmpty
          ? null
          : registrationNoController.text.trim(),
      facebook: facebookController.text.trim().isEmpty
          ? null
          : facebookController.text.trim(),
      twitter: twitterController.text.trim().isEmpty
          ? null
          : twitterController.text.trim(),
      instagram: instagramController.text.trim().isEmpty
          ? null
          : instagramController.text.trim(),
      linkedin: linkedinController.text.trim().isEmpty
          ? null
          : linkedinController.text.trim(),
    );

    editProfileCubit.saveOrgProfile(
      context: context,
      accountParam: accountParam,
      organizationParam: orgParam,
    );
  }

  @override
  void dispose() {
    editProfileCubit.close();

    orgNameController.dispose();
    registrationNoController.dispose();
    aboutController.dispose();

    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();

    governorateController.dispose();
    cityController.dispose();
    addressController.dispose();

    facebookController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    linkedinController.dispose();

    selectedType.dispose();
    selectedGovernorate.dispose();

    super.dispose();
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: AppSize.padding(bottom: 10),
      child: Text(
        text,
        style: TextStyle(
          fontSize: AppSize.font(13),
          fontWeight: FontWeight.w600,
          color: AppColors.grey600,
        ),
      ),
    );
  }

  Widget _whiteCard({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: AppSize.padding(all: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: editProfileCubit,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F8FA),
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            onPressed: () => AppNavigator.pop(),
            icon: Icon(Icons.arrow_back, color: AppColors.black),
          ),
          title: Text(
            'organization.edit_profile.title'.tr(),
            style: TextStyle(
              color: AppColors.black,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSize.getHeight(10)),

                  // ================= Logo & Cover =================
                  _whiteCard(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          newLogo != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.file(
                                    newLogo!,
                                    width: AppSize.getWidth(50),
                                    height: AppSize.getWidth(50),
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : existingLogoUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: existingLogoUrl!,
                                    width: AppSize.getWidth(50),
                                    height: AppSize.getWidth(50),
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) =>
                                        _logoPlaceholder(),
                                  ),
                                )
                              : _logoPlaceholder(),

                          SizedBox(width: AppSize.getWidth(12)),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'organization.edit_profile.logo_cover'.tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(15),
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.black,
                                  ),
                                ),
                                SizedBox(height: AppSize.getHeight(3)),
                                Text(
                                  'organization.edit_profile.represent_org'
                                      .tr(),
                                  style: TextStyle(
                                    fontSize: AppSize.font(12),
                                    color: AppColors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            children: [
                              SizedBox(
                                width: AppSize.getWidth(80),
                                child: CustomButton(
                                  height: AppSize.getHeight(32),
                                  title: 'organization.edit_profile.logo'.tr(),
                                  bgColor: Colors.transparent,
                                  borderColor: AppColors.primary,
                                  textColor: AppColors.primary,
                                  textSize: AppSize.font(12),
                                  onTap: _pickLogo,
                                ),
                              ),
                              // SizedBox(height: AppSize.getHeight(8)),
                              // SizedBox(
                              //   width: AppSize.getWidth(80),
                              //   child: CustomButton(
                              //     height: AppSize.getHeight(32),
                              //     title: 'organization.edit_profile.cover'.tr(),
                              //     bgColor: Colors.transparent,
                              //     borderColor: AppColors.primary,
                              //     textColor: AppColors.primary,
                              //     textSize: AppSize.font(12),
                              //     onTap: _pickLogo,
                              //   ),
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(20)),

                  // ================= Organization Information =================
                  _sectionTitle(
                    'organization.edit_profile.org_information'.tr(),
                  ),
                  _whiteCard(
                    children: [
                      CustomFieldText(
                        controller: orgNameController,
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
                              selected: selectedType,
                              items: organizationTypes,
                              onChanged: (_) {},
                            ),
                          ),
                          SizedBox(width: AppSize.getWidth(10)),
                          Expanded(
                            child: CustomFieldText(
                              controller: registrationNoController,
                              title: 'organization.edit_profile.registration_no'
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
                        controller: aboutController,
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

                  // ================= Contact Information =================
                  _sectionTitle(
                    'organization.edit_profile.contact_information'.tr(),
                  ),
                  _whiteCard(
                    children: [
                      CustomFieldText(
                        controller: emailController,
                        title: 'organization.edit_profile.email'.tr(),
                        hintText: '',
                        keyboardType: TextInputType.emailAddress,
                        titleSize: AppSize.font(13),
                        borderRadius: 14,
                      ),
                      SizedBox(height: AppSize.getHeight(15)),
                      CustomFieldText(
                        controller: phoneController,
                        title: 'organization.edit_profile.phone'.tr(),
                        hintText: '',
                        keyboardType: TextInputType.phone,
                        titleSize: AppSize.font(13),
                        borderRadius: 14,
                      ),
                      SizedBox(height: AppSize.getHeight(15)),
                      CustomFieldText(
                        controller: websiteController,
                        title: 'organization.edit_profile.website'.tr(),
                        hintText: '',
                        keyboardType: TextInputType.url,
                        titleSize: AppSize.font(13),
                        borderRadius: 14,
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(20)),

                  // ================= Location =================
                  _sectionTitle('organization.edit_profile.location'.tr()),
                  _whiteCard(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: CustomFieldDropdown<String>(
                              title: 'organization.edit_profile.governorate'
                                  .tr(),
                              hintText: '',
                              selected: selectedGovernorate,
                              items: governorates,
                              onChanged: (_) {},
                            ),
                          ),
                          SizedBox(width: AppSize.getWidth(10)),
                          Expanded(
                            child: CustomFieldText(
                              controller: cityController,
                              title: 'organization.edit_profile.city'.tr(),
                              hintText: '',
                              titleSize: AppSize.font(13),
                              borderRadius: 14,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSize.getHeight(15)),
                      CustomFieldText(
                        controller: addressController,
                        title: 'organization.edit_profile.address'.tr(),
                        hintText: '',
                        titleSize: AppSize.font(13),
                        borderRadius: 14,
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(20)),

                  // ================= Social Media =================
                  _sectionTitle('organization.edit_profile.social_media'.tr()),
                  _whiteCard(
                    children: [
                      CustomFieldText(
                        controller: facebookController,
                        title: 'organization.edit_profile.facebook'.tr(),
                        hintText: 'https://facebook.com/...',
                        titleSize: AppSize.font(13),
                        borderRadius: 14,
                        keyboardType: TextInputType.url,
                        validator: _validateFacebookUrl,
                      ),

                      SizedBox(height: AppSize.getHeight(15)),

                      CustomFieldText(
                        controller: twitterController,
                        title: 'organization.edit_profile.twitter'.tr(),
                        hintText: 'https://x.com/...',
                        titleSize: AppSize.font(13),
                        borderRadius: 14,
                        keyboardType: TextInputType.url,
                        validator: _validateTwitterUrl,
                      ),

                      SizedBox(height: AppSize.getHeight(15)),

                      CustomFieldText(
                        controller: instagramController,
                        title: 'organization.edit_profile.instagram'.tr(),
                        hintText: 'https://instagram.com/...',
                        titleSize: AppSize.font(13),
                        borderRadius: 14,
                        keyboardType: TextInputType.url,
                        validator: _validateInstagramUrl,
                      ),

                      SizedBox(height: AppSize.getHeight(15)),

                      CustomFieldText(
                        controller: linkedinController,
                        title: 'organization.edit_profile.linkedin'.tr(),
                        hintText: 'https://linkedin.com/in/...',
                        titleSize: AppSize.font(13),
                        borderRadius: 14,
                        keyboardType: TextInputType.url,
                        validator: _validateLinkedInUrl,
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(20)),

                  // ================= Actions =================
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
                        child:
                            BlocBuilder<
                              EditOrgProfileCubit,
                              EditOrgProfileState
                            >(
                              builder: (context, state) {
                                return CustomButton(
                                  title:
                                      'organization.edit_profile.save_changes'
                                          .tr(),
                                  bgColor: AppColors.primary,
                                  textColor: AppColors.white,
                                  height: AppSize.getHeight(45),
                                  loading: state is Loading,
                                  onTap: state is Loading ? null : _submit,
                                );
                              },
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
                          title: 'organization.edit_profile.delete_org'.tr(),
                          message: 'organization.edit_profile.delete_org_desc'
                              .tr(),
                          confirmText: 'core.delete'.tr(),
                          isDestructive: true,
                          onConfirm: () async {
                            await AppCubit.get(context).deleteAccount();

                            if (!context.mounted) return;

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
                    bgColor: AppColors.red.withValues(alpha: 0.08),
                    borderColor: Colors.transparent,
                    height: AppSize.getHeight(45),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoPlaceholder() {
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
}

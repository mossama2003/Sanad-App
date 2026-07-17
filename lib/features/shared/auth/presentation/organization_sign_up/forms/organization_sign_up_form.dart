import 'package:sanad_app/core/shared/widgets/custom_upload_file.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_phone.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/helper/app_toast.dart';
import '../../../../../../core/shared/widgets/custom_field_dropdown.dart';
import '../../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/validator/app_validators.dart';
import '../../../data/models/governorate_model.dart';
import '../../../data/repos/organization/organization_repo.dart';
import '../controllers/organization_sign_up_cubit.dart';

class OrganizationSignUpForm extends StatefulWidget {
  const OrganizationSignUpForm({super.key});

  @override
  State<OrganizationSignUpForm> createState() => _OrganizationSignUpFormState();
}

class _OrganizationSignUpFormState extends State<OrganizationSignUpForm> {
  late OrganizationSignUpCubit _cubit;

  bool showIcon = false;
  bool showTexts = false;
  bool showButtons = false;
  bool showField = false;
  bool acceptTerms = false;

  @override
  void initState() {
    super.initState();

    _cubit = OrganizationSignUpCubit(OrganizationRepoImpel());
    _cubit.loadLocationData();

    _startAnimations();
  }

  void _startAnimations() {
    showIcon = false;
    showTexts = false;
    showButtons = false;
    showField = false;

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          showIcon = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          showTexts = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          showButtons = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          showField = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _cubit.nameController.dispose();
    _cubit.emailController.dispose();
    _cubit.phoneController.dispose();
    _cubit.websiteController.dispose();
    _cubit.headquartersController.dispose();
    _cubit.addressController.dispose();
    _cubit.passwordController.dispose();
    _cubit.confirmPasswordController.dispose();

    _cubit.close();

    super.dispose();
  }

  void _onSignUp() {
    if (!acceptTerms) {
      AppToast.error('organization.sign_up.you_must_accept_terms'.tr());
      return;
    }

    _cubit.signUp();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final secondaryText =
        theme.textTheme.bodySmall?.color ?? AppColors.textSecondary;

    return BlocBuilder<OrganizationSignUpCubit, OrganizationSignUpState>(
      bloc: _cubit,
      builder: (context, state) {
        return AnimatedSlide(
          offset: showField ? Offset.zero : const Offset(0, .5),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          child: AnimatedOpacity(
            opacity: showField ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: Form(
              key: _cubit.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        AnimatedSlide(
                          offset: showIcon ? Offset.zero : const Offset(0, .5),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: showIcon ? 1 : 0,
                            duration: const Duration(milliseconds: 400),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                GestureDetector(
                                  onTap: _cubit.avatar == null
                                      ? () => _cubit.pickLogo()
                                      : null,
                                  child: Container(
                                    padding: AppSize.padding(all: 10),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: AppColors.grey100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.laserBlue,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: _cubit.avatar != null
                                        ? Image.file(
                                            height: AppSize.getSize(65),
                                            width: AppSize.getSize(75),
                                            _cubit.avatar!,
                                            fit: BoxFit.cover,
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              CustomIcon(
                                                icon: AppIcons.addPhoto,
                                                color: AppColors.laserBlue,
                                                width: AppSize.getSize(36),
                                                height: AppSize.getSize(36),
                                              ),
                                              SizedBox(
                                                height: AppSize.getSize(6),
                                              ),
                                              Text(
                                                'organization.sign_up.upload_logo'
                                                    .tr(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: AppSize.font(12),
                                                  color: AppColors.laserBlue,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),

                                if (_cubit.avatar != null)
                                  Positioned(
                                    top: -6,
                                    right: -6,
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        _cubit.removeLogo();
                                      },
                                      child: Container(
                                        width: AppSize.getSize(22),
                                        height: AppSize.getSize(22),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 2,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: AppSize.getSize(15),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: AppSize.getHeight(15)),

                        AnimatedSlide(
                          offset: showTexts ? Offset.zero : const Offset(0, .5),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          child: AnimatedOpacity(
                            opacity: showTexts ? 1 : 0,
                            duration: const Duration(milliseconds: 400),
                            child: Column(
                              children: [
                                Text(
                                  'organization.sign_up.title'.tr(),
                                  style: TextStyle(
                                    color: AppColors.laserBlue,
                                    fontSize: AppSize.font(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppSize.getHeight(5)),
                                Text(
                                  'organization.sign_up.desc'.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: secondaryText,
                                    fontSize: AppSize.font(15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(25)),

                  CustomFieldText(
                    controller: _cubit.nameController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'organization.sign_up.organization_name'.tr(),
                    hintText: 'organization.sign_up.hint_organization_name'
                        .tr(),
                    validator: AppValidators.required,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.websiteController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'organization.sign_up.website_link'.tr(),
                    hintText: 'organization.sign_up.hint_website_link'.tr(),
                    validator: AppValidators.url,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.emailController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'organization.sign_up.official_email'.tr(),
                    hintText: 'organization.sign_up.hint_official_email'.tr(),
                    validator: AppValidators.email,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldPhone(
                    controller: _cubit.phoneController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'volunteer.sign_up.phone_number'.tr(),
                    hintText: '123 456 7890',
                    initialCountryCode: "EG",
                    onPhoneChanged: _cubit.onPhoneChanged,
                    onCountryChanged: _cubit.onCountryChanged,
                  ),

                  // SizedBox(height: AppSize.getHeight(15)),
                  CustomFieldDropdown<GovernorateModel>(
                    title: 'volunteer.sign_up.governorate'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    hintText: 'volunteer.sign_up.select_your_governorate'.tr(),
                    validator: AppValidators.dropdownRequired<GovernorateModel>,
                    selected: _cubit.selectedGov,
                    items: _cubit.governorates.map((gov) {
                      return DropdownItem(value: gov, child: Text(gov.nameEn));
                    }).toList(),
                    onChanged: (gov) {
                      if (gov != null) {
                        _cubit.selectGovernorate(gov);
                      }
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.headquartersController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'organization.sign_up.headquarters_location'.tr(),
                    hintText: 'organization.sign_up.hint_headquarters_location'
                        .tr(),
                    validator: AppValidators.required,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomUploadFile(
                    height: AppSize.getHeight(100),
                    onTap: () {
                      _cubit.pickDocuments();
                    },
                    onRemove: () {
                      _cubit.removeAttachments();
                    },
                    title: 'organization.sign_up.verification_documents'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    hint: 'organization.sign_up.hint_verification_documents'
                        .tr(),
                    icon: AppIcons.uploadFile,
                    isRequired: true,
                    validator: (file) {
                      if (_cubit.attachments.isEmpty) {
                        return 'organization.sign_up.please_upload_verification_documents'
                            .tr();
                      }
                      return null;
                    },
                  ),

                  if (_cubit.attachments.isNotEmpty) ...[
                    SizedBox(height: AppSize.getHeight(10)),

                    ..._cubit.attachments.map((file) {
                      final fileName = file.path.split('/').last;

                      final isPdf = file.path.toLowerCase().endsWith('.pdf');

                      return Container(
                        margin: AppSize.margin(bottom: 8),
                        padding: AppSize.padding(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isPdf ? Icons.picture_as_pdf : Icons.image,
                              color: AppColors.laserBlue,
                            ),

                            SizedBox(width: AppSize.getWidth(10)),

                            Expanded(
                              child: Text(
                                fileName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: AppColors.black,
                                  fontSize: AppSize.font(13),
                                ),
                              ),
                            ),

                            InkWell(
                              onTap: () {
                                _cubit.removeAttachment(file);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.red,
                                size: AppSize.getSize(20),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],

                  SizedBox(height: AppSize.getHeight(5)),

                  Text(
                    'organization.sign_up.desc_verification_documents'.tr(),
                    style: TextStyle(
                      color: secondaryText,
                      fontSize: AppSize.font(12),
                      fontWeight: FontWeight.w200,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.passwordController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,

                    title: 'organization.sign_up.password'.tr(),

                    hintText: 'organization.sign_up.create_strong_password'
                        .tr(),

                    validator: (value) => AppValidators.password(value),

                    obscureText: _cubit.obscurePassword,

                    iconEnd: _cubit.obscurePassword
                        ? AppIcons.eyeShow
                        : AppIcons.eyeOff,

                    iconEndTap: () {
                      _cubit.updateObscurePassword();
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.confirmPasswordController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,

                    title: 'organization.sign_up.confirm_password'.tr(),

                    hintText: 'organization.sign_up.confirm_your_password'.tr(),

                    validator: (value) => AppValidators.passwordIdentical(
                      value,
                      _cubit.passwordController.text,
                    ),

                    obscureText: _cubit.obscureConfirmedPassword,

                    iconEnd: _cubit.obscureConfirmedPassword
                        ? AppIcons.eyeShow
                        : AppIcons.eyeOff,

                    iconEndTap: () {
                      _cubit.updateObscureConfirmedPassword();
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  Row(
                    children: [
                      SizedBox(
                        width: AppSize.getSize(20),
                        height: AppSize.getSize(20),
                        child: Checkbox(
                          value: acceptTerms,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              acceptTerms = value ?? false;
                            });
                          },
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(8)),

                      Expanded(
                        child: Text(
                          'organization.sign_up.accept_terms'.tr(),
                          style: TextStyle(
                            color:
                                theme.textTheme.bodyMedium?.color ??
                                AppColors.textPrimary,
                            fontSize: AppSize.font(14),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(10)),

                  CustomButton(
                    loading: state is Loading,

                    onTap: _onSignUp,

                    title: 'organization.sign_up.sign_up_button'.tr(),

                    bgColor: AppColors.laserBlue,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

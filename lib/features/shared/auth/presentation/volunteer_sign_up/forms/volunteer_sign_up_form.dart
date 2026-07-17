import 'package:flutter/services.dart';
import 'package:sanad_app/core/shared/widgets/custom_icon.dart';
import 'package:sanad_app/features/shared/auth/data/repos/volunteer/volunteer_repo.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_dropdown.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helper/app_toast.dart';
import '../../../../../../core/shared/widgets/custom_field_phone.dart';
import '../../../../../../core/shared/widgets/custom_selectable_chips.dart';
import '../../../../../../core/shared/widgets/custom_upload_file.dart';
import '../../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../../core/validator/app_validators.dart';
import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../data/models/city_model.dart';
import '../../../data/models/governorate_model.dart';
import '../controllers/volunteer_sign_up_cubit.dart';

class VolunteerSignUpForm extends StatefulWidget {
  const VolunteerSignUpForm({super.key});

  @override
  State<VolunteerSignUpForm> createState() => _VolunteerSignUpFormState();
}

class _VolunteerSignUpFormState extends State<VolunteerSignUpForm> {
  late VolunteerSignUpCubit _cubit;

  bool showIcon = false;

  @override
  void initState() {
    super.initState();

    _cubit = VolunteerSignUpCubit(VolunteerRepoImpel());

    _cubit.getInterests();
    _cubit.loadLocationData();

    _startAnimations();
  }

  @override
  void dispose() {
    _cubit.nameController.dispose();
    _cubit.emailController.dispose();
    _cubit.phoneController.dispose();
    _cubit.locationController.dispose();
    _cubit.birthdayController.dispose();
    _cubit.bloodTypeController.dispose();
    _cubit.skillsController.dispose();
    _cubit.passwordController.dispose();
    _cubit.confirmPasswordController.dispose();

    _cubit.close();

    super.dispose();
  }

  void _startAnimations() {
    _cubit.showTexts = false;
    _cubit.showButtons = false;
    _cubit.showField = false;
    showIcon = false;

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _cubit.showTexts = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _cubit.showButtons = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _cubit.showField = true;
        });
      }
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) setState(() => showIcon = true);
    });
  }

  void _onSignUp() {
    if (!_cubit.acceptTerms) {
      AppToast.error('volunteer.sign_up.you_must_accept_terms'.tr());
      return;
    }

    _cubit.signUp();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<VolunteerSignUpCubit, VolunteerSignUpState>(
      bloc: _cubit,

      builder: (context, state) {
        return AnimatedSlide(
          offset: _cubit.showField ? Offset.zero : const Offset(0, 0.5),

          duration: const Duration(milliseconds: 400),

          curve: Curves.easeOutCubic,

          child: AnimatedOpacity(
            opacity: _cubit.showField ? 1 : 0,

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
                                      ? () => _cubit.pickAvatar()
                                      : null,
                                  child: Container(
                                    padding: AppSize.padding(all: 10),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      color: AppColors.grey100,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: AppColors.primary,
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
                                                color: AppColors.primary,
                                                width: AppSize.getSize(36),
                                                height: AppSize.getSize(36),
                                              ),

                                              SizedBox(
                                                height: AppSize.getSize(6),
                                              ),

                                              Text(
                                                'volunteer.sign_up.upload_photo'
                                                    .tr(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: AppSize.font(12),
                                                  color: AppColors.primary,
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
                                        _cubit.removeAvatar();
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
                          offset: _cubit.showTexts
                              ? Offset.zero
                              : const Offset(0, 0.5),

                          duration: const Duration(milliseconds: 400),

                          curve: Curves.easeOutCubic,

                          child: AnimatedOpacity(
                            opacity: _cubit.showTexts ? 1 : 0,

                            duration: const Duration(milliseconds: 400),

                            child: Column(
                              children: [
                                Text(
                                  'volunteer.sign_up.title'.tr(),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: AppSize.font(20),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                SizedBox(height: AppSize.getHeight(5)),

                                Text(
                                  'volunteer.sign_up.desc'.tr(),
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.color
                                        ?.withValues(alpha: .5),
                                    fontSize: AppSize.font(15),
                                    fontWeight: FontWeight.w400,
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
                    title: 'volunteer.sign_up.full_name'.tr(),
                    hintText: 'volunteer.sign_up.enter_full_name'.tr(),
                    validator: AppValidators.required,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.emailController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'volunteer.sign_up.email'.tr(),
                    hintText: 'volunteer.sign_up.enter_email'.tr(),
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
                    hintText: 'volunteer.sign_up.phone_number'.tr(),
                    initialCountryCode: "EG",
                    onPhoneChanged: _cubit.onPhoneChanged,
                    onCountryChanged: _cubit.onCountryChanged,
                  ),

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

                  CustomFieldDropdown<CityModel>(
                    title: 'volunteer.sign_up.city'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    hintText: 'volunteer.sign_up.select_your_city'.tr(),
                    validator: AppValidators.dropdownRequired<CityModel>,
                    selected: _cubit.selectedCity,
                    items: _cubit.filteredCities.map((city) {
                      return DropdownItem(
                        value: city,
                        child: Text(city.nameEn),
                      );
                    }).toList(),
                    onChanged: (city) {
                      if (city != null) {
                        _cubit.selectCity(city);
                      }
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.locationController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'volunteer.sign_up.address'.tr(),
                    hintText: 'volunteer.sign_up.write_your_address'.tr(),
                    validator: AppValidators.required,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  Text(
                    'volunteer.sign_up.gender'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(15),
                      color:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(6)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _genderButton(
                        title: 'volunteer.sign_up.male'.tr(),
                        index: 0,
                      ),
                      _genderButton(
                        title: 'volunteer.sign_up.female'.tr(),
                        index: 1,
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.birthdayController,
                    iconEnd: AppIcons.calendar,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'volunteer.sign_up.birthday'.tr(),
                    hintText: 'DD / MM / YYYY',
                    readOnly: true,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime(1990),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null) {
                        _cubit.birthdayController.text = DateFormat(
                          'dd/MM/yyyy',
                        ).format(pickedDate);
                      }
                    },
                    validator: AppValidators.required,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldDropdown<String>(
                    title: 'volunteer.sign_up.blood_type'.tr(),
                    hintText: 'volunteer.sign_up.select_blood_type'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    validator: AppValidators.dropdownRequired<String>,
                    selected: _cubit.selectedBloodType,
                    items: _cubit.bloodTypes.map((blood) {
                      return DropdownItem<String>(
                        value: blood,
                        child: Text(blood),
                      );
                    }).toList(),
                    onChanged: (value) {
                      _cubit.selectedBloodType.value = value;
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  Text(
                    'volunteer.sign_up.skills_interests'.tr(),
                    style: TextStyle(
                      fontSize: AppSize.font(15),
                      color:
                          theme.textTheme.bodyMedium?.color ??
                          AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: AppSize.getHeight(6)),

                  CustomSelectableChips(
                    items: _cubit.interests.map((e) => e.label).toList(),
                    layout: ChipsLayout.wrap,
                    multiSelect: true,
                    onChanged: (selectedLabels) {
                      final selectedIds = selectedLabels.map((label) {
                        return _cubit.interests
                            .firstWhere((e) => e.label == label)
                            .value;
                      }).toList();
                      _cubit.updateInterests(selectedIds);
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.nationalIdNumberController,
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    title: 'volunteer.sign_up.national_id_numbers'.tr(),
                    hintText: 'volunteer.sign_up.write_national_id_numbers'
                        .tr(),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(14),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppValidators.required(value);
                      }
                      if (value.length != 14) {
                        return 'volunteer.sign_up.national_id_must_be_14_digits'
                            .tr();
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomUploadFile(
                    height: AppSize.getHeight(200),
                    title: 'volunteer.sign_up.national_id'.tr(),
                    hint: 'volunteer.sign_up.upload_national_id_front'.tr(),
                    titleSize: AppSize.font(15),
                    titleColor:
                        theme.textTheme.bodyMedium?.color ??
                        AppColors.textPrimary,
                    icon: AppIcons.uploadFile,
                    image: _cubit.nationalIdFrontImage,
                    validator: (file) {
                      if (file == null) {
                        return 'volunteer.sign_up.please_upload_front_national_id'
                            .tr();
                      }
                      return null;
                    },
                    onTap: () {
                      _cubit.pickNationalIdImage(
                        context: context,
                        isFront: true,
                      );
                    },
                    onRemove: () {
                      _cubit.removeNationalIdFront();
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  CustomUploadFile(
                    height: AppSize.getHeight(200),
                    hint: 'volunteer.sign_up.upload_national_id_back'.tr(),
                    icon: AppIcons.uploadFile,
                    image: _cubit.nationalIdBackImage,
                    isRequired: true,
                    validator: (file) {
                      if (file == null) {
                        return 'volunteer.sign_up.please_upload_back_national_id'
                            .tr();
                      }
                      return null;
                    },
                    onTap: () {
                      _cubit.pickNationalIdImage(
                        context: context,
                        isFront: false,
                      );
                    },
                    onRemove: () {
                      _cubit.removeNationalIdBack();
                    },
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
                          value: _cubit.acceptTerms,
                          activeColor: AppColors.primary,
                          onChanged: (value) {
                            setState(() {
                              _cubit.acceptTerms = value ?? false;
                            });
                          },
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(8)),

                      Expanded(
                        child: Text(
                          'volunteer.sign_up.accept_terms'.tr(),
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
                    title: 'volunteer.sign_up.sign_up_button'.tr(),
                    onTap: () {
                      _onSignUp();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _genderButton({required String title, required int index}) {
    final isSelected = _cubit.selectedGender == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _cubit.selectedGender = index;
        });
      },

      child: Container(
        width: AppSize.getSize(155),

        height: AppSize.getSize(40),

        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: .1)
              : Theme.of(context).cardColor,

          borderRadius: BorderRadius.circular(10),

          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : Theme.of(context).dividerColor,
          ),
        ),

        child: Center(
          child: Text(
            title,

            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : Theme.of(context).textTheme.bodyMedium?.color,

              fontSize: AppSize.font(15),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:sanad_app/features/shared/auth/data/repos/volunteer/volunteer_repo.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_dropdown.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/shared/widgets/custom_selectable_chips.dart';
import '../../../../../../core/shared/widgets/custom_upload_file.dart';
import '../../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../../core/validator/app_validators.dart';
import '../../../../../../core/style/app_text_style.dart';
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
    _cubit.confirmedPasswordController.dispose();
    super.dispose();
  }

  void _startAnimations() {
    _cubit.showTexts = false;
    _cubit.showButtons = false;
    _cubit.showField = false;

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => _cubit.showTexts = true);
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _cubit.showButtons = true);
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _cubit.showField = true);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  CustomFieldText(
                    controller: _cubit.nameController,
                    title: 'volunteer.sign_up.full_name'.tr(),
                    hintText: 'volunteer.sign_up.enter_full_name'.tr(),
                    validator: AppValidators.required,
                  ),
                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.emailController,
                    title: 'volunteer.sign_up.email'.tr(),
                    hintText: 'volunteer.sign_up.enter_email'.tr(),
                    validator: AppValidators.email,
                  ),
                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldText(
                    controller: _cubit.phoneController,
                    title: 'volunteer.sign_up.phone_number'.tr(),
                    hintText: 'volunteer.sign_up.phone_number'.tr(),
                    validator: AppValidators.required,
                  ),
                  SizedBox(height: AppSize.getHeight(15)),

                  CustomFieldDropdown<GovernorateModel>(
                    title: 'volunteer.sign_up.governorate'.tr(),
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
                    title: 'volunteer.sign_up.address'.tr(),
                    hintText: 'volunteer.sign_up.write_your_address'.tr(),
                    validator: AppValidators.required,
                  ),
                  SizedBox(height: AppSize.getHeight(15)),

                  /// Gender
                  Text(
                    'volunteer.sign_up.gender'.tr(),
                    style: TextStyle(color: AppColors.grey700).xs,
                  ),
                  SizedBox(height: AppSize.getHeight(6)),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _cubit.selectedGender = 0;
                          });
                        },
                        child: Container(
                          width: AppSize.getSize(155),
                          height: AppSize.getSize(40),
                          decoration: BoxDecoration(
                            color: _cubit.selectedGender == 0
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _cubit.selectedGender == 0
                                  ? AppColors.green
                                  : AppColors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'volunteer.sign_up.male'.tr(),
                              style: TextStyle(
                                color: _cubit.selectedGender == 0
                                    ? AppColors.green
                                    : AppColors.black,
                                fontSize: AppSize.font(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _cubit.selectedGender = 1;
                          });
                        },
                        child: Container(
                          width: AppSize.getSize(155),
                          height: AppSize.getSize(40),
                          decoration: BoxDecoration(
                            color: _cubit.selectedGender == 1
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: _cubit.selectedGender == 1
                                  ? AppColors.green
                                  : AppColors.grey,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'volunteer.sign_up.female'.tr(),
                              style: TextStyle(
                                color: _cubit.selectedGender == 1
                                    ? AppColors.green
                                    : AppColors.black,
                                fontSize: AppSize.font(15),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  /// Birthday
                  CustomFieldText(
                    controller: _cubit.birthdayController,
                    title: 'volunteer.sign_up.birthday'.tr(),
                    hintText: 'dd/mm/yyyy',
                    readOnly: true,
                    onTap: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
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

                  /// Blood Type
                  CustomFieldDropdown<String>(
                    title: 'volunteer.sign_up.blood_type'.tr(),
                    hintText: 'volunteer.sign_up.select_blood_type'.tr(),
                    validator: AppValidators.dropdownRequired<String>,
                    selected: _cubit.selectedBloodType,
                    items: _cubit.bloodTypes.map((b) {
                      return DropdownItem<String>(value: b, child: Text(b));
                    }).toList(),
                    onChanged: (value) {
                      _cubit.selectedBloodType.value = value;
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  /// Skills
                  Text(
                    'volunteer.sign_up.skills_interests'.tr(),
                    style: TextStyle(color: AppColors.grey700).xs,
                  ),
                  SizedBox(height: AppSize.getHeight(6)),
                  CustomSelectableChips(
                    items: _cubit.interests.map((e) => e.label).toList(),
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

                  /// Birthday
                  CustomFieldText(
                    controller: _cubit.nationalIdNumberController,
                    title: 'volunteer.sign_up.national_id_numbers'.tr(),
                    hintText: 'volunteer.sign_up.write_national_id_numbers'.tr(),
                    validator: AppValidators.required,
                    onTap: () async {},
                  ),
                  SizedBox(height: AppSize.getHeight(15)),

                  CustomUploadFile(
                    height: AppSize.getHeight(200),
                    title: 'volunteer.sign_up.national_id'.tr(),
                    hint: 'volunteer.sign_up.upload_national_id_front'.tr(),
                    icon: AppIcons.uploadFile,
                    image: _cubit.nationalIdFrontImage,
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

                  /// Password
                  CustomFieldText(
                    controller: _cubit.passwordController,
                    title: 'volunteer.sign_up.password'.tr(),
                    hintText: 'volunteer.sign_up.create_strong_password'.tr(),
                    validator: (value) => AppValidators.passwordIdentical(
                      value,
                      _cubit.passwordController.text,
                    ),
                    obscureText: _cubit.obscurePassword,
                    iconEnd: _cubit.obscurePassword
                        ? AppIcons.eyeShow
                        : AppIcons.eyeOff,
                    iconEndTap: () {
                      _cubit.updateObscurePassword();
                    },
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  /// Confirm Password
                  CustomFieldText(
                    controller: _cubit.confirmedPasswordController,
                    title: 'volunteer.sign_up.confirm_password'.tr(),
                    hintText: 'volunteer.sign_up.confirm_your_password'.tr(),
                    validator: (value) => AppValidators.passwordIdentical(
                      value,
                      _cubit.confirmedPasswordController.text,
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

                  /// Terms
                  Row(
                    children: [
                      SizedBox(
                        width: AppSize.getSize(20),
                        height: AppSize.getSize(20),
                        child: Checkbox(
                          value: _cubit.acceptTerms,
                          activeColor: AppColors.green,
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
                          style: TextStyle(color: AppColors.black).xs,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.getHeight(10)),

                  CustomButton(
                    loading: state is Loading,
                    title: 'volunteer.sign_up.sign_up_button'.tr(),
                    onTap: () => _cubit.signUp(),
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

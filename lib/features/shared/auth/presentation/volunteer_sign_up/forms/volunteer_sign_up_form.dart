import 'package:sanad_app/core/shared/widgets/custom_field_dropdown.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/shared/widgets/custom_selectable_chips.dart';
import '../../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../../core/shared/widgets/custom_upload_file.dart';
import '../../../../../../core/validator/app_validators.dart';
import '../../../../../../core/style/app_text_style.dart';
import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../sign_in/screens/sign_in_screen.dart';

class VolunteerSignUpForm extends StatefulWidget {
  const VolunteerSignUpForm({super.key});

  @override
  State<VolunteerSignUpForm> createState() => _VolunteerSignUpFormState();
}

class _VolunteerSignUpFormState extends State<VolunteerSignUpForm> {
  bool showTexts = false;
  bool showButtons = false;
  bool showField = false;
  bool acceptTerms = false;

  int selectedIndex = 0;

  String selectedBloodType = 'A+';
  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startAnimations();
  }

  void _startAnimations() {
    showTexts = false;
    showButtons = false;
    showField = false;

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) setState(() => showTexts = true);
    });

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => showButtons = true);
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => showField = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: showField ? Offset.zero : const Offset(0, 0.5),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: showField ? 1 : 0,
        duration: const Duration(milliseconds: 400),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomFieldText(
              controller: nameController,
              title: 'volunteer.sign_up.full_name'.tr(),
              hintText: 'volunteer.sign_up.enter_full_name'.tr(),
              validator: AppValidators.required,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomFieldText(
              controller: emailController,
              title: 'volunteer.sign_up.email'.tr(),
              hintText: 'volunteer.sign_up.enter_email'.tr(),
              validator: AppValidators.email,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomFieldText(
              controller: phoneController,
              title: 'volunteer.sign_up.phone_number'.tr(),
              hintText: 'volunteer.sign_up.phone_number'.tr(),
              validator: AppValidators.required,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomFieldText(
              controller: locationController,
              title: 'volunteer.sign_up.location'.tr(),
              hintText: 'volunteer.sign_up.select_your_city'.tr(),
              validator: AppValidators.required,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // Gender selection
            Text(
              'volunteer.sign_up.gender'.tr(),
              style: TextStyle(color: AppColors.grey700).xs,
            ),
            SizedBox(height: AppSize.getHeight(6)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _genderOption('volunteer.sign_up.male'.tr(), 0),
                _genderOption('volunteer.sign_up.female'.tr(), 1),
              ],
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // Birthday
            CustomFieldText(
              controller: locationController,
              title: 'volunteer.sign_up.birthday'.tr(),
              hintText: 'dd/mm/yyyy',
              validator: AppValidators.required,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // Blood Type
            CustomFieldDropdown<String>(
              items: bloodTypes
                  .map(
                    (b) => DropdownMenuItem<String>(value: b, child: Text(b)),
                  )
                  .toList(),
              selected: selectedBloodType,
              title: 'volunteer.sign_up.blood_type'.tr(),
              hintText: 'volunteer.sign_up.select_blood_type'.tr(),
              validator: AppValidators.required,
              onChanged: (value) {
                setState(() {
                  selectedBloodType = value!;
                });
              },
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // Skills
            CustomSelectableChips(
              items: [
                'Teaching',
                'Healthcare',
                'Technology',
                'Construction',
                'Art & Design',
                'Communication',
                'Event Planning',
                'Food Service',
                'Transportation',
                'First Aid',
                'Social Media',
                'Photography',
              ],
              multiSelect: true,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // National ID
            CustomUploadFile(
              title: 'volunteer.sign_up.national_id'.tr(),
              hint: 'volunteer.sign_up.upload_national_id'.tr(),
              icon: AppIcons.uploadFile,
              onTap: () {},
              onRemove: () {},
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // Password
            CustomFieldText(
              controller: TextEditingController(),
              title: 'volunteer.sign_up.password'.tr(),
              hintText: 'volunteer.sign_up.create_strong_password'.tr(),
              validator: AppValidators.password,
              iconEnd: AppIcons.eyeShow,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // Password Confirm
            CustomFieldText(
              controller: TextEditingController(),
              title: 'volunteer.sign_up.confirm_password'.tr(),
              hintText: 'volunteer.sign_up.confirm_your_password'.tr(),
              validator: AppValidators.password,
              iconEnd: AppIcons.eyeShow,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // Terms & Condition
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppSize.getSize(20),
                  height: AppSize.getSize(20),
                  child: Checkbox(
                    value: acceptTerms,
                    activeColor: AppColors.green,
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
                    'volunteer.sign_up.accept_terms'.tr(),
                    style: TextStyle(color: AppColors.black).xs,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.getHeight(10)),
            CustomButton(
              title: 'volunteer.sign_up.sign_up_button'.tr(),
              onTap: () {},
            ),
            SizedBox(height: AppSize.getHeight(8)),
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "volunteer.sign_up.already_have_account".tr(),
                  style: TextStyle(color: AppColors.black).xs,
                  children: [
                    TextSpan(
                      text: "volunteer.sign_up.sign_in".tr(),
                      style: TextStyle(color: AppColors.green).xs,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => AppNavigator.remove(SignInScreen()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _genderOption(String label, int index) {
    final bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        width: AppSize.getSize(160),
        height: AppSize.getSize(50),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.green : AppColors.grey,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.green : AppColors.black,
              fontSize: AppSize.font(15),
            ),
          ),
        ),
      ),
    );
  }
}

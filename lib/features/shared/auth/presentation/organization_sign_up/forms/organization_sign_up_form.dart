import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/constant/app_assets.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_upload_file.dart';

import '../../../../../../core/constant/app_size.dart';
import '../../../../../../core/shared/widgets/custom_field_text.dart';
import '../../../../../../core/style/app_colors.dart';
import '../../../../../../core/style/app_text_style.dart';
import '../../../../../../core/validator/app_validators.dart';
import '../../sign_in/screens/sign_in_screen.dart';

class OrganizationSignUpForm extends StatefulWidget {
  const OrganizationSignUpForm({super.key});

  @override
  State<OrganizationSignUpForm> createState() => _OrganizationSignUpFormState();
}

class _OrganizationSignUpFormState extends State<OrganizationSignUpForm> {
  bool showTexts = false;
  bool showButtons = false;
  bool showField = false;
  bool acceptTerms = false;

  int selectedIndex = 0;

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
              title: 'organization.sign_up.organization_name'.tr(),
              hintText: 'organization.sign_up.hint_organization_name'.tr(),
              validator: AppValidators.required,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomFieldText(
              controller: emailController,
              title: 'organization.sign_up.website_link'.tr(),
              hintText: 'organization.sign_up.hint_website_link'.tr(),
              validator: AppValidators.email,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomFieldText(
              controller: phoneController,
              title: 'organization.sign_up.official_email'.tr(),
              hintText: 'organization.sign_up.hint_official_email'.tr(),
              validator: AppValidators.required,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomFieldText(
              controller: locationController,
              title: 'organization.sign_up.phone_number'.tr(),
              hintText: '+20 123 456 7890',
              validator: AppValidators.required,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomFieldText(
              controller: locationController,
              title: 'organization.sign_up.headquarters_location'.tr(),
              hintText: 'organization.sign_up.hint_headquarters_location'.tr(),
              validator: AppValidators.required,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomUploadFile(
              onTap: () {},
              onRemove: () {},
              title: 'organization.sign_up.branch_locations'.tr(),
              hint: 'organization.sign_up.hint_branch_locations'.tr(),
              icon: AppIcons.add,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            CustomUploadFile(
              onTap: () {},
              onRemove: () {},
              title: 'organization.sign_up.verification_documents'.tr(),
              hint: 'organization.sign_up.hint_verification_documents'.tr(),
              icon: AppIcons.uploadFile,
            ),
            SizedBox(height: AppSize.getHeight(5)),
            Text(
              'organization.sign_up.desc_verification_documents'.tr(),
              style: TextStyle(
                color: AppColors.black,
                fontSize: AppSize.font(12),
                fontWeight: FontWeight.w200,
              ),
            ),
            // National ID
            SizedBox(height: AppSize.getHeight(15)),
            // Password
            CustomFieldText(
              controller: TextEditingController(),
              title: 'organization.sign_up.password'.tr(),
              hintText: 'organization.sign_up.create_strong_password'.tr(),
              validator: AppValidators.password,
              iconEnd: AppIcons.eyeShow,
            ),
            SizedBox(height: AppSize.getHeight(15)),
            // Password Confirm
            CustomFieldText(
              controller: TextEditingController(),
              title: 'organization.sign_up.confirm_password'.tr(),
              hintText: 'organization.sign_up.confirm_your_password'.tr(),
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
                    'organization.sign_up.accept_terms'.tr(),
                    style: TextStyle(color: AppColors.black).xs,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSize.getHeight(10)),
            CustomButton(
              onTap: () {},
              title: 'organization.sign_up.sign_up_button'.tr(),
              bgColor: AppColors.laserBlue,
            ),
            SizedBox(height: AppSize.getHeight(8)),
            Align(
              alignment: Alignment.center,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "organization.sign_up.already_have_account".tr(),
                  style: TextStyle(color: AppColors.black).xs,
                  children: [
                    TextSpan(
                      text: "organization.sign_up.sign_in".tr(),
                      style: TextStyle(color: AppColors.laserBlue).xs,
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
}

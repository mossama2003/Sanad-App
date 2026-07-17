import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/shared/widgets/custom_switch.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/style/app_colors.dart';
import '../../../../shared/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../cards/edit_profile_group_card.dart';

class EditVolunteerProfileScreen extends StatefulWidget {
  const EditVolunteerProfileScreen({super.key});

  @override
  State<EditVolunteerProfileScreen> createState() =>
      _EditVolunteerProfileScreenState();
}

class _EditVolunteerProfileScreenState
    extends State<EditVolunteerProfileScreen> {
  bool isAvailable = false;

  final List<String> allLanguages = [
    'English',
    'Arabic',
    'French',
    'German',
    'Spanish',
    'Italian',
    'Chinese',
    'Japanese',
    'Turkish',
  ];

  final List<String> selectedLanguages = ['English', 'Arabic'];

  final List<String> allSkills = [
    'First Aid',
    'CPR',
    'Driver License',
    'Triage',
    'Logistics',
    'Photography',
    'Social Media',
    'Teaching',
    'Translation',
    'Cooking',
  ];

  final List<String> selectedSkills = [
    'First Aid',
    'CPR',
    'Driver License',
    'Triage',
    'Logistics',
  ];

  Widget field({
    required TextEditingController controller,
    required String title,
    TextInputType? keyboardType,
    int? maxLines,
  }) {
    final theme = Theme.of(context);

    return CustomFieldText(
      controller: controller,
      title: title.tr(),
      titleSize: AppSize.font(15),
      titleColor: theme.colorScheme.onSurface,
      hintText: '',
      keyboardType: keyboardType ?? TextInputType.text,
      maxLines: maxLines,
      borderRadius: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final unSelectedLanguages = allLanguages
        .where((e) => !selectedLanguages.contains(e))
        .toList();

    final unSelectedSkills = allSkills
        .where((e) => !selectedSkills.contains(e))
        .toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Text(
          'volunteer.edit_profile.appbar'.tr(),
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: AppSize.font(18),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSize.padding(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              /// Profile Image
              EditProfileGroupCard(
                title: '',
                children: [
                  Row(
                    children: [
                      Container(
                        width: AppSize.getWidth(50),
                        height: AppSize.getWidth(50),

                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,

                          gradient: LinearGradient(
                            colors: [Color(0xFF2ECFA0), Color(0xFF1BB88A)],
                          ),
                        ),

                        child: Center(
                          child: CustomIcon(
                            icon: AppIcons.profile,
                            color: AppColors.white,
                            width: AppSize.getSize(30),
                            height: AppSize.getSize(30),
                          ),
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(10)),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              'volunteer.edit_profile.profile_photo'.tr(),

                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: AppSize.font(15),
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            SizedBox(height: AppSize.getHeight(3)),

                            Text(
                              'volunteer.edit_profile.shown_across_app'.tr(),

                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: .5,
                                ),

                                fontSize: AppSize.font(12),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: AppSize.getWidth(80),

                        child: CustomButton(
                          height: AppSize.getHeight(35),

                          title: 'volunteer.edit_profile.change'.tr(),

                          bgColor: Colors.transparent,

                          borderColor: AppColors.primary,

                          textColor: AppColors.primary,

                          textSize: AppSize.font(12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppSize.getHeight(20)),

              /// Personal Info
              EditProfileGroupCard(
                title: 'volunteer.edit_profile.personal_info'.tr(),

                children: [
                  field(
                    controller: TextEditingController(),
                    title: 'volunteer.edit_profile.full_name',
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  field(
                    controller: TextEditingController(),
                    title: 'volunteer.edit_profile.email',
                    keyboardType: TextInputType.emailAddress,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  field(
                    controller: TextEditingController(),
                    title: 'volunteer.edit_profile.phone',
                    keyboardType: TextInputType.phone,
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  Row(
                    children: [
                      Expanded(
                        child: field(
                          controller: TextEditingController(),
                          title: 'volunteer.edit_profile.governorate',
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(10)),

                      Expanded(
                        child: field(
                          controller: TextEditingController(),
                          title: 'volunteer.edit_profile.city',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(15)),

                  field(
                    controller: TextEditingController(),
                    title: 'volunteer.edit_profile.bio',
                    maxLines: 5,
                  ),
                ],
              ),

              SizedBox(height: AppSize.getHeight(20)),

              /// Volunteer Details
              EditProfileGroupCard(
                title: 'volunteer.edit_profile.volunteer_details'.tr(),

                children: [
                  Row(
                    children: [
                      Expanded(
                        child: field(
                          controller: TextEditingController(),
                          title: 'volunteer.edit_profile.profession',
                        ),
                      ),

                      SizedBox(width: AppSize.getWidth(10)),

                      Expanded(
                        child: field(
                          controller: TextEditingController(),
                          title: 'volunteer.edit_profile.blood_type',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSize.getHeight(15)),
                  field(
                    controller: TextEditingController(),
                    title: 'volunteer.edit_profile.emergency_experience',
                  ),
                  SizedBox(height: AppSize.getHeight(15)),
                  Container(
                    width: double.infinity,
                    padding: AppSize.padding(vertical: 12, horizontal: 15),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.grey900.withValues(alpha: .25)
                          : AppColors.grey300.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(24),
                    ),

                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'volunteer.edit_profile.own_vehicle'.tr(),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: AppSize.font(15),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'volunteer.edit_profile.available_for_logistics'
                                    .tr(),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(
                                    alpha: .5,
                                  ),
                                  fontSize: AppSize.font(12),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomSwitch(
                          value: isAvailable,
                          onChanged: (value) {
                            setState(() {
                              isAvailable = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSize.getHeight(20)),

              /// Languages
              EditProfileGroupCard(
                title: 'volunteer.edit_profile.languages'.tr(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Selected
                      Wrap(
                        spacing: AppSize.getWidth(10),
                        runSpacing: AppSize.getHeight(10),
                        children: selectedLanguages.map((language) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                selectedLanguages.remove(language);
                              });
                            },
                            child: Container(
                              padding: AppSize.padding(
                                vertical: 5,
                                horizontal: 13,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(
                                  alpha: isDark ? .2 : .1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    language,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: AppSize.font(12),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: AppSize.getWidth(5)),
                                  CustomIcon(
                                    icon: AppIcons.close,
                                    width: AppSize.getSize(16),
                                    height: AppSize.getSize(16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      if (selectedLanguages.isNotEmpty &&
                          unSelectedLanguages.isNotEmpty)
                        SizedBox(height: AppSize.getHeight(20)),

                      /// Not Selected
                      Wrap(
                        spacing: AppSize.getWidth(10),
                        runSpacing: AppSize.getHeight(10),
                        children: unSelectedLanguages.map((language) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                selectedLanguages.add(language);
                              });
                            },
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: const Radius.circular(20),
                                dashPattern: const [4, 2],
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: .5,
                                ),
                                strokeWidth: 1,
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                padding: AppSize.padding(
                                  vertical: 5,
                                  horizontal: 13,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIcon(
                                      icon: AppIcons.add,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: .5),
                                      width: AppSize.getWidth(16),
                                      height: AppSize.getHeight(16),
                                    ),
                                    SizedBox(width: AppSize.getWidth(5)),
                                    Text(
                                      language,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: .5),
                                        fontSize: AppSize.font(12),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppSize.getHeight(20)),

              /// Skills & Certificates
              EditProfileGroupCard(
                title: 'volunteer.edit_profile.skills_certifications'.tr(),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Selected
                      Wrap(
                        spacing: AppSize.getWidth(10),
                        runSpacing: AppSize.getHeight(10),
                        children: selectedSkills.map((skill) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                selectedSkills.remove(skill);
                              });
                            },
                            child: Container(
                              padding: AppSize.padding(
                                vertical: 5,
                                horizontal: 13,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.laserBlue.withValues(
                                  alpha: isDark ? .2 : .1,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    skill,
                                    style: TextStyle(
                                      color: AppColors.laserBlue,
                                      fontSize: AppSize.font(12),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: AppSize.getWidth(5)),
                                  CustomIcon(
                                    icon: AppIcons.close,
                                    color: AppColors.laserBlue,
                                    width: AppSize.getSize(16),
                                    height: AppSize.getSize(16),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      if (selectedSkills.isNotEmpty &&
                          unSelectedSkills.isNotEmpty)
                        SizedBox(height: AppSize.getHeight(20)),

                      /// Not Selected
                      Wrap(
                        spacing: AppSize.getWidth(10),
                        runSpacing: AppSize.getHeight(10),
                        children: unSelectedSkills.map((skill) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              setState(() {
                                selectedSkills.add(skill);
                              });
                            },
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: const Radius.circular(20),
                                dashPattern: const [4, 2],
                                color: theme.colorScheme.onSurface.withValues(
                                  alpha: .5,
                                ),
                                strokeWidth: 1,
                                padding: EdgeInsets.zero,
                              ),
                              child: Container(
                                padding: AppSize.padding(
                                  vertical: 5,
                                  horizontal: 13,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIcon(
                                      icon: AppIcons.add,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: .5),
                                      width: AppSize.getWidth(16),
                                      height: AppSize.getHeight(16),
                                    ),
                                    SizedBox(width: AppSize.getWidth(5)),
                                    Text(
                                      skill,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: .5),
                                        fontSize: AppSize.font(12),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppSize.getHeight(20)),

              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onTap: () => AppNavigator.pop(),
                      title: 'volunteer.edit_profile.cancel'.tr(),
                      textColor: theme.colorScheme.primary,
                      borderColor: theme.colorScheme.primary,
                      bgColor: Colors.transparent,
                    ),
                  ),
                  SizedBox(width: AppSize.getWidth(10)),
                  Expanded(
                    child: CustomButton(
                      title: 'volunteer.edit_profile.save_changes'.tr(),
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSize.getHeight(10)),

              CustomButton(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => ConfirmDialog(
                      title: 'volunteer.edit_profile.delete_account'.tr(),
                      message: 'volunteer.edit_profile.delete_account_desc'
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
                title: 'volunteer.edit_profile.delete_account'.tr(),
                icon: AppIcons.delete,
                iconSize: AppSize.getSize(17),
                textColor: AppColors.red,
                textSize: AppSize.font(14),
                bgColor: Colors.transparent,
                borderColor: AppColors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

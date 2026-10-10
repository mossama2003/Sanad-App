import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:sanad_app/core/shared/widgets/custom_button.dart';
import 'package:sanad_app/core/shared/widgets/custom_field_text.dart';
import 'package:sanad_app/core/shared/widgets/custom_switch.dart';

import '../../../../../core/shared/models/city_model.dart';
import '../../../../../core/shared/models/governorate_model.dart';
import '../../../../../core/shared/widgets/custom_field_dropdown.dart';
import '../../../../../core/shared/widgets/custom_field_phone.dart';
import '../../../../shared/auth/presentation/sign_in/screens/sign_in_screen.dart';
import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/dialogs/confirm_dialog.dart';
import '../../../../../core/shared/widgets/custom_icon.dart';
import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_size.dart';
import '../../../../../core/style/app_colors.dart';
import '../../data/repos/edit_vol_profile_repo.dart';
import '../cards/edit_profile_group_card.dart';
import '../controllers/edit_vol_profile_cubit.dart';

class EditVolProfileScreen extends StatefulWidget {
  const EditVolProfileScreen({super.key});

  @override
  State<EditVolProfileScreen> createState() => _EditVolProfileScreenState();
}

class _EditVolProfileScreenState extends State<EditVolProfileScreen> {
  late final EditVolProfileCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = EditVolProfileCubit(EditVolProfileRepoImpel());

    final user = AppCubit.get(context).user;

    cubit.initialize(user);
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: BlocBuilder<EditVolProfileCubit, EditVolProfileState>(
        builder: (context, state) {
          final cubit = EditVolProfileCubit.get(context);

          final theme = Theme.of(context);

          final isDark = theme.brightness == Brightness.dark;

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
                padding: AppSize.padding(horizontal: 16, bottom: 20),

                child: Column(
                  children: [
                    _buildProfileImage(context, cubit),

                    SizedBox(height: AppSize.getHeight(20)),

                    _buildPersonalInfo(context, cubit),

                    SizedBox(height: AppSize.getHeight(20)),

                    _buildVolunteerDetails(context, cubit, isDark),

                    SizedBox(height: AppSize.getHeight(20)),

                    _buildLanguages(context, cubit, isDark),

                    SizedBox(height: AppSize.getHeight(20)),

                    _buildSkills(context, cubit, isDark),

                    SizedBox(height: AppSize.getHeight(20)),

                    _buildActions(context, cubit),

                    SizedBox(height: AppSize.getHeight(10)),

                    _buildDeleteButton(context),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context, EditVolProfileCubit cubit) {
    final theme = Theme.of(context);

    return EditProfileGroupCard(
      title: '',
      children: [
        Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                if (cubit.newAvatar != null)
                  ClipOval(
                    child: Image.file(
                      cubit.newAvatar!,
                      width: AppSize.getWidth(50),
                      height: AppSize.getWidth(50),
                      fit: BoxFit.cover,
                    ),
                  )
                else if (cubit.existingAvatarUrl != null &&
                    !cubit.avatarRemoved)
                  ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: cubit.existingAvatarUrl!,
                      width: AppSize.getWidth(50),
                      height: AppSize.getWidth(50),
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return Container(
                          width: AppSize.getWidth(50),
                          height: AppSize.getWidth(50),
                          color: AppColors.grey300,
                        );
                      },
                      errorWidget: (context, url, error) {
                        return _defaultAvatarPlaceholder();
                      },
                    ),
                  )
                else
                  _defaultAvatarPlaceholder(),

                if (cubit.newAvatar != null ||
                    (cubit.existingAvatarUrl != null && !cubit.avatarRemoved))
                  Positioned(
                    top: -4,
                    right: -4,
                    child: GestureDetector(
                      onTap: cubit.removeAvatar,
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
                      color: theme.colorScheme.onSurface.withValues(alpha: .5),
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
                onTap: cubit.pickAvatar,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalInfo(BuildContext context, EditVolProfileCubit cubit) {
    final theme = Theme.of(context);

    return EditProfileGroupCard(
      title: 'volunteer.edit_profile.personal_info'.tr(),

      children: [
        CustomFieldText(
          controller: cubit.fullNameController,

          title: 'volunteer.edit_profile.full_name'.tr(),

          titleSize: AppSize.font(15),

          titleColor: theme.colorScheme.onSurface,

          hintText: '',

          borderRadius: 25,

          enabled: false,
        ),

        SizedBox(height: AppSize.getHeight(15)),

        CustomFieldText(
          controller: cubit.emailController,

          title: 'volunteer.edit_profile.email'.tr(),

          titleSize: AppSize.font(15),

          titleColor: theme.colorScheme.onSurface,

          hintText: '',

          keyboardType: TextInputType.emailAddress,

          borderRadius: 25,
        ),

        SizedBox(height: AppSize.getHeight(15)),

        CustomFieldPhone(
          controller: cubit.phoneController,

          titleSize: AppSize.font(15),

          titleColor: theme.colorScheme.onSurface,

          title: 'volunteer.edit_profile.phone'.tr(),

          hintText: 'volunteer.edit_profile.phone'.tr(),

          initialCountryCode: 'EG',

          onPhoneChanged: cubit.onPhoneChanged,

          onCountryChanged: cubit.onCountryChanged,
        ),

        SizedBox(height: AppSize.getHeight(15)),

        _buildCountry(context, cubit),

        SizedBox(height: AppSize.getHeight(15)),

        _buildGovernorate(context, cubit),

        SizedBox(height: AppSize.getHeight(15)),

        _buildCity(context, cubit),

        SizedBox(height: AppSize.getHeight(15)),

        CustomFieldText(
          controller: cubit.addressController,

          title: 'volunteer.edit_profile.address'.tr(),

          titleSize: AppSize.font(15),

          titleColor: theme.colorScheme.onSurface,

          hintText: '',

          borderRadius: 25,

          maxLines: 2,
        ),
      ],
    );
  }

  Widget _buildGovernorate(BuildContext context, EditVolProfileCubit cubit) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<GovernorateModel?>(
      valueListenable: cubit.selectedGov,

      builder: (context, selected, _) {
        return CustomFieldDropdown<GovernorateModel>(
          title: 'volunteer.edit_profile.governorate'.tr(),

          titleSize: AppSize.font(15),

          titleColor: theme.colorScheme.onSurface,

          hintText: 'volunteer.sign_up.select_your_governorate'.tr(),

          selected: cubit.selectedGov,

          items: cubit.governorates.map((gov) {
            return DropdownItem(value: gov, child: Text(gov.nameEn));
          }).toList(),

          onChanged: (gov) {
            if (gov != null) {
              cubit.selectGovernorate(gov);
            }
          },
        );
      },
    );
  }

  Widget _buildCity(BuildContext context, EditVolProfileCubit cubit) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<CityModel?>(
      valueListenable: cubit.selectedCity,

      builder: (context, selected, _) {
        return CustomFieldDropdown<CityModel>(
          title: 'volunteer.edit_profile.city'.tr(),

          titleSize: AppSize.font(15),

          titleColor: theme.colorScheme.onSurface,

          hintText: 'volunteer.sign_up.select_your_city'.tr(),

          selected: cubit.selectedCity,

          items: cubit.filteredCities.map((city) {
            return DropdownItem(value: city, child: Text(city.nameEn));
          }).toList(),

          onChanged: (city) {
            if (city != null) {
              cubit.selectCity(city);
            }
          },
        );
      },
    );
  }

  Widget _buildCountry(BuildContext context, EditVolProfileCubit cubit) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<String?>(
      valueListenable: cubit.selectedCountryName,

      builder: (context, selected, _) {
        return CustomFieldDropdown<String>(
          title: 'volunteer.edit_profile.country'.tr(),

          titleSize: AppSize.font(15),

          titleColor: theme.colorScheme.onSurface,

          hintText: '',

          selected: cubit.selectedCountryName,

          items: EditVolProfileCubit.countries.map((country) {
            return DropdownItem(value: country, child: Text(country));
          }).toList(),

          onChanged: cubit.selectCountry,
        );
      },
    );
  }

  Widget _buildVolunteerDetails(
    BuildContext context,
    EditVolProfileCubit cubit,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    return EditProfileGroupCard(
      title: 'volunteer.edit_profile.volunteer_details'.tr(),

      children: [
        Row(
          children: [
            Expanded(
              child: CustomFieldText(
                controller: cubit.professionController,

                title: 'volunteer.edit_profile.profession'.tr(),

                titleSize: AppSize.font(15),

                titleColor: theme.colorScheme.onSurface,

                hintText: '',

                borderRadius: 25,
              ),
            ),

            SizedBox(width: AppSize.getWidth(10)),

            Expanded(
              child: ValueListenableBuilder<String?>(
                valueListenable: cubit.selectedBloodType,

                builder: (context, selected, _) {
                  return CustomFieldDropdown<String>(
                    title: 'volunteer.edit_profile.blood_type'.tr(),

                    titleSize: AppSize.font(15),

                    titleColor: theme.colorScheme.onSurface,

                    hintText: 'volunteer.sign_up.select_blood_type'.tr(),

                    selected: cubit.selectedBloodType,

                    items: EditVolProfileCubit.bloodTypes.map((blood) {
                      return DropdownItem(value: blood, child: Text(blood));
                    }).toList(),

                    onChanged: cubit.selectBloodType,
                  );
                },
              ),
            ),
          ],
        ),

        SizedBox(height: AppSize.getHeight(15)),

        CustomFieldText(
          controller: cubit.emergencyExperienceController,

          title: 'volunteer.edit_profile.emergency_experience'.tr(),

          titleSize: AppSize.font(15),

          titleColor: theme.colorScheme.onSurface,

          hintText: '',

          keyboardType: TextInputType.number,

          borderRadius: 25,
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
                      'volunteer.edit_profile.available_for_logistics'.tr(),

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
                value: cubit.isAvailable,

                onChanged: cubit.changeVehicleAvailability,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLanguages(
    BuildContext context,
    EditVolProfileCubit cubit,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    return EditProfileGroupCard(
      title: 'volunteer.edit_profile.languages'.tr(),

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Wrap(
              spacing: AppSize.getWidth(10),

              runSpacing: AppSize.getHeight(10),

              children: cubit.selectedLanguages.map((language) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),

                  onTap: () {
                    cubit.removeLanguage(language);
                  },

                  child: Container(
                    padding: AppSize.padding(vertical: 5, horizontal: 13),

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

            if (cubit.selectedLanguages.isNotEmpty &&
                cubit.unSelectedLanguages.isNotEmpty)
              SizedBox(height: AppSize.getHeight(20)),

            Wrap(
              spacing: AppSize.getWidth(10),

              runSpacing: AppSize.getHeight(10),

              children: cubit.unSelectedLanguages.map((language) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),

                  onTap: () {
                    cubit.addLanguage(language);
                  },

                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: const Radius.circular(20),

                      dashPattern: const [4, 2],

                      color: theme.colorScheme.onSurface.withValues(alpha: .5),

                      strokeWidth: 1,

                      padding: EdgeInsets.zero,
                    ),

                    child: Container(
                      padding: AppSize.padding(vertical: 5, horizontal: 13),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          CustomIcon(
                            icon: AppIcons.add,

                            color: theme.colorScheme.onSurface.withValues(
                              alpha: .5,
                            ),

                            width: AppSize.getWidth(16),

                            height: AppSize.getHeight(16),
                          ),

                          SizedBox(width: AppSize.getWidth(5)),

                          Text(
                            language,

                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: .5,
                              ),

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
    );
  }

  Widget _buildSkills(
    BuildContext context,
    EditVolProfileCubit cubit,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    return EditProfileGroupCard(
      title: 'volunteer.edit_profile.skills_certifications'.tr(),

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Wrap(
              spacing: AppSize.getWidth(10),

              runSpacing: AppSize.getHeight(10),

              children: cubit.selectedSkills.map((skill) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),

                  onTap: () {
                    cubit.removeSkill(skill);
                  },

                  child: Container(
                    padding: AppSize.padding(vertical: 5, horizontal: 13),

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

            if (cubit.selectedSkills.isNotEmpty &&
                cubit.unSelectedSkills.isNotEmpty)
              SizedBox(height: AppSize.getHeight(20)),

            Wrap(
              spacing: AppSize.getWidth(10),

              runSpacing: AppSize.getHeight(10),

              children: cubit.unSelectedSkills.map((skill) {
                return InkWell(
                  borderRadius: BorderRadius.circular(20),

                  onTap: () {
                    cubit.addSkill(skill);
                  },

                  child: DottedBorder(
                    options: RoundedRectDottedBorderOptions(
                      radius: const Radius.circular(20),

                      dashPattern: const [4, 2],

                      color: theme.colorScheme.onSurface.withValues(alpha: .5),

                      strokeWidth: 1,

                      padding: EdgeInsets.zero,
                    ),

                    child: Container(
                      padding: AppSize.padding(vertical: 5, horizontal: 13),

                      child: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          CustomIcon(
                            icon: AppIcons.add,

                            color: theme.colorScheme.onSurface.withValues(
                              alpha: .5,
                            ),

                            width: AppSize.getWidth(16),

                            height: AppSize.getHeight(16),
                          ),

                          SizedBox(width: AppSize.getWidth(5)),

                          Text(
                            skill,

                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: .5,
                              ),

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
    );
  }

  Widget _buildActions(BuildContext context, EditVolProfileCubit cubit) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            onTap: () {
              AppNavigator.pop();
            },

            title: 'volunteer.edit_profile.cancel'.tr(),

            textColor: Theme.of(context).colorScheme.primary,

            borderColor: Theme.of(context).colorScheme.primary,

            bgColor: Colors.transparent,
          ),
        ),

        SizedBox(width: AppSize.getWidth(10)),

        Expanded(
          child: CustomButton(
            title: 'volunteer.edit_profile.save_changes'.tr(),

            loading: cubit.state is Loading,

            bgColor: cubit.hasChanges
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: .35),

            textColor: cubit.hasChanges
                ? AppColors.white
                : AppColors.white.withValues(alpha: .6),

            onTap: cubit.hasChanges && cubit.state is! Loading
                ? () {
                    cubit.submit(context: context);
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return CustomButton(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return ConfirmDialog(
              title: 'volunteer.edit_profile.delete_account'.tr(),

              message: 'volunteer.edit_profile.delete_account_desc'.tr(),

              confirmText: 'core.delete'.tr(),

              isDestructive: true,

              onConfirm: () async {
                await AppCubit.get(context).deleteAccount();

                if (!context.mounted) return;

                AppNavigator.remove(const SignInScreen());
              },
            );
          },
        );
      },

      title: 'volunteer.edit_profile.delete_account'.tr(),

      icon: AppIcons.delete,

      iconSize: AppSize.getSize(17),

      textColor: AppColors.red,

      textSize: AppSize.font(14),

      bgColor: Colors.transparent,

      borderColor: AppColors.red,
    );
  }

  Widget _defaultAvatarPlaceholder() {
    return Container(
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
    );
  }
}

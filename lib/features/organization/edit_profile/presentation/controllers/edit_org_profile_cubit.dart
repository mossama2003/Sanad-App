import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:sanad_app/features/organization/edit_profile/data/params/update_org_profile_param.dart';
import 'package:sanad_app/features/organization/edit_profile/data/repos/edit_org_profile_repo.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';

part 'edit_org_profile_state.dart';

class EditOrgProfileCubit extends Cubit<EditOrgProfileState> {
  EditOrgProfileCubit(this.repo) : super(Initial()) {
    _setupListeners();
  }

  final EditOrgProfileRepo repo;

  static EditOrgProfileCubit get(BuildContext context) =>
      BlocProvider.of<EditOrgProfileCubit>(context);

  final TextEditingController orgNameController = TextEditingController();
  final TextEditingController registrationNoController =
      TextEditingController();
  final TextEditingController aboutController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();

  final TextEditingController governorateController = TextEditingController();
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

  File? newLogo;
  String? existingLogoUrl;

  bool logoRemoved = false;

  Country? selectedCountry;
  PhoneNumber? selectedPhone;

  String countryDialCode = '20';

  String? initialOrgName;
  String? initialRegistrationNo;
  String? initialAbout;

  String? initialEmail;
  String? initialPhone;
  String? initialWebsite;

  String? initialGovernorate;
  String? initialAddress;

  String? initialFacebook;
  String? initialTwitter;
  String? initialInstagram;
  String? initialLinkedin;

  String? initialOrganizationType;

  String? initialLogoUrl;

  bool get hasChanges {
    if (_normalize(orgNameController.text) != _normalize(initialOrgName)) {
      return true;
    }

    if (_normalize(registrationNoController.text) !=
        _normalize(initialRegistrationNo)) {
      return true;
    }

    if (_normalize(aboutController.text) != _normalize(initialAbout)) {
      return true;
    }

    if (_normalize(emailController.text) != _normalize(initialEmail)) {
      return true;
    }

    if (_normalize(_buildInternationalPhone()) != _normalize(initialPhone)) {
      return true;
    }

    if (_normalize(websiteController.text) != _normalize(initialWebsite)) {
      return true;
    }

    if (_normalize(selectedGovernorate.value) !=
        _normalize(initialGovernorate)) {
      return true;
    }

    if (_normalize(addressController.text) != _normalize(initialAddress)) {
      return true;
    }

    if (_normalize(selectedType.value) != _normalize(initialOrganizationType)) {
      return true;
    }

    if (_normalize(facebookController.text) != _normalize(initialFacebook)) {
      return true;
    }

    if (_normalize(twitterController.text) != _normalize(initialTwitter)) {
      return true;
    }

    if (_normalize(instagramController.text) != _normalize(initialInstagram)) {
      return true;
    }

    if (_normalize(linkedinController.text) != _normalize(initialLinkedin)) {
      return true;
    }

    if (newLogo != null) {
      return true;
    }

    if (logoRemoved) {
      return true;
    }

    return false;
  }

  String _normalize(String? value) {
    return value?.trim() ?? '';
  }

  void _setupListeners() {
    orgNameController.addListener(_onFieldChanged);
    registrationNoController.addListener(_onFieldChanged);
    aboutController.addListener(_onFieldChanged);

    emailController.addListener(_onFieldChanged);
    phoneController.addListener(_onFieldChanged);
    websiteController.addListener(_onFieldChanged);

    governorateController.addListener(_onFieldChanged);
    addressController.addListener(_onFieldChanged);

    facebookController.addListener(_onFieldChanged);
    twitterController.addListener(_onFieldChanged);
    instagramController.addListener(_onFieldChanged);
    linkedinController.addListener(_onFieldChanged);

    selectedType.addListener(_onFieldChanged);
    selectedGovernorate.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    emit(Changed());
  }

  void onPhoneChanged(PhoneNumber phone) {
    selectedPhone = phone;

    final number = phone.number;

    if (phoneController.text != number) {
      phoneController.value = TextEditingValue(
        text: number,
        selection: TextSelection.collapsed(offset: number.length),
      );
    }

    emit(Changed());
  }

  void onCountryChanged(Country country) {
    selectedCountry = country;
    countryDialCode = country.dialCode;

    selectedPhone = null;

    phoneController.clear();

    emit(Changed());
  }

  String _buildInternationalPhone() {
    final phone = phoneController.text.trim();

    if (phone.isEmpty) {
      return '';
    }

    return '+$countryDialCode$phone';
  }

  void initialize(dynamic user) {
    _fillFromCurrentUser(user);
  }

  void _fillFromCurrentUser(dynamic user) {
    if (user == null) return;

    orgNameController.text = user.name ?? '';
    emailController.text = user.email ?? '';

    _initializePhone(user.phone);

    existingLogoUrl = user.avatar;
    initialLogoUrl = user.avatar;

    final org = user.profile as OrganizationProfileModel?;

    if (org != null) {
      websiteController.text = org.website ?? '';

      governorateController.text = org.state ?? '';

      selectedGovernorate.value = org.state?.isNotEmpty == true
          ? org.state
          : null;

      if (org.state != null && org.state!.isNotEmpty) {
        final exists = governorates.any((item) => item.value == org.state);

        if (!exists) {
          governorates.add(
            DropdownItem(value: org.state!, child: Text(org.state!)),
          );
        }
      }

      addressController.text = org.headquarters ?? '';

      aboutController.text = org.bio ?? '';

      selectedType.value = org.organizationType?.isNotEmpty == true
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

    _saveInitialValues();

    emit(Changed());
  }

  void _initializePhone(String? phone) {
    if (phone == null || phone.isEmpty) {
      countryDialCode = '20';
      phoneController.clear();
      return;
    }

    String normalizedPhone = phone.trim();

    if (normalizedPhone.startsWith('+')) {
      normalizedPhone = normalizedPhone.substring(1);
    }

    if (normalizedPhone.startsWith('20')) {
      countryDialCode = '20';
      phoneController.text = normalizedPhone.substring(2);
    } else {
      countryDialCode = '20';

      if (normalizedPhone.startsWith('0')) {
        phoneController.text = normalizedPhone.substring(1);
      } else {
        phoneController.text = normalizedPhone;
      }
    }
  }

  void _saveInitialValues() {
    initialOrgName = orgNameController.text.trim();
    initialRegistrationNo = registrationNoController.text.trim();
    initialAbout = aboutController.text.trim();

    initialEmail = emailController.text.trim();

    initialPhone = _buildInternationalPhone();

    initialWebsite = websiteController.text.trim();

    initialGovernorate = selectedGovernorate.value?.trim();

    initialAddress = addressController.text.trim();

    initialOrganizationType = selectedType.value?.trim();

    initialFacebook = facebookController.text.trim();

    initialTwitter = twitterController.text.trim();

    initialInstagram = instagramController.text.trim();

    initialLinkedin = linkedinController.text.trim();

    initialLogoUrl = existingLogoUrl;

    newLogo = null;
    logoRemoved = false;
  }

  void selectOrganizationType(String? type) {
    selectedType.value = type;
    emit(Changed());
  }

  void selectGovernorate(String? governorate) {
    selectedGovernorate.value = governorate;

    governorateController.text = governorate ?? '';

    emit(Changed());
  }

  Future<void> pickLogo() async {
    final file = await FilePicker.pickFile(type: FileType.image);

    if (file != null && file.path != null) {
      newLogo = File(file.path!);

      logoRemoved = false;

      emit(Changed());
    }
  }

  void removeLogo() {
    newLogo = null;
    existingLogoUrl = null;
    logoRemoved = true;

    emit(Changed());
  }

  Future<void> submit({
    required BuildContext context,
    required GlobalKey<FormState> formKey,
  }) async {
    if (!hasChanges) {
      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    final accountParam = UpdateOrgAccountParam(
      email: emailController.text.trim(),
      lastName: orgNameController.text.trim(),
      phone: _buildInternationalPhone(),
      avatar: newLogo,
    );

    final organizationParam = UpdateOrgProfileParam(
      website: websiteController.text.trim().isEmpty
          ? null
          : websiteController.text.trim(),
      state: selectedGovernorate.value,
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

    await saveOrgProfile(
      context: context,
      accountParam: accountParam,
      organizationParam: organizationParam,
    );
  }

  Future<void> saveOrgProfile({
    required BuildContext context,
    required UpdateOrgAccountParam accountParam,
    required UpdateOrgProfileParam organizationParam,
  }) async {
    if (!hasChanges) {
      return;
    }

    emit(Loading());

    final accountResult = await repo.updateAccount(accountParam);

    if (accountResult.isLeft()) {
      emit(Error());

      accountResult.fold((l) => AppToast.error(l.errMessage), (r) {});

      return;
    }

    final organizationResult = await repo.updateOrganizationProfile(
      organizationParam,
    );

    if (organizationResult.isLeft()) {
      emit(Error());

      organizationResult.fold((l) => AppToast.error(l.errMessage), (r) {});

      return;
    }

    if (context.mounted) {
      await AppCubit.get(context).getUser();
    }

    emit(Success());

    AppToast.success(
      'volunteer.edit_profile.profile_updated_successfully'.tr(),
    );

    if (context.mounted) {
      AppNavigator.pop();
    }
  }

  @override
  Future<void> close() {
    orgNameController.dispose();
    registrationNoController.dispose();
    aboutController.dispose();

    emailController.dispose();
    phoneController.dispose();
    websiteController.dispose();

    governorateController.dispose();
    addressController.dispose();

    facebookController.dispose();
    twitterController.dispose();
    instagramController.dispose();
    linkedinController.dispose();

    selectedType.dispose();
    selectedGovernorate.dispose();

    return super.close();
  }
}

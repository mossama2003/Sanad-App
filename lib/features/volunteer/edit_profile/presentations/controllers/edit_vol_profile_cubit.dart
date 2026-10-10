import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../../../core/shared/controllers/user/app_cubit.dart';
import '../../../../../core/shared/models/city_model.dart';
import '../../../../../core/shared/models/governorate_model.dart';
import '../../../../shared/auth/data/models/user_profile_model.dart';
import '../../data/params/update_vol_profile_param.dart';
import '../../../../../core/helper/app_toast.dart';
import '../../data/repos/edit_vol_profile_repo.dart';

part 'edit_vol_profile_state.dart';

class EditVolProfileCubit extends Cubit<EditVolProfileState> {
  EditVolProfileCubit(this.repo) : super(Initial());

  final EditVolProfileRepo repo;

  static EditVolProfileCubit get(BuildContext context) =>
      BlocProvider.of<EditVolProfileCubit>(context);

  // ============================================================
  // Controllers
  // ============================================================

  final TextEditingController fullNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  final TextEditingController professionController = TextEditingController();

  final TextEditingController emergencyExperienceController =
      TextEditingController();

  // ============================================================
  // Initial Values
  // ============================================================

  String initialFullName = '';

  String initialEmail = '';

  String initialPhone = '';

  String initialAddress = '';

  String initialProfession = '';

  String initialEmergencyExperience = '';

  String initialFullPhoneNumber = '';

  String? initialAvatarUrl;

  String? initialGovernorateId;

  String? initialCityId;

  String? initialBloodType;

  String? initialCountry;

  bool initialIsAvailable = false;

  List<String> initialLanguages = [];

  List<String> initialSkills = [];

  // ============================================================
  // Has Changes
  // ============================================================

  bool get hasChanges {
    // ---------------- TEXT FIELDS ----------------

    if (emailController.text.trim() != initialEmail) {
      return true;
    }

    if (phoneController.text.trim() != initialPhone) {
      return true;
    }

    if (addressController.text.trim() != initialAddress) {
      return true;
    }

    if (professionController.text.trim() != initialProfession) {
      return true;
    }

    if (emergencyExperienceController.text.trim() !=
        initialEmergencyExperience) {
      return true;
    }

    // ---------------- PHONE ----------------

    if (fullPhoneNumber != initialFullPhoneNumber) {
      return true;
    }

    // ---------------- AVATAR ----------------

    if (newAvatar != null) {
      return true;
    }

    if (avatarRemoved) {
      return true;
    }

    // ---------------- LOCATION ----------------

    if (selectedGov.value?.id != initialGovernorateId) {
      return true;
    }

    if (selectedCity.value?.id != initialCityId) {
      return true;
    }

    if (selectedCountryName.value != initialCountry) {
      return true;
    }

    // ---------------- BLOOD ----------------

    if (selectedBloodType.value != initialBloodType) {
      return true;
    }

    // ---------------- VEHICLE ----------------

    if (isAvailable != initialIsAvailable) {
      return true;
    }

    // ---------------- LANGUAGES ----------------

    if (!_listEquals(selectedLanguages, initialLanguages)) {
      return true;
    }

    // ---------------- SKILLS ----------------

    if (!_listEquals(selectedSkills, initialSkills)) {
      return true;
    }

    return false;
  }

  bool _listEquals(List<String> first, List<String> second) {
    return first.toSet().containsAll(second) &&
        second.toSet().containsAll(first);
  }

  // ============================================================
  // Controllers Listeners
  // ============================================================

  void _onFieldChanged() {
    emit(Changed());
  }

  void _setupListeners() {
    emailController.addListener(_onFieldChanged);
    phoneController.addListener(_onFieldChanged);
    addressController.addListener(_onFieldChanged);
    professionController.addListener(_onFieldChanged);
    emergencyExperienceController.addListener(_onFieldChanged);
  }

  // ============================================================
  // Phone
  // ============================================================

  Country? selectedPhoneCountry;

  PhoneNumber? selectedPhone;

  String countryDialCode = '20';

  String fullPhoneNumber = '';

  void onPhoneChanged(PhoneNumber phone) {
    selectedPhone = phone;

    phoneController.text = phone.number;

    fullPhoneNumber = phone.completeNumber;

    emit(Changed());
  }

  void onCountryChanged(Country country) {
    selectedPhoneCountry = country;

    countryDialCode = country.dialCode;

    phoneController.clear();

    selectedPhone = null;

    fullPhoneNumber = '';

    emit(Changed());
  }

  // ============================================================
  // Avatar
  // ============================================================

  String? existingAvatarUrl;

  File? newAvatar;

  bool avatarRemoved = false;

  Future<void> pickAvatar() async {
    final file = await FilePicker.pickFile(type: FileType.image);

    if (file == null || file.path == null) {
      return;
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: file.path!,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Profile Photo',
          lockAspectRatio: true,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
        IOSUiSettings(
          title: 'Crop Profile Photo',
          aspectRatioLockEnabled: true,
          resetAspectRatioEnabled: false,
          aspectRatioPresets: [CropAspectRatioPreset.square],
        ),
      ],
    );

    if (croppedFile == null) {
      return;
    }

    newAvatar = File(croppedFile.path);

    avatarRemoved = false;

    emit(Changed());
  }

  void removeAvatar() {
    newAvatar = null;

    avatarRemoved = true;

    emit(Changed());
  }

  // ============================================================
  // Location
  // ============================================================

  final ValueNotifier<GovernorateModel?> selectedGov = ValueNotifier(null);

  final ValueNotifier<CityModel?> selectedCity = ValueNotifier(null);

  final ValueNotifier<String?> selectedBloodType = ValueNotifier(null);

  final ValueNotifier<String?> selectedCountryName = ValueNotifier<String?>(
    'Egypt',
  );

  List<GovernorateModel> governorates = [];

  List<CityModel> cities = [];

  List<CityModel> filteredCities = [];

  static const List<String> countries = ['Egypt'];

  static const List<String> bloodTypes = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  Future<void> loadLocationData() async {
    try {
      final govString = await rootBundle.loadString(
        'assets/data/governorates.json',
      );

      final cityString = await rootBundle.loadString('assets/data/cities.json');

      final govJson = json.decode(govString);

      final cityJson = json.decode(cityString);

      // ---------------- GOVERNORATES ----------------

      final List govList = govJson is List ? govJson : govJson['data'];

      governorates = govList.map((e) => GovernorateModel.fromJson(e)).toList();

      // ---------------- CITIES ----------------

      final List cityList = cityJson is List ? cityJson : cityJson['data'];

      cities = cityList.map((e) => CityModel.fromJson(e)).toList();

      // Match existing location
      _matchExistingLocation();

      // IMPORTANT:
      // Save initial location values AFTER matching them.
      _saveInitialLocationValues();

      emit(Changed());
    } catch (e) {
      debugPrint('Load location error => $e');

      AppToast.error(e.toString());

      emit(Error());
    }
  }

  void selectGovernorate(GovernorateModel governorate) {
    selectedGov.value = governorate;

    selectedCity.value = null;

    filteredCities = cities
        .where((city) => city.governorateId == governorate.id)
        .toList();

    emit(Changed());
  }

  void selectCity(CityModel city) {
    selectedCity.value = city;

    emit(Changed());
  }

  void selectBloodType(String? bloodType) {
    selectedBloodType.value = bloodType;

    emit(Changed());
  }

  void selectCountry(String? country) {
    selectedCountryName.value = country;

    emit(Changed());
  }

  void _matchExistingLocation() {
    final user = _getCurrentUser();

    final volunteer = user?.profile as VolunteerProfileModel?;

    if (volunteer == null) return;

    // ---------------- GOVERNORATE ----------------

    final stateName = volunteer.state?.trim();

    if (stateName != null && stateName.isNotEmpty) {
      final matchedGov = governorates.firstWhereOrNull(
        (gov) => gov.nameEn.trim().toLowerCase() == stateName.toLowerCase(),
      );

      if (matchedGov != null) {
        selectedGov.value = matchedGov;

        filteredCities = cities
            .where((city) => city.governorateId == matchedGov.id)
            .toList();

        // ---------------- CITY ----------------

        final cityName = volunteer.city?.trim();

        if (cityName != null && cityName.isNotEmpty) {
          final matchedCity = filteredCities.firstWhereOrNull(
            (city) =>
                city.nameEn.trim().toLowerCase() == cityName.toLowerCase(),
          );

          selectedCity.value = matchedCity;
        }
      }
    }
  }

  void _saveInitialLocationValues() {
    initialGovernorateId = selectedGov.value?.id;

    initialCityId = selectedCity.value?.id;

    initialCountry = selectedCountryName.value;
  }

  // ============================================================
  // Languages
  // ============================================================

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

  List<String> selectedLanguages = [];

  List<String> get unSelectedLanguages {
    return allLanguages
        .where((language) => !selectedLanguages.contains(language))
        .toList();
  }

  void addLanguage(String language) {
    if (!selectedLanguages.contains(language)) {
      selectedLanguages.add(language);

      emit(Changed());
    }
  }

  void removeLanguage(String language) {
    selectedLanguages.remove(language);

    emit(Changed());
  }

  // ============================================================
  // Skills
  // ============================================================

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

  List<String> selectedSkills = [];

  List<String> get unSelectedSkills {
    return allSkills.where((skill) => !selectedSkills.contains(skill)).toList();
  }

  void addSkill(String skill) {
    if (!selectedSkills.contains(skill)) {
      selectedSkills.add(skill);

      emit(Changed());
    }
  }

  void removeSkill(String skill) {
    selectedSkills.remove(skill);

    emit(Changed());
  }

  // ============================================================
  // Vehicle
  // ============================================================

  bool isAvailable = false;

  void changeVehicleAvailability(bool value) {
    isAvailable = value;

    emit(Changed());
  }

  // ============================================================
  // Fill data
  // ============================================================

  void fillFromCurrentUser() {
    final user = _getCurrentUser();

    if (user == null) return;

    // ---------------- ACCOUNT ----------------

    fullNameController.text = user.name ?? '';

    emailController.text = user.email ?? '';

    // ---------------- PHONE ----------------

    final phone = user.phone ?? '';

    if (phone.startsWith('+20')) {
      phoneController.text = phone.substring(3);

      fullPhoneNumber = phone;
    } else {
      phoneController.text = phone;

      fullPhoneNumber = phone;
    }

    // ---------------- AVATAR ----------------

    existingAvatarUrl = user.avatar;

    // ---------------- VOLUNTEER ----------------

    final volunteer = user.profile as VolunteerProfileModel?;

    if (volunteer == null) return;

    professionController.text = volunteer.profession ?? '';

    final bloodGroup = volunteer.bloodGroup;

    selectedBloodType.value = bloodTypes.contains(bloodGroup)
        ? bloodGroup
        : null;

    emergencyExperienceController.text = (volunteer.emergencyExperience ?? 0)
        .toString();

    addressController.text = volunteer.address ?? '';

    selectedCountryName.value = volunteer.country?.isNotEmpty == true
        ? volunteer.country
        : 'Egypt';

    isAvailable = volunteer.ownVehicle ?? false;

    selectedLanguages = List<String>.from(volunteer.languages ?? []);

    selectedSkills = List<String>.from(volunteer.skills ?? []);

    // Save initial values that don't depend
    // on governorate/city matching.
    _saveInitialValues();

    emit(Changed());
  }

  void _saveInitialValues() {
    initialFullName = fullNameController.text.trim();

    initialEmail = emailController.text.trim();

    initialPhone = phoneController.text.trim();

    initialAddress = addressController.text.trim();

    initialProfession = professionController.text.trim();

    initialEmergencyExperience = emergencyExperienceController.text.trim();

    initialFullPhoneNumber = fullPhoneNumber;

    initialAvatarUrl = existingAvatarUrl;

    initialBloodType = selectedBloodType.value;

    initialCountry = selectedCountryName.value;

    initialIsAvailable = isAvailable;

    initialLanguages = List<String>.from(selectedLanguages);

    initialSkills = List<String>.from(selectedSkills);

    // Avatar is initially unchanged.
    newAvatar = null;

    avatarRemoved = false;
  }

  // ============================================================
  // Initialize
  // ============================================================

  dynamic _currentUser;

  bool _initialized = false;

  void initialize(dynamic user) {
    if (_initialized) return;

    _initialized = true;

    _currentUser = user;

    _setupListeners();

    fillFromCurrentUser();

    loadLocationData();
  }

  dynamic _getCurrentUser() {
    return _currentUser;
  }

  // ============================================================
  // Submit
  // ============================================================

  Future<void> submit({required BuildContext context}) async {
    // Safety check
    if (!hasChanges) {
      return;
    }

    final accountParam = UpdateVolAccountParam(
      email: emailController.text.trim(),

      lastName: fullNameController.text.trim(),

      phone: fullPhoneNumber.isNotEmpty
          ? fullPhoneNumber
          : phoneController.text.trim(),

      avatar: newAvatar,
    );

    final emergencyText = emergencyExperienceController.text.trim();

    final volunteerParam = UpdateVolProfileParam(
      profession: professionController.text.trim().isEmpty
          ? null
          : professionController.text.trim(),

      bloodGroup: selectedBloodType.value,

      emergencyExperience: emergencyText.isEmpty
          ? null
          : int.tryParse(emergencyText),

      ownVehicle: isAvailable,

      country: selectedCountryName.value ?? 'Egypt',

      state: selectedGov.value?.nameEn,

      city: selectedCity.value?.nameEn,

      address: addressController.text.trim().isEmpty
          ? null
          : addressController.text.trim(),

      languages: selectedLanguages,

      skills: selectedSkills,
    );

    await saveVolProfile(
      context: context,
      accountParam: accountParam,
      volunteerParam: volunteerParam,
    );
  }

  // ============================================================
  // API
  // ============================================================

  Future<void> saveVolProfile({
    required BuildContext context,
    required UpdateVolAccountParam accountParam,
    required UpdateVolProfileParam volunteerParam,
  }) async {
    emit(Loading());

    final accountResult = await repo.updateAccount(accountParam);

    if (accountResult.isLeft()) {
      emit(Error());

      accountResult.fold((l) => AppToast.error(l.errMessage), (r) {});

      return;
    }

    final volunteerResult = await repo.updateVolunteerProfile(volunteerParam);

    if (volunteerResult.isLeft()) {
      emit(Error());

      volunteerResult.fold((l) => AppToast.error(l.errMessage), (r) {});

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

  // ============================================================
  // Dispose
  // ============================================================

  @override
  Future<void> close() {
    emailController.removeListener(_onFieldChanged);

    phoneController.removeListener(_onFieldChanged);

    addressController.removeListener(_onFieldChanged);

    professionController.removeListener(_onFieldChanged);

    emergencyExperienceController.removeListener(_onFieldChanged);

    fullNameController.dispose();

    emailController.dispose();

    phoneController.dispose();

    addressController.dispose();

    professionController.dispose();

    emergencyExperienceController.dispose();

    selectedGov.dispose();

    selectedCity.dispose();

    selectedBloodType.dispose();

    selectedCountryName.dispose();

    return super.close();
  }
}

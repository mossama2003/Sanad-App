import 'dart:convert';
import 'dart:io';

import 'package:sanad_app/features/shared/auth/data/repos/volunteer/volunteer_repo.dart';
import 'package:sanad_app/features/shared/auth/data/params/volunteer_sign_up_param.dart';
import 'package:sanad_app/features/shared/auth/data/models/skills_model.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../../core/helper/app_navigator.dart';
import '../../../../../../core/helper/app_toast.dart';
import '../../../data/models/governorate_model.dart';
import '../../sign_in/screens/sign_in_screen.dart';
import '../../../data/models/city_model.dart';

part 'volunteer_sign_up_state.dart';

class VolunteerSignUpCubit extends Cubit<VolunteerSignUpState> {
  VolunteerSignUpCubit(this.repo) : super(SignUpInitial());

  VolunteerRepo repo;

  static VolunteerSignUpCubit get(BuildContext context) =>
      BlocProvider.of(context);

  File? avatar;
  final ImagePicker _picker = ImagePicker();

  // ===================== Phone Number =====================
  Country? selectedCountry;
  PhoneNumber? selectedPhone;

  // ===================== Skills =====================
  List<SkillsModel> interests = [];
  List<int> selectedInterests = [];

  // ===================== Location =====================
  List<GovernorateModel> governorates = [];
  List<CityModel> cities = [];
  List<CityModel> filteredCities = [];

  final ValueNotifier<GovernorateModel?> selectedGov =
      ValueNotifier<GovernorateModel?>(null);

  final ValueNotifier<CityModel?> selectedCity = ValueNotifier<CityModel?>(
    null,
  );

  // ===================== UI States =====================
  bool obscureConfirmedPassword = true;
  bool obscurePassword = true;
  File? nationalIdFrontImage;
  File? nationalIdBackImage;
  bool showTexts = false;
  bool showButtons = false;
  bool showField = false;
  bool acceptTerms = false;

  int selectedGender = 0;

  final ValueNotifier<String?> selectedBloodType = ValueNotifier<String?>('A+');

  final bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  // ===================== Form =====================
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();
  final birthdayController = TextEditingController();
  final bloodTypeController = TextEditingController();
  final skillsController = TextEditingController();
  final nationalIdNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String countryDialCode = "20";

  void onPhoneChanged(PhoneNumber phone) {
    selectedPhone = phone;
    phoneController.text = phone.number;
  }

  void onCountryChanged(Country country) {
    selectedCountry = country;
    countryDialCode = country.dialCode;
    phoneController.clear();
    selectedPhone = null;
  }

  // ===================== Pick Avatar =====================
  Future<void> pickAvatar() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    avatar = File(image.path);

    emit(UpdateVolunteerImageState());
  }

  void removeAvatar() {
    avatar = null;
    emit(UpdateVolunteerImageState());
  }

  // ===================== Skills =====================
  void updateInterests(List<int> interestsList) {
    selectedInterests = interestsList;
    emit(UpdateInterestsState());
  }

  // ===================== Password =====================
  void updateObscurePassword() {
    obscurePassword = !obscurePassword;
    emit(UpdateObscurePassword());
  }

  void updateObscureConfirmedPassword() {
    obscureConfirmedPassword = !obscureConfirmedPassword;
    emit(UpdateObscureConfirmedPassword());
  }

  // ===================== Governorate =====================
  void selectGovernorate(GovernorateModel gov) {
    selectedGov.value = gov;

    selectedCity.value = null;
    filteredCities = [];

    filteredCities = cities.where((c) => c.governorateId == gov.id).toList();

    emit(UpdateLocationState());
  }

  // ===================== City =====================
  void selectCity(CityModel city) {
    selectedCity.value = city;
    emit(UpdateLocationState());
  }

  // ===================== Load Data =====================
  Future<void> loadLocationData() async {
    emit(Loading());

    try {
      final govString = await rootBundle.loadString(
        'assets/data/governorates.json',
      );

      final cityString = await rootBundle.loadString('assets/data/cities.json');

      final govJson = json.decode(govString);
      final cityJson = json.decode(cityString);

      // ================= GOV =================
      final List govList = govJson is List ? govJson : govJson['data'];

      governorates = govList.map((e) => GovernorateModel.fromJson(e)).toList();

      // ================= CITY =================
      final List cityList = cityJson is List ? cityJson : cityJson['data'];

      cities = cityList.map((e) => CityModel.fromJson(e)).toList();

      emit(Success());
    } catch (e) {
      emit(Error());
      AppToast.error(e.toString());
    }
  }

  // ===================== Upload National ID =====================
  Future<void> pickNationalIdImage({
    required BuildContext context,
    required bool isFront,
  }) async {
    try {
      final source = await _showNationalIdSourceDialog(context);

      if (source == null) return;

      final XFile? file = await _picker.pickImage(source: source);

      if (file == null) return;

      File image = File(file.path);

      // ===================== Crop =====================
      final croppedImage = await _cropNationalIdImage(image);

      if (croppedImage == null) return;

      image = croppedImage;

      // ===================== Compress =====================
      final compressed = await _compressNationalIdImage(image);

      if (compressed != null) {
        image = compressed;
      }

      // ===================== Save Image =====================
      if (isFront) {
        nationalIdFrontImage = image;
      } else {
        nationalIdBackImage = image;
      }

      emit(UpdateNationalIDState());
    } catch (e) {
      debugPrint("Image error => $e");
    }
  }

  Future<ImageSource?> _showNationalIdSourceDialog(BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Image'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.camera),
              child: const Text('Camera'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, ImageSource.gallery),
              child: const Text('Gallery'),
            ),
          ],
        );
      },
    );
  }

  Future<File?> _cropNationalIdImage(File file) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,

        aspectRatio: const CropAspectRatio(ratioX: 1.58, ratioY: 1),

        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop National ID',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            hideBottomControls: false,
          ),

          IOSUiSettings(
            title: 'Crop National ID',
            aspectRatioLockEnabled: true,
          ),
        ],
      );

      if (croppedFile == null) return null;

      return File(croppedFile.path);
    } catch (e) {
      debugPrint("Crop error => $e");
      return null;
    }
  }

  Future<File?> _compressNationalIdImage(File file) async {
    final path = file.path;

    final result = await FlutterImageCompress.compressAndGetFile(
      path,
      '${path}_compressed.jpg',
      quality: 70,
    );

    if (result == null) return null;

    return File(result.path);
  }

  void removeNationalIdFront() {
    nationalIdFrontImage = null;
    emit(UpdateNationalIDState());
  }

  void removeNationalIdBack() {
    nationalIdBackImage = null;
    emit(UpdateNationalIDState());
  }

  // ===================== SIGN UP =====================
  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    emit(Loading());

    if (nationalIdFrontImage == null || nationalIdBackImage == null) {
      AppToast.error('volunteer.sign_up.please_upload_both_ids'.tr());
      return;
    }

    final formattedPhone = "+$countryDialCode${phoneController.text.trim()}";

    final birthDate = DateFormat('dd/MM/yyyy').parse(birthdayController.text);

    final formattedDob = DateFormat('yyyy-MM-dd').format(birthDate);

    final api = await repo.volunteerSignUp(
      VolunteerParam(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: formattedPhone,
        password: passwordController.text,
        gender: selectedGender == 0 ? 'male' : 'female',
        bloodGroup: selectedBloodType.value ?? '',
        dob: formattedDob,
        nid: nationalIdNumberController.text,
        interests: selectedInterests,
        state: selectedGov.value?.nameEn ?? '',
        city: selectedCity.value?.nameEn ?? '',
        country: 'Egypt',
        address: locationController.text.trim(),
        attachments: [nationalIdFrontImage!, nationalIdBackImage!],
        avatar: avatar,
      ),
    );

    api.fold(
      (l) {
        emit(Error());
        AppToast.error(l.errMessage);
      },
      (r) {
        emit(Success());
        AppToast.success('volunteer.sign_up.account_created'.tr());
        AppNavigator.replace(SignInScreen());
      },
    );
  }

  // ===================== INTERESTS =====================
  Future<void> getInterests() async {
    emit(Loading());

    final result = await repo.getVolunteerSkills();

    result.fold(
      (failure) {
        emit(Error());
        AppToast.error(failure.errMessage);
      },
      (data) {
        interests = data;
        emit(Success());
      },
    );
  }
}

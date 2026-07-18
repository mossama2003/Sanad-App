import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../../core/helper/app_navigator.dart';
import '../../../../../../core/helper/app_toast.dart';
import '../../../../../../core/shared/models/governorate_model.dart';
import '../../../data/params/organization_sign_up_param.dart';
import '../../../data/repos/organization/organization_repo.dart';
import '../../sign_in/screens/sign_in_screen.dart';

part 'organization_sign_up_state.dart';

class OrganizationSignUpCubit extends Cubit<OrganizationSignUpState> {
  OrganizationSignUpCubit(this.repo) : super(OrganizationSignUpInitial());

  final OrganizationRepo repo;

  static OrganizationSignUpCubit get(BuildContext context) =>
      BlocProvider.of(context);

  // ===================== Phone Number =====================
  Country? selectedCountry;
  PhoneNumber? selectedPhone;

  // ===================== FORM =====================
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final websiteController = TextEditingController();
  final headquartersController = TextEditingController();
  final addressController = TextEditingController();

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

  List<String> branches = [];

  File? avatar;
  List<File> attachments = [];
  final ImagePicker _picker = ImagePicker();

  List<GovernorateModel> governorates = [];

  final ValueNotifier<GovernorateModel?> selectedGov =
      ValueNotifier<GovernorateModel?>(null);

  bool obscurePassword = true;
  bool obscureConfirmedPassword = true;

  // ===================== Pick Logo =====================

  Future<void> pickLogo() async {
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    avatar = File(image.path);

    emit(UpdateOrganizationLogoState());
  }

  void removeLogo() {
    avatar = null;
    emit(UpdateOrganizationLogoState());
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
    emit(UpdateLocationState());
  }

  // ===================== Load Data =====================
  Future<void> loadLocationData() async {
    emit(Loading());

    try {
      final govString = await rootBundle.loadString(
        'assets/data/governorates.json',
      );

      final govJson = json.decode(govString);

      // ================= GOV =================
      final List govList = govJson is List ? govJson : govJson['data'];

      governorates = govList.map((e) => GovernorateModel.fromJson(e)).toList();

      emit(Success());
    } catch (e) {
      emit(Error());
      AppToast.error(e.toString());
    }
  }

  // ===================== Pick Documents =====================
  Future<void> pickDocuments() async {
    final files = await openFiles(
      acceptedTypeGroups: [
        XTypeGroup(
          label: 'Verification Documents',
          extensions: ['pdf', 'jpg', 'jpeg', 'png'],
          uniformTypeIdentifiers: ['public.pdf', 'public.jpeg', 'public.png'],
        ),
      ],
    );

    if (files.isEmpty) return;

    attachments = files.map((file) => File(file.path)).toList();

    emit(UpdateAttachmentsState());
  }

  void removeAttachment(File file) {
    attachments.remove(file);
    emit(UpdateAttachmentsState());
  }

  void removeAttachments() {
    attachments.clear();
    emit(UpdateAttachmentsState());
  }

  // ===================== SIGN UP =====================
  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    if (avatar == null) {
      AppToast.error('organization.sign_up.avatar_required'.tr());
      return;
    }

    emit(Loading());

    final formattedPhone = "+$countryDialCode${phoneController.text.trim()}";

    final api = await repo.signUpOrganization(
      OrganizationParam(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: formattedPhone,
        avatar: avatar!,
        attachments: attachments,
        website: websiteController.text.trim(),
        state: selectedGov.value?.nameEn ?? '',
        headquarters: headquartersController.text.trim(),
      ),
    );

    api.fold(
      (l) {
        emit(Error());
        AppToast.error(l.errMessage);
      },
      (r) {
        emit(Success());
        AppToast.success("organization.sign_up.created_account".tr());
        AppNavigator.replace(const SignInScreen());
      },
    );
  }
}

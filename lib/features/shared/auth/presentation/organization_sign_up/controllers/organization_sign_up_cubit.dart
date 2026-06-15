import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helper/app_navigator.dart';
import '../../../../../../core/helper/app_toast.dart';
import '../../../data/params/organization_sign_up_param.dart';
import '../../../data/repos/organization/organization_repo.dart';
import '../../sign_in/screens/sign_in_screen.dart';

part 'organization_sign_up_state.dart';

class OrganizationSignUpCubit extends Cubit<OrganizationSignUpState> {
  OrganizationSignUpCubit(this.repo) : super(OrganizationSignUpInitial());

  final OrganizationRepo repo;

  static OrganizationSignUpCubit get(BuildContext context) =>
      BlocProvider.of(context);

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

  List<String> branches = [];

  File? avatar;
  List<File> attachments = [];

  bool obscurePassword = true;
  bool obscureConfirmedPassword = true;

  // ===================== Password =====================
  void updateObscurePassword() {
    obscurePassword = !obscurePassword;
    emit(UpdateObscurePassword());
  }

  void updateObscureConfirmedPassword() {
    obscureConfirmedPassword = !obscureConfirmedPassword;
    emit(UpdateObscureConfirmedPassword());
  }

  // ===================== SIGN UP =====================
  Future<void> signUp() async {
    if (!formKey.currentState!.validate()) return;

    if (avatar == null) {
      AppToast.error("Avatar is required");
      return;
    }

    emit(Loading());

    final api = await repo.signUpOrganization(
      OrganizationParam(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phone: phoneController.text.trim(),
        avatar: avatar!,
        attachments: attachments,
        website: websiteController.text.trim(),
        headquarters: headquartersController.text.trim(),
        address: addressController.text.trim(),
        branches: branches,
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

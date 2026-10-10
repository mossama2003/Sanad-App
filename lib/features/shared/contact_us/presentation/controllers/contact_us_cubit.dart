import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad_app/core/helper/app_navigator.dart';

import '../../../../../core/helper/app_toast.dart';
import '../../data/repos/contact_us_repo.dart';

part 'contact_us_state.dart';

class ContactUsCubit extends Cubit<ContactUsState> {
  ContactUsCubit(this.repo) : super(ContactUsInitial());

  final ContactUsRepo repo;

  static ContactUsCubit get(BuildContext context) =>
      BlocProvider.of<ContactUsCubit>(context);

  // ===================== Controllers =====================

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // ===================== Categories =====================

  static const List<String> categories = [
    'general_inquiry',
    'technical_support',
    'partnership',
    'report_issue',
  ];

  final ValueNotifier<String?> selectedCategory = ValueNotifier<String?>(
    'general_inquiry',
  );

  void changeCategory(String? value) {
    if (value == null || !categories.contains(value)) return;

    selectedCategory.value = value;
  }

  // ===================== Validation =====================

  String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'shared.contact_us.validation.required'.tr();
    }

    return null;
  }

  String? validateEmail(String? value) {
    final requiredError = validateRequired(value);

    if (requiredError != null) return requiredError;

    final emailRegex = RegExp(
      r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
    );

    if (!emailRegex.hasMatch(value!.trim())) {
      return 'shared.contact_us.validation.invalid_email'.tr();
    }

    return null;
  }

  String? validatePhone(String? value) {
    final requiredError = validateRequired(value);

    if (requiredError != null) return requiredError;

    final phone = value!.trim();
    final digits = phone.replaceAll(RegExp(r'\D'), '');

    if (!RegExp(r'^\+?[0-9\s()-]+$').hasMatch(phone) ||
        digits.length < 7 ||
        digits.length > 15) {
      return 'shared.contact_us.validation.invalid_phone'.tr();
    }

    return null;
  }

  // ===================== Submit =====================

  Future<void> submitContactUs() async {
    if (isClosed || state is ContactUsLoading) return;

    if (!(formKey.currentState?.validate() ?? false)) return;

    // Ensure a category is selected.
    if (selectedCategory.value == null ||
        !categories.contains(selectedCategory.value)) {
      AppToast.error('shared.contact_us.validation.required'.tr());
      return;
    }

    emit(ContactUsLoading());

    final comment =
        '''
Name: ${nameController.text.trim()}
Email: ${emailController.text.trim()}
Phone: ${phoneController.text.trim()}
Category: ${selectedCategory.value}

Message:
${messageController.text.trim()}
'''
            .trim();

    final result = await repo.submitContactUs(comment: comment);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(ContactUsError());
        AppToast.error(failure.errMessage);
      },
      (_) {
        clearForm();
        emit(ContactUsSuccess());
        AppToast.success('shared.contact_us.success'.tr());
        AppNavigator.pop();
      },
    );
  }

  // ===================== Clear Form =====================

  void clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    messageController.clear();

    selectedCategory.value = categories.first;

    formKey.currentState?.reset();
  }

  // ===================== Dispose =====================

  @override
  Future<void> close() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    selectedCategory.dispose();

    return super.close();
  }
}

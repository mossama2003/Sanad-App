import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:shuaa_alamal/core/network/local/cache/cache_helper.dart';

import '../../constant/app_size.dart';
import '../../style/app_colors.dart';

class CustomFieldOtp extends StatelessWidget {
  const CustomFieldOtp({
    super.key,
    this.validator,
    this.onChanged,
    required this.onComplete,
    required this.controller,
    required this.keyboardType,
  });

  final Function(String)? onChanged;
  final VoidCallback onComplete;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  bool get _langIsAr => CacheHelper.get(CacheKeys.lang) == CacheKeys.langAr;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: PinCodeTextField(
        length: 6,
        appContext: context,
        validator: validator,
        controller: controller,
        enablePinAutofill: true,
        textStyle: const TextStyle(
          color: AppColors.primary,
        ),
        pinTheme: PinTheme(
          borderWidth: 1,
          errorBorderWidth: 1,
          activeBorderWidth: 1,
          inactiveBorderWidth: 1,
          selectedBorderWidth: 1,
          shape: PinCodeFieldShape.box,
          fieldWidth: AppSize.getSize(48),
          fieldHeight: AppSize.getSize(48),
          fieldOuterPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
          selectedColor: AppColors.primary,
          inactiveColor: AppColors.buttonTertiary,
          activeFillColor: AppColors.buttonTertiary,
          inactiveFillColor: AppColors.buttonTertiary,
          selectedFillColor: AppColors.buttonTertiary,
          errorBorderColor: AppColors.buttonTertiary,
          borderRadius: BorderRadius.circular(AppSize.getSize(8)),
        ),
        keyboardType: keyboardType,
        autoDisposeControllers: false,
        cursorColor: AppColors.primary,
        beforeTextPaste: (text) => true,
        onChanged: onChanged,
        onCompleted: (v) => onComplete(),
        animationType: AnimationType.fade,
        backgroundColor: Colors.transparent,
        errorTextDirection: _langIsAr ? TextDirection.rtl : TextDirection.ltr,
        errorTextSpace: AppSize.getHeight(30),
        autovalidateMode: AutovalidateMode.disabled,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

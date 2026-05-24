import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';

import '../../network/local/cache/cache_helper.dart';
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
    final pinController = PinInputController();

    pinController.setText(controller.text);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MaterialPinField(
            length: 6,
            pinController: pinController,
            keyboardType: keyboardType,
            enableAutofill: true,
            autoDismissKeyboard: true,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,

            theme: MaterialPinTheme(
              cellSize: Size(AppSize.getSize(48), AppSize.getSize(48)),
              borderRadius: BorderRadius.circular(AppSize.getSize(8)),
              borderWidth: 1,
              focusedBorderWidth: 1,
              borderColor: AppColors.buttonTertiary,
              focusedBorderColor: AppColors.primary,
              fillColor: AppColors.buttonTertiary,
              focusedFillColor: AppColors.buttonTertiary,
              errorColor: AppColors.buttonTertiary,
              shape: MaterialPinShape.outlined,
              textStyle: const TextStyle(color: AppColors.primary),
            ),

            onChanged: (value) {
              controller.text = value;
              onChanged?.call(value);
            },

            onCompleted: (_) {
              final error = validator?.call(controller.text);

              if (error == null) {
                onComplete();
              }
            },

            errorText: validator?.call(controller.text),

            errorTextStyle: TextStyle(
              color: Colors.red,
              fontSize: AppSize.font(12),
            ),
          ),
        ],
      ),
    );
  }
}

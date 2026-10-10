import 'package:easy_localization/easy_localization.dart' as lang;
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:flutter_intl_phone_field/country_picker_dialog.dart';
import 'package:flutter_intl_phone_field/phone_number.dart';
import 'package:flutter_intl_phone_field/countries.dart';
import 'package:flutter/material.dart';

import '../../constant/app_size.dart';
import '../../network/local/cache/cache_helper.dart';
import '../../style/app_text_style.dart';
import '../../validator/app_validators.dart';
import '../../style/app_colors.dart';

class CustomFieldPhone extends StatelessWidget {
  const CustomFieldPhone({
    super.key,
    this.title,
    this.titleSize,
    this.titleColor,
    this.hintText,
    this.helperText,
    this.initialCountryCode,
    this.selectedPhone,
    this.onPhoneChanged,
    this.selectedCountry,
    this.onCountryChanged,
    required this.controller,
  });

  final String? title;
  final double? titleSize;
  final Color? titleColor;

  final String? hintText;
  final String? helperText;
  final String? initialCountryCode;
  final Country? selectedCountry;
  final PhoneNumber? selectedPhone;

  final TextEditingController controller;

  final Function(Country)? onCountryChanged;
  final Function(PhoneNumber)? onPhoneChanged;

  @override
  Widget build(BuildContext context) {
    final lang = CacheHelper.get(CacheKeys.lang);

    final theme = Theme.of(context);

    final textColor = theme.textTheme.bodyMedium?.color ?? AppColors.inputText;

    final hintColor = theme.brightness == Brightness.dark
        ? AppColors.grey400
        : AppColors.grey;

    final borderColor = theme.dividerColor;
    final errorColor = theme.colorScheme.error;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(
              color: titleColor ?? AppColors.textSecondary,
              fontSize: titleSize ?? AppSize.font(12),
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: AppSize.getHeight(6)),
        ],

        Directionality(
          textDirection: TextDirection.ltr,
          child: IntlPhoneField(
            languageCode: lang,

            controller: controller,

            initialCountryCode: initialCountryCode ?? "EG",

            style: TextStyle(
              color: textColor,
              fontSize: AppSize.font(14),
              fontWeight: FontWeight.w600,
            ),

            showCountryFlag: false,

            dropdownIcon: const Icon(Icons.keyboard_arrow_down),

            textAlign: TextAlign.start,

            textInputAction: TextInputAction.next,

            autovalidateMode: AutovalidateMode.onUserInteraction,

            onChanged: onPhoneChanged,

            onCountryChanged: onCountryChanged,

            validator: (phone) => AppValidators.phone(
              phone?.number,
              phone?.isValidNumber() ?? false,
            ),

            dropdownTextStyle: TextStyle(
              color: textColor,
              fontSize: AppSize.font(14),
              fontWeight: FontWeight.w600,
            ),

            decoration: InputDecoration(
              filled: true,

              fillColor: theme.cardColor,

              hintText: hintText,

              helperText: helperText,

              hintStyle: TextStyle(color: hintColor).xs,

              errorStyle: TextStyle(
                color: errorColor,
                fontSize: AppSize.font(14),
              ),

              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSize.getWidth(14),
                vertical: AppSize.getHeight(14),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: borderColor),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: errorColor),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: errorColor, width: 1.5),
              ),

              prefixIconConstraints: BoxConstraints(
                minHeight: AppSize.getHeight(40),
                maxHeight: AppSize.getHeight(40),
              ),

              suffixIconConstraints: BoxConstraints(
                minHeight: AppSize.getHeight(40),
                maxHeight: AppSize.getHeight(40),
              ),
            ),

            pickerDialogStyle: PickerDialogStyle(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.getHeight(20),
                horizontal: AppSize.getWidth(16),
              ),

              countryNameStyle: TextStyle(
                color: textColor,
                fontSize: AppSize.font(14),
                fontWeight: FontWeight.w500,
              ),

              countryCodeStyle: TextStyle(
                color: textColor,
                fontSize: AppSize.font(14),
                fontWeight: FontWeight.w500,
              ),

              listTilePadding: EdgeInsets.zero,

              listTileDivider: const SizedBox(),

              searchFieldPadding: EdgeInsets.zero,

              searchFieldInputDecoration: InputDecoration(
                hintText: "core.search".tr(),

                filled: true,

                fillColor: theme.cardColor,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            dialogType: DialogType.showModalBottomSheet,

            dropdownDecoration: BoxDecoration(
              border: BorderDirectional(end: BorderSide(color: borderColor)),
            ),

            flagsButtonMargin: const EdgeInsets.only(right: 10),
          ),
        ),
      ],
    );
  }
}

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: TextStyle(color: AppColors.grey700).sm,
          ),
          SizedBox(height: AppSize.getHeight(6)),
        ],
        Directionality(
          textDirection: TextDirection.ltr,
          child: IntlPhoneField(
            languageCode: lang,
            style: TextStyle(
              fontSize: AppSize.font(14),
              fontWeight: FontWeight.w600,
            ),
            controller: controller,
            showCountryFlag: false,
            dropdownIcon: Icon(Icons.keyboard_arrow_down),
            initialCountryCode: initialCountryCode ?? 'SA',
            onChanged: onPhoneChanged,
            textAlign: TextAlign.start,
            decoration: InputDecoration(
              hintText: hintText,
              helperText: helperText,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppSize.getWidth(14),
                vertical: AppSize.getHeight(10),
              ),
              suffixIconConstraints: BoxConstraints(
                minHeight: AppSize.getHeight(40),
                maxHeight: AppSize.getHeight(40),
              ),
              prefixIconConstraints: BoxConstraints(
                minHeight: AppSize.getHeight(40),
                maxHeight: AppSize.getHeight(40),
              ),
            ),
            dropdownTextStyle: TextStyle(
              fontSize: AppSize.font(14),
              fontWeight: FontWeight.w500,
            ),
            onCountryChanged: onCountryChanged,
            pickerDialogStyle: PickerDialogStyle(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.getHeight(20),
                horizontal: AppSize.getWidth(16),
              ),
              countryNameStyle: TextStyle(
                fontSize: AppSize.font(14),
                fontWeight: FontWeight.w500,
              ),
              countryCodeStyle: TextStyle(
                fontSize: AppSize.font(14),
                fontWeight: FontWeight.w500,
              ),
              listTilePadding: EdgeInsets.zero,
              listTileDivider: SizedBox(),
              searchFieldPadding: EdgeInsets.zero,
              searchFieldInputDecoration: InputDecoration(
                hintText: 'core.search'.tr(),
              ),
            ),
            dialogType: DialogType.showModalBottomSheet,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (phone) => AppValidators.phone(
              phone?.number,
              phone?.isValidNumber() ?? false,
            ),
            textInputAction: TextInputAction.next,
            dropdownDecoration: BoxDecoration(
              border: BorderDirectional(
                end: BorderSide(color: AppColors.fieldBorder),
              ),
            ),
            flagsButtonMargin: EdgeInsets.only(right: 10),
          ),
        ),
      ],
    );
  }
}

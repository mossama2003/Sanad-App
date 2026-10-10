import 'package:easy_localization/easy_localization.dart';

class AppValidators {
  /// REQUIRED VALIDATION
  static String? required(String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    } else {
      return null;
    }
  }

  /// GENERIC DROPDOWN VALIDATION (WORKS WITH ANY TYPE)
  static String? dropdownRequired<T>(T? value) {
    if (value == null) {
      return 'validators.required'.tr();
    }
    return null;
  }

  /// REQUIRED LENGTH VALIDATION
  static String? minLength(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    } else if (value.length < length) {
      return 'validators.length.min'.tr(namedArgs: {'length': '$length'});
    } else {
      return null;
    }
  }

  /// MAXIMUM LENGTH VALIDATION
  static String? maxLength(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    } else if (value.length > length) {
      return 'validators.length.max'.tr(namedArgs: {'length': '$length'});
    } else {
      return null;
    }
  }

  /// REQUIRED EXACT LENGTH VALIDATION
  static String? exactLength(String? value, int length) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    } else if (value.length != length) {
      return 'validators.length.exact'.tr(namedArgs: {'length': '$length'});
    } else {
      return null;
    }
  }

  /// EMAIL VALIDATION
  static String? email(String? email) {
    if (email == null || email.isEmpty) {
      return 'validators.email.required'.tr();
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      return 'validators.email.pattern'.tr();
    } else {
      return null;
    }
  }

  /// PASSWORD VALIDATION
  static String? password(String? password, {String? name, String? email}) {
    if (password == null || password.isEmpty) {
      return 'validators.password.required'.tr();
    }
    List<String> messages = [];

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      messages.add('validators.password.contain_special_char_summary'.tr());
    }

    if (!RegExp(r'[a-zA-Z]').hasMatch(password)) {
      messages.add('validators.password.contain_letter_summary'.tr());
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      messages.add('validators.password.contain_number_summary'.tr());
    }

    if (password.length < 8) {
      messages.add('validators.password.min_length_summary'.tr());
    }

    if (password.contains(' ')) {
      messages.add('validators.password.no_spaces'.tr());
    }

    if (name != null && name.isNotEmpty && !notContainName(password, name)) {
      messages.add('validators.password.no_name'.tr());
    }

    if (email != null &&
        email.isNotEmpty &&
        password.toLowerCase().contains(email.toLowerCase())) {
      messages.add('validators.password.no_email'.tr());
    }

    // Return messages if validation fails
    if (messages.isEmpty) return null;
    return '${"validators.password.must_include".tr()} ${messages.join(', ')}';
  }

  static bool notContainName(String password, String name) {
    if (name.isEmpty) return true;
    String lowerPassword = password.toLowerCase();
    String lowerName = name.toLowerCase();
    List<String> nameParts = lowerName.split(RegExp(r'\s+'));
    for (String part in nameParts) {
      if (part.isNotEmpty && lowerPassword.contains(part)) return false;
    }
    return true;
  }

  /// OLD PASSWORD NOT THE SAME AS NEW PASSWORD
  static String? oldPasswordNotNew(String? oldPassword, String? newPassword) {
    if (oldPassword == null || oldPassword.isEmpty) {
      return 'validators.password.required'.tr();
    } else if (newPassword == null || newPassword.isEmpty) {
      return 'validators.password.required'.tr();
    } else if (oldPassword == newPassword) {
      return 'validators.password.old_new_same'.tr();
    } else {
      return null;
    }
  }

  /// PASSWORD IDENTICAL
  static String? passwordIdentical(String? value, String? other) {
    if (value == null || value.isEmpty) {
      return 'validators.password.required'.tr();
    } else if (value != other) {
      return 'validators.password.identical'.tr();
    } else {
      return null;
    }
  }

  /// PHONE NUMBER VALIDATION
  static String? phone(String? value, bool isValid) {
    if (value == null || value.isEmpty) {
      return 'validators.phone.required'.tr();
    } else if (!isValid) {
      return 'validators.phone.invalid'.tr();
    } else {
      return null;
    }
  }

  /// ONLY NUMBERS AND LENGTH
  static String? onlyNumbers(String? value, {int? length}) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'validators.numbers.only'.tr();
    } else if (length != null && value.length != length) {
      return 'validators.numbers.exact_length'.tr(
        namedArgs: {'length': '$length'},
      );
    } else {
      return null;
    }
  }

  /// NUMBER LESS THAN VALIDATION
  static String? numLessThan(String? value, int max) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'validators.numbers.only'.tr();
    } else {
      int? intValue = int.tryParse(value);
      if (intValue == null) {
        return 'validators.numbers.only'.tr();
      } else if (intValue >= max) {
        return 'validators.numbers.less_than'.tr(namedArgs: {'max': '$max'});
      } else {
        return null;
      }
    }
  }

  /// VALUE IN RANGE VALIDATION
  static String? numInRange(String? value, int min, int max) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'validators.numbers.only'.tr();
    } else {
      int? intValue = int.tryParse(value);
      if (intValue == null) {
        return 'validators.numbers.only'.tr();
      } else if (intValue < min || intValue > max) {
        return 'validators.numbers.range'.tr(
          namedArgs: {'min': '$min', 'max': '$max'},
        );
      } else {
        return null;
      }
    }
  }

  /// NUMBER GREATER THAN VALIDATION
  static String? numGreaterThan(String? value, int min) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'validators.numbers.only'.tr();
    } else {
      int? intValue = int.tryParse(value);
      if (intValue == null) {
        return 'validators.numbers.only'.tr();
      } else if (intValue <= min) {
        return 'validators.numbers.greater_than'.tr(namedArgs: {'min': '$min'});
      } else {
        return null;
      }
    }
  }

  /// REQUIRED POSITIVE DECIMAL AMOUNT VALIDATION
  static String? requiredAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    }

    final amount = double.tryParse(value.trim());

    if (amount == null) {
      return 'validators.numbers.only'.tr();
    }

    if (amount <= 0) {
      return 'validators.numbers.greater_than'.tr(namedArgs: {'min': '0'});
    }

    return null;
  }

  /// OTP VALIDATION
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.OTP.required'.tr();
    } else if (value.length < 6) {
      return 'validators.OTP.length'.tr();
    } else {
      return null;
    }
  }

  /// GOOGLE MAPS LINK VALIDATION
  static String? googleMapsUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    }

    final googleMapsRegex = RegExp(
      r'^(https?://)?((www\.)?google\.[a-z.]+/maps/.*|maps\.app\.goo\.gl/.*|goo\.gl/maps/.*)$',
      caseSensitive: false,
    );

    if (!googleMapsRegex.hasMatch(value.trim())) {
      return 'validators.google_maps.invalid'.tr();
    }

    return null;
  }

  /// WEBSITE URL VALIDATION
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    }

    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\w-]+\.)+[\w-]{2,}(\/.*)?$',
      caseSensitive: false,
    );

    if (!urlRegex.hasMatch(value.trim())) {
      return 'validators.url.invalid'.tr();
    }

    return null;
  }

  /// INSTAPAY LINK VALIDATION
  static String? instapayLink(String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    }

    final instapayRegex = RegExp(
      r'^(https?://)?(www\.)?ipn\.eg/S/[\w.\-]+/instapay/[\w\-]+/?$',
      caseSensitive: false,
    );

    if (!instapayRegex.hasMatch(value.trim())) {
      return 'validators.instapay.invalid'.tr();
    }

    return null;
  }

  /// EGYPTIAN PHONE VALIDATION (WALLET) — 10 digits, starts 010/011/012/015
  static String? egyptianPhoneWithoutZero(String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    }

    final cleaned = value.trim();

    if (!RegExp(r'^(10|11|12|15)\d{8}$').hasMatch(cleaned)) {
      return 'validators.phone.egyptian_invalid'.tr();
    }

    return null;
  }

  /// EGYPTIAN IBAN VALIDATION — EG + 27 digits = 29 chars, + MOD-97 checksum
  static String? egyptianIban(String? value) {
    if (value == null || value.isEmpty) {
      return 'validators.required'.tr();
    }

    final cleaned = value.trim().toUpperCase().replaceAll(' ', '');

    if (!cleaned.startsWith('EG')) {
      return 'validators.iban.must_start_eg'.tr();
    }

    if (cleaned.length != 29) {
      return 'validators.iban.length'.tr();
    }

    if (!RegExp(r'^EG\d{27}$').hasMatch(cleaned)) {
      return 'validators.iban.invalid'.tr();
    }

    if (!_ibanChecksumValid(cleaned)) {
      return 'validators.iban.checksum'.tr();
    }

    return null;
  }

  /// MOD-97 IBAN CHECKSUM (STANDARD ALGORITHM)
  static bool _ibanChecksumValid(String iban) {
    final rearranged = iban.substring(4) + iban.substring(0, 4);

    final numericString = rearranged.split('').map((c) {
      if (RegExp(r'[A-Z]').hasMatch(c)) {
        return (c.codeUnitAt(0) - 55).toString();
      }
      return c;
    }).join();

    BigInt number = BigInt.parse(numericString);

    return number % BigInt.from(97) == BigInt.one;
  }
}

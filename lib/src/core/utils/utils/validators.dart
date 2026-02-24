import 'package:get/get.dart';
import 'package:al_muttaqee/l10n/app_localizations.dart';

abstract class Validator {
  static final _appLocalizations = AppLocalizations.of(Get.context!)!;

  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your name"; // Validation message for empty input
    }
    if (value.length > 30) {
      return "The name must not exceed 30 characters"; // Validation message for length exceeding 30 characters
    }
    return null;
  }

  static String? validateNotes(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter notes";
    }
    return null;
  }

  static String? validateTreatmentCost(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Treatment Cost";
    }
    if (double.tryParse(value) == null) {
      return "Please Enter a valid treatment cost";
    }
    if (double.parse(value) < 0) {
      return "Please Enter a valid treatment cost";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your email";
    }

    const String emailPattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(value)) {
      return "Please enter a valid email";
    }

    return null;
  }

  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return "Please Enter Birthdate";
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final validPhoneNumber = RegExp(r'^\+?[0-9]*$');

    if (!validPhoneNumber.hasMatch(value!)) {
      return "Phone number is not valid";
    }

    if (value!.length < 10 || value.length > 15) {
      return "Phone number is not valid";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  static String? validateOldPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password did not match";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty || value != password) {
      return "Please enter password";
    }
    if (value.length < 8) {
      return "Password must be at least 8 characters long";
    }
    return null;
  }

  static String? validateCommission(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a value";
    }

    final number = int.tryParse(value);
    if (number == null) {
      return "Please enter a valid number";
    }

    if (number < 0) {
      return "Commission can't be under 0";
    }

    if (number > 100) {
      return "Commission can't be over 100";
    }

    return null;
  }
}

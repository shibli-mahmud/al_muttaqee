import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class L10n {
  static const locals = [
    Locale('en'),
    Locale('bn'),
  ];

  static Locale selectedLocale = locals[0];

  static init() async {
    final temp = locals.firstWhereOrNull(
      (element) =>
          Platform.localeName.startsWith("${element.languageCode}_") ||
          Platform.localeName == element.languageCode,
    );

    final sp = await SharedPreferences.getInstance();
    final localeIndex = sp.getInt(AppStrings.spLocale);

    if (localeIndex != null && localeIndex >= 0 && localeIndex < locals.length) {
      selectedLocale = locals[localeIndex];
      Get.updateLocale(selectedLocale);
      return;
    }

    if (temp == null) {
      await setLocale(selectedLocale);
    } else {
      await setLocale(temp);
      selectedLocale = temp;
    }
  }

  static Future getLocale() async {
    final sp = await SharedPreferences.getInstance();
    final localeIndex = sp.getInt(AppStrings.spLocale) ?? 0;
    final index = localeIndex.clamp(0, locals.length - 1);
    selectedLocale = locals[index];
    Get.updateLocale(locals[index]);
  }

  static Future setLocale(Locale locale) async {
    final sp = await SharedPreferences.getInstance();
    final index = locals.indexOf(locale);
    if (index < 0) return;
    final result = await sp.setInt(AppStrings.spLocale, index);
    if (result) {
      selectedLocale = locale;
      Get.updateLocale(locale);
    }
  }

  static bool isBangla(Locale locale) {
    return locale.languageCode == "bn";
  }

  static bool isEnglish(Locale locale) {
    return locale.languageCode == "en";
  }

  static String getLocalString(Locale locale) {
    switch (locale.languageCode) {
      case "en":
        return "English";
      case "bn":
        return "বাংলা";
      default:
        return locale.languageCode;
    }
  }
}

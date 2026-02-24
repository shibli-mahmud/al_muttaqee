import 'package:islamic_app/src/core/config/build_config.dart';

abstract class AppStrings {
  static final _config = BuildConfig.instance.envConfig;

  // Shared Preference key
  static final spAlreadyInstalled = "${_config.packageName}.app_already_installed";
  static final spAccessToken = "${_config.packageName}.user_access_token";
  static final spLocale = "${_config.packageName}.app_locale";


  static final spLanguage = "${_config.packageName}.language";


  // Notification
  static final notificationChannelId = "${_config.packageName}.islamic_app_channel";
  static const notificationChannelName = "islamic_app Channel";

  // Endpoints
  static const urlGetUser = "v1/token-user";

}

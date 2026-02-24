part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const AUTH = _Paths.AUTH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const RESET_PASSWORD = _Paths.RESET_PASSWORD;
  static const EMAIL_VERIFICATION = _Paths.EMAIL_VERIFICATION;
  static const HOME = _Paths.HOME;

}

abstract class _Paths {
  static const SPLASH = "/splash";
  static const ONBOARDING = "/onboarding";
  static const AUTH = "/auth";
  static const LOGIN = "/login";
  static const REGISTER = "/register";
  static const FORGOT_PASSWORD = "/forgot_password";
  static const RESET_PASSWORD = "/reset_password";
  static const EMAIL_VERIFICATION = "/email_verification";
  static const HOME = "/";

}

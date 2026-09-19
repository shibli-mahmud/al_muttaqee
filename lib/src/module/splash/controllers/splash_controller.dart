import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/module/onboarding/controllers/onboarding_controller.dart';

class SplashController extends BaseController {
  /// How long the wordmark is held. Short enough not to be in the way, long
  /// enough that the app does not appear to flash on a fast device.
  static const Duration _hold = Duration(milliseconds: 1200);

  @override
  void onReady() {
    super.onReady();
    _route();
  }

  Future<void> _route() async {
    // The preference read and the hold run together, so first-run users are
    // not charged for both.
    final results = await Future.wait([
      OnboardingController.isComplete(),
      Future<bool>.delayed(_hold, () => true),
    ]);

    final onboarded = results.first;
    Get.offAllNamed(onboarded ? Routes.dashboard : Routes.onboarding);
  }
}

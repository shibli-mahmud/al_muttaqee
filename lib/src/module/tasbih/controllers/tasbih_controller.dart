import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:get/get.dart';

class TasbihController extends BaseController {
  static TasbihController get to => Get.find<TasbihController>();

  /// Current count for this round (resets at [targetCount]).
  final count = 0.obs;

  /// Total count across all rounds (never resets until user resets all).
  final totalCount = 0.obs;

  /// Number of completed rounds (e.g. each 33 or 99).
  final roundsCompleted = 0.obs;

  /// Target count per round (33 is common for Subhanallah/Alhamdulillah/Allahu Akbar).
  static const int targetCount = 33;

  void increment() {
    count.value = count.value + 1;
    totalCount.value = totalCount.value + 1;
    if (count.value >= targetCount) {
      roundsCompleted.value = roundsCompleted.value + 1;
      count.value = 0;
    }
  }

  /// Decrement count by one (for swipe-back correction). Does not reduce totalCount.
  void decrement() {
    if (count.value > 0) {
      count.value = count.value - 1;
    }
  }

  /// Call when swipe ends; completes the round if count reached 33.
  void completeRoundIfFull() {
    if (count.value >= targetCount) {
      roundsCompleted.value = roundsCompleted.value + 1;
      count.value = 0;
    }
  }

  void resetRound() {
    count.value = 0;
  }

  void resetAll() {
    count.value = 0;
    totalCount.value = 0;
    roundsCompleted.value = 0;
  }
}
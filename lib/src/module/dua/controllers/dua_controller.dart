import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/local/db/hadith_database.dart';
import 'package:al_muttaqee/src/module/dua/data/dua_repository.dart';
import 'package:al_muttaqee/src/module/dua/models/dua_models.dart';

/// দুআ সংকলন — frame ১৬.
class DuaController extends BaseController {
  static DuaController get to => Get.find<DuaController>();

  DuaController({DuaRepository? repository, HadithDatabase? database})
      : _repository = repository ?? DuaRepository(),
        _database = database ?? HadithDatabase.to;

  final DuaRepository _repository;
  final HadithDatabase _database;

  final categories = <DuaCategory>[].obs;
  final featured = Rxn<Dua>();

  /// The chip that is open. Starts on whichever category the clock makes
  /// useful, which is the whole point of the row — the user should not have
  /// to tell the app it is bedtime.
  final active = Rxn<DuaCategory>();
  final duas = <Dua>[].obs;

  final isLoading = true.obs;
  final loadError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    loadError.value = '';
    try {
      await _database.open();
      if (_database.error.value.isNotEmpty) {
        loadError.value = _database.error.value;
        return;
      }

      categories.assignAll(await _repository.categories());
      featured.value = await _repository.featured();

      final contextual = contextualCategory(DateTime.now());
      final resolved = categories.firstWhereOrNull(
            (c) => c.id == contextual.id,
          ) ??
          (categories.isEmpty ? null : categories.first);
      if (resolved != null) await select(resolved);
    } catch (e, st) {
      logger.e('DuaController.load: $e\n$st');
      loadError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> select(DuaCategory category) async {
    active.value = category;
    duas.clear();
    try {
      duas.assignAll(await _repository.byCategory(category));
    } catch (e, st) {
      logger.e('DuaController.select: $e\n$st');
    }
  }

  /// The chips shown at the top: the time-of-day ones, in clock order.
  List<DuaCategory> get contextualChips =>
      categories.where((c) => c.isContextual).toList(growable: false);

  /// Everything else, shown as the category grid.
  List<DuaCategory> get gridCategories => categories;
}

import 'dart:ui';

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/hadith/data/hadith_repository.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';
import 'package:get/get.dart';

class HadithController extends BaseController {
  static HadithController get to => Get.find<HadithController>();

  HadithController({
    HadithRepository? repository,
    PreferenceManager? preferences,
  }) : _repository = repository ?? HadithRepository(),
       _preferences = preferences ?? PreferenceManagerImpl.to;

  final HadithRepository _repository;
  final PreferenceManager _preferences;

  final chapters = <HadithChapter>[].obs;
  final hadiths = <Hadith>[].obs;
  final bookmarks = <String>{}.obs;
  final isLoading = false.obs;
  final selectedBook = Rxn<HadithBook>();
  final selectedChapter = Rxn<HadithChapter>();
  final searchQuery = ''.obs;
  final isPro = false.obs;

  Locale get currentLocale => L10n.selectedLocale;

  List<Hadith> get filteredHadiths {
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isEmpty || !isPro.value) return hadiths;
    return hadiths.where((hadith) {
      final firstLine = localizedText(hadith).split('\n').first.toLowerCase();
      return hadith.title.toLowerCase().contains(query) ||
          firstLine.contains(query) ||
          hadith.number.toString().contains(query);
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    _loadBookmarks();
    _loadProStatus();
  }

  Future<void> openBook(HadithBook book) async {
    selectedBook.value = book;
    selectedChapter.value = null;
    chapters.clear();
    hadiths.clear();
    await _loadChapters(book);
  }

  Future<void> openChapter(HadithChapter chapter) async {
    final book = selectedBook.value;
    if (book == null) return;
    selectedChapter.value = chapter;
    searchQuery.value = '';
    isLoading.value = true;
    try {
      hadiths.assignAll(await _repository.loadHadiths(book, chapter.number));
    } catch (error, stackTrace) {
      logger.e('HadithController.openChapter: $error\n$stackTrace');
      hadiths.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadChapters(HadithBook book) async {
    isLoading.value = true;
    try {
      chapters.assignAll(await _repository.loadChapters(book));
    } catch (error, stackTrace) {
      logger.e('HadithController._loadChapters: $error\n$stackTrace');
      chapters.assignAll(const [HadithChapter(number: 1, title: '')]);
    } finally {
      isLoading.value = false;
    }
  }

  String localizedText(Hadith hadith) =>
      L10n.isBangla(currentLocale) ? hadith.bengali : hadith.english;

  bool isBookmarked(Hadith hadith) => bookmarks.contains(hadith.id);

  Future<void> toggleBookmark(Hadith hadith) async {
    if (!isPro.value) {
      showErrorMessage(appLocalization.proUnlock);
      return;
    }
    if (!bookmarks.add(hadith.id)) bookmarks.remove(hadith.id);
    bookmarks.refresh();
    await _preferences.setStringList(
      AppStrings.spHadithBookmarks,
      bookmarks.toList(),
    );
  }

  Future<void> _loadBookmarks() async {
    bookmarks.assignAll(
      await _preferences.getStringList(AppStrings.spHadithBookmarks),
    );
  }

  Future<void> _loadProStatus() async {
    isPro.value = await _preferences.getBool('pro_unlocked', defaultValue: false);
  }
}

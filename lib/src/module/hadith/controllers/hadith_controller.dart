import 'dart:async';

import 'package:get/get.dart';

import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/local/db/hadith_database.dart';
import 'package:al_muttaqee/src/core/routes/app_pages.dart';
import 'package:al_muttaqee/src/module/hadith/data/hadith_repository.dart';
import 'package:al_muttaqee/src/module/hadith/models/hadith_models.dart';

/// হাদিস — frame ১৫, plus the collection and chapter screens behind it.
///
/// Bookmarking is free. The old build put it behind the Pro unlock; the
/// redesign takes the paywall out of the features entirely, and a bookmark is
/// the cheapest possible thing to store — it is one string in preferences.
class HadithController extends BaseController {
  static HadithController get to => Get.find<HadithController>();

  HadithController({HadithRepository? repository, HadithDatabase? database})
      : _repository = repository ?? HadithRepository(),
        _database = database ?? HadithDatabase.to;

  final HadithRepository _repository;
  final HadithDatabase _database;

  final books = <HadithBook>[].obs;
  final dailyHadith = Rxn<HadithHit>();
  final bookmarkIds = <String>{}.obs;

  /// True while the corpus is being inflated or read for the first time.
  final isLoading = true.obs;

  /// Set when the corpus could not be opened, so the screen can explain
  /// itself instead of looking empty.
  final loadError = ''.obs;

  // ── Collection screen ─────────────────────────────────────────────────────
  final chapters = <HadithChapter>[].obs;
  final openBook = Rxn<HadithBook>();
  final isLoadingChapters = false.obs;

  // ── Chapter screen ────────────────────────────────────────────────────────
  final hadiths = <Hadith>[].obs;
  final openChapter = Rxn<HadithChapter>();
  final isLoadingHadiths = false.obs;

  // ── Search ────────────────────────────────────────────────────────────────
  final searchQuery = ''.obs;
  final searchResults = <HadithHit>[].obs;
  final isSearching = false.obs;
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
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
      books.assignAll(await _repository.books());
      dailyHadith.value = await _repository.hadithOfTheDay();
      bookmarkIds.assignAll(await _repository.bookmarkIds());
    } catch (e, st) {
      logger.e('HadithController.load: $e\n$st');
      loadError.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// The collections shown as ordinary browse cards.
  List<HadithBook> get browsable =>
      books.where((book) => !book.curated).toList(growable: false);

  /// ৪০ হাদিস নববি, which the design gives its own treatment.
  HadithBook? get curated =>
      books.firstWhereOrNull((book) => book.curated);

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> selectBook(HadithBook book) async {
    openBook.value = book;
    chapters.clear();
    isLoadingChapters.value = true;
    try {
      chapters.assignAll(await _repository.chapters(book.slug));
    } catch (e, st) {
      logger.e('HadithController.selectBook: $e\n$st');
    } finally {
      isLoadingChapters.value = false;
    }
    await Get.toNamed(Routes.hadithCollectionFor(book.slug));
  }

  Future<void> selectChapter(HadithChapter chapter) async {
    openChapter.value = chapter;
    hadiths.clear();
    isLoadingHadiths.value = true;
    try {
      hadiths.assignAll(
        await _repository.hadiths(chapter.book, chapter.number),
      );
    } catch (e, st) {
      logger.e('HadithController.selectChapter: $e\n$st');
    } finally {
      isLoadingHadiths.value = false;
    }
    await Get.toNamed(Routes.hadithChapter);
  }

  /// Re-reads the chapter list when the collection screen is entered directly
  /// by route rather than through [selectBook].
  Future<void> ensureChaptersFor(String slug) async {
    if (openBook.value?.slug == slug && chapters.isNotEmpty) return;
    isLoadingChapters.value = true;
    try {
      openBook.value = await _repository.book(slug);
      chapters.assignAll(await _repository.chapters(slug));
    } catch (e, st) {
      logger.e('HadithController.ensureChaptersFor: $e\n$st');
    } finally {
      isLoadingChapters.value = false;
    }
  }

  // ── Search ────────────────────────────────────────────────────────────────

  /// Debounced by 300ms: FTS over 34,000 rows is fast but not free, and firing
  /// it on every keystroke of a Bangla keyboard — where one character often
  /// arrives as several composition events — would run it many times per word.
  void onSearchChanged(String query) {
    searchQuery.value = query;
    _searchDebounce?.cancel();

    if (query.trim().length < 2) {
      searchResults.clear();
      isSearching.value = false;
      return;
    }

    isSearching.value = true;
    _searchDebounce = Timer(const Duration(milliseconds: 300), () async {
      try {
        searchResults.assignAll(await _repository.search(query));
      } catch (e, st) {
        logger.e('HadithController.onSearchChanged: $e\n$st');
        searchResults.clear();
      } finally {
        isSearching.value = false;
      }
    });
  }

  void clearSearch() {
    _searchDebounce?.cancel();
    searchQuery.value = '';
    searchResults.clear();
    isSearching.value = false;
  }

  // ── Bookmarks ─────────────────────────────────────────────────────────────

  bool isBookmarked(Hadith hadith) => bookmarkIds.contains(hadith.id);

  Future<void> toggleBookmark(Hadith hadith) async {
    // Optimistic, so the icon flips on the frame the finger lifts.
    if (!bookmarkIds.add(hadith.id)) bookmarkIds.remove(hadith.id);
    bookmarkIds.refresh();
    await _repository.toggleBookmark(hadith.id);
  }

  Future<List<HadithHit>> loadBookmarks() => _repository.bookmarks();

  void openSearch() => Get.toNamed(Routes.hadithSearch);
  void openBookmarks() => Get.toNamed(Routes.hadithBookmarks);
}

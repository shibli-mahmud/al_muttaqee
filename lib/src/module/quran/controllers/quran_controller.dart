import 'dart:ui';

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_models.dart';
import 'package:get/get.dart';
import 'package:quran_flutter/quran_flutter.dart';

class QuranController extends BaseController {
  static QuranController get to => Get.find<QuranController>();

  final RxList<SurahMeta> _surahs = <SurahMeta>[].obs;
  final RxList<ParaMeta> _paras = <ParaMeta>[].obs;

  List<SurahMeta> get surahs => _surahs;
  List<ParaMeta> get paras => _paras;

  final Rxn<SurahMeta> _lastReadSurah = Rxn<SurahMeta>();
  final RxInt _lastReadAyah = 0.obs;

  SurahMeta? get lastReadSurah => _lastReadSurah.value;
  int get lastReadAyah => _lastReadAyah.value;

  Locale get currentLocale => L10n.selectedLocale;

  @override
  void onInit() {
    super.onInit();
    _loadMetadata();
    _loadLastRead();
  }

  void _loadMetadata() {
    final surahList = Quran.getSurahAsList() as List<Surah>;
    _surahs.assignAll(surahList.map(SurahMeta.fromPackage));

    final juzList = Quran.getJuzAsList() as List<Juz>;
    _paras.assignAll(juzList.map(ParaMeta.fromPackage));
  }

  Future<void> _loadLastRead() async {
    final prefs = PreferenceManagerImpl.to;
    final surahNumber =
        await prefs.getInt(AppStrings.spQuranLastSurahNumber, defaultValue: 0);
    final ayahNumber =
        await prefs.getInt(AppStrings.spQuranLastAyahNumber, defaultValue: 0);

    if (surahNumber <= 0 || ayahNumber <= 0) {
      _lastReadSurah.value = null;
      _lastReadAyah.value = 0;
      return;
    }

    final surah =
        _surahs.firstWhereOrNull((element) => element.number == surahNumber);
    if (surah == null) {
      _lastReadSurah.value = null;
      _lastReadAyah.value = 0;
      return;
    }

    _lastReadSurah.value = surah;
    _lastReadAyah.value = ayahNumber;
  }

  Future<void> setLastRead(SurahMeta surah, int ayahNumber) async {
    _lastReadSurah.value = surah;
    _lastReadAyah.value = ayahNumber;

    final prefs = PreferenceManagerImpl.to;
    await prefs.setInt(AppStrings.spQuranLastSurahNumber, surah.number);
    await prefs.setInt(AppStrings.spQuranLastAyahNumber, ayahNumber);
  }

  /// Arabic verses for a surah.
  List<Verse> getSurahVersesArabic(int surahNumber) {
    return Quran.getSurahVersesAsList(surahNumber) as List<Verse>;
  }

  /// Translated verses for a surah based on current locale.
  List<Verse> getSurahVersesTranslated(int surahNumber) {
    final lang = quranLanguageFromLocale(currentLocale);
    return Quran.getSurahVersesAsList(surahNumber, language: lang) as List<Verse>;
  }
}

import 'dart:async';

import 'package:al_muttaqee/l10n/l10n.dart';
import 'package:al_muttaqee/src/core/base/base_controller.dart';
import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';
import 'package:al_muttaqee/src/module/quran/models/quran_models.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran_flutter/quran_flutter.dart';

class QuranController extends BaseController {
  static QuranController get to => Get.find<QuranController>();

  static const reciters = <QuranReciter>[
    QuranReciter(id: 'ar.alafasy', name: 'Mishary Rashid Alafasy'),
    QuranReciter(id: 'ar.abdulbasitmurattal', name: 'Abdul Basit Abdus-Samad'),
    QuranReciter(id: 'ar.husary', name: 'Mahmoud Khalil Al-Husary'),
    QuranReciter(id: 'ar.minshawi', name: 'Mohamed Siddiq Al-Minshawi'),
    QuranReciter(id: 'ar.sudais', name: 'Abdur-Rahman As-Sudais'),
    QuranReciter(id: 'ar.saoodshuraym', name: 'Saud Al-Shuraim'),
  ];

  final RxList<SurahMeta> _surahs = <SurahMeta>[].obs;
  final RxList<ParaMeta> _paras = <ParaMeta>[].obs;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final DefaultCacheManager _audioCache = DefaultCacheManager();
  final ScrollController surahScrollController = ScrollController();
  late final StreamSubscription<PlayerState> _playerStateSubscription;

  List<SurahMeta> get surahs => _surahs;
  List<ParaMeta> get paras => _paras;

  final Rxn<SurahMeta> _lastReadSurah = Rxn<SurahMeta>();
  final RxInt _lastReadAyah = 0.obs;

  SurahMeta? get lastReadSurah => _lastReadSurah.value;
  int get lastReadAyah => _lastReadAyah.value;

  final Rx<QuranReciter> _selectedReciter = reciters.first.obs;
  final RxnInt _playingSurahNumber = RxnInt();
  final RxnInt _playingAyahNumber = RxnInt();
  final RxBool _isPlaying = false.obs;
  final RxBool _repeatAyah = false.obs;
  final RxBool _repeatSurah = false.obs;
  final RxDouble _playbackSpeed = 1.0.obs;
  final RxSet<int> _downloadedSurahs = <int>{}.obs;
  final RxnInt _downloadingSurahNumber = RxnInt();
  int _playRequest = 0;

  QuranReciter get selectedReciter => _selectedReciter.value;
  int? get playingSurahNumber => _playingSurahNumber.value;
  int? get playingAyahNumber => _playingAyahNumber.value;
  bool get isPlaying => _isPlaying.value;
  bool get repeatAyah => _repeatAyah.value;
  bool get repeatSurah => _repeatSurah.value;
  double get playbackSpeed => _playbackSpeed.value;
  bool isSurahDownloaded(int surahNumber) =>
      _downloadedSurahs.contains(surahNumber);
  bool isDownloadingSurah(int surahNumber) =>
      _downloadingSurahNumber.value == surahNumber;

  Locale get currentLocale => L10n.selectedLocale;

  @override
  void onInit() {
    super.onInit();
    _loadMetadata();
    _loadLastRead();
    _loadAudioPreferences();
    _playerStateSubscription = _audioPlayer.playerStateStream.listen(
      _handlePlayerState,
    );
  }

  void _loadMetadata() {
    final surahList = Quran.getSurahAsList();
    _surahs.assignAll(surahList.map(SurahMeta.fromPackage));

    final juzList = Quran.getJuzAsList();
    _paras.assignAll(juzList.map(ParaMeta.fromPackage));
  }

  Future<void> _loadLastRead() async {
    final prefs = PreferenceManagerImpl.to;
    final surahNumber = await prefs.getInt(
      AppStrings.spQuranLastSurahNumber,
      defaultValue: 0,
    );
    final ayahNumber = await prefs.getInt(
      AppStrings.spQuranLastAyahNumber,
      defaultValue: 0,
    );

    if (surahNumber <= 0 || ayahNumber <= 0) {
      _lastReadSurah.value = null;
      _lastReadAyah.value = 0;
      return;
    }

    final surah = _surahs.firstWhereOrNull(
      (element) => element.number == surahNumber,
    );
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

  Future<void> _loadAudioPreferences() async {
    final prefs = PreferenceManagerImpl.to;
    final reciterId = await prefs.getString(
      AppStrings.spQuranReciter,
      defaultValue: reciters.first.id,
    );
    _selectedReciter.value =
        reciters.firstWhereOrNull((reciter) => reciter.id == reciterId) ??
        reciters.first;

    final downloaded = await prefs.getStringList(
      AppStrings.spQuranDownloadedSurahs,
    );
    _downloadedSurahs.assignAll(
      downloaded.map(int.tryParse).whereType<int>().where((number) {
        return number >= 1 && number <= _surahs.length;
      }),
    );
  }

  Future<void> selectReciter(QuranReciter reciter) async {
    if (reciter.id == selectedReciter.id) return;
    final wasPlaying = isPlaying;
    final surahNumber = playingSurahNumber;
    final ayahNumber = playingAyahNumber;
    _selectedReciter.value = reciter;
    await PreferenceManagerImpl.to.setString(
      AppStrings.spQuranReciter,
      reciter.id,
    );
    await _audioPlayer.stop();
    _isPlaying.value = false;

    if (wasPlaying && surahNumber != null && ayahNumber != null) {
      await playAyah(surahNumber, ayahNumber);
    }
  }

  Future<void> playAyah(int surahNumber, int ayahNumber) async {
    final request = ++_playRequest;
    _playingSurahNumber.value = surahNumber;
    _playingAyahNumber.value = ayahNumber;
    _isPlaying.value = true;

    try {
      final file = await _audioCache.getSingleFile(
        _audioUrl(surahNumber, ayahNumber),
      );
      if (request != _playRequest) return;
      await _audioPlayer.setAudioSource(AudioSource.file(file.path));
      await _audioPlayer.setSpeed(playbackSpeed);
      if (request != _playRequest) return;
      _scrollToAyah(ayahNumber);
      await _audioPlayer.play();
    } catch (_) {
      if (request == _playRequest) {
        _isPlaying.value = false;
      }
    }
  }

  Future<void> togglePlayback(int surahNumber, int ayahNumber) async {
    if (playingSurahNumber == surahNumber &&
        playingAyahNumber == ayahNumber &&
        isPlaying) {
      await _audioPlayer.pause();
      _isPlaying.value = false;
      return;
    }
    await playAyah(surahNumber, ayahNumber);
  }

  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed.value = speed;
    await _audioPlayer.setSpeed(speed);
  }

  void toggleRepeatAyah() => _repeatAyah.toggle();

  void toggleRepeatSurah() => _repeatSurah.toggle();

  Future<void> downloadSurah(int surahNumber) async {
    if (isSurahDownloaded(surahNumber) || isDownloadingSurah(surahNumber)) {
      return;
    }
    final isPro = await PreferenceManagerImpl.to.getBool(
      'pro_unlocked',
      defaultValue: false,
    );
    if (!isPro && selectedReciter.id != reciters.first.id) {
      showErrorMessage(appLocalization.proUnlock);
      return;
    }

    final surah = _surahs.firstWhereOrNull(
      (item) => item.number == surahNumber,
    );
    if (surah == null) return;
    _downloadingSurahNumber.value = surahNumber;
    try {
      for (var ayah = 1; ayah <= surah.ayahCount; ayah++) {
        await _audioCache.downloadFile(_audioUrl(surahNumber, ayah));
      }
      _downloadedSurahs.add(surahNumber);
      await PreferenceManagerImpl.to.setStringList(
        AppStrings.spQuranDownloadedSurahs,
        _downloadedSurahs.map((number) => '$number').toList(),
      );
    } finally {
      if (_downloadingSurahNumber.value == surahNumber) {
        _downloadingSurahNumber.value = null;
      }
    }
  }

  void _handlePlayerState(PlayerState state) {
    _isPlaying.value = state.playing;
    if (state.processingState != ProcessingState.completed) return;
    _playNextAyah();
  }

  Future<void> _playNextAyah() async {
    final surahNumber = playingSurahNumber;
    final ayahNumber = playingAyahNumber;
    if (surahNumber == null || ayahNumber == null) return;

    if (repeatAyah) {
      await playAyah(surahNumber, ayahNumber);
      return;
    }

    final surah = _surahs.firstWhereOrNull(
      (item) => item.number == surahNumber,
    );
    if (surah == null) return;
    if (ayahNumber < surah.ayahCount) {
      await playAyah(surahNumber, ayahNumber + 1);
    } else if (repeatSurah) {
      await playAyah(surahNumber, 1);
    } else {
      _isPlaying.value = false;
    }
  }

  String _audioUrl(int surahNumber, int ayahNumber) {
    return 'https://cdn.islamic.network/quran/audio/128/'
        '${selectedReciter.id}/${_absoluteAyahNumber(surahNumber, ayahNumber)}.mp3';
  }

  int _absoluteAyahNumber(int surahNumber, int ayahNumber) {
    return _surahs
            .where((surah) => surah.number < surahNumber)
            .fold<int>(0, (total, surah) => total + surah.ayahCount) +
        ayahNumber;
  }

  void _scrollToAyah(int ayahNumber) {
    if (!surahScrollController.hasClients) return;
    final offset = (ayahNumber - 1) * 180.0;
    final maxOffset = surahScrollController.position.maxScrollExtent;
    surahScrollController.animateTo(
      offset.clamp(0.0, maxOffset),
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  /// Arabic verses for a surah.
  List<Verse> getSurahVersesArabic(int surahNumber) {
    return Quran.getSurahVersesAsList(surahNumber);
  }

  /// Translated verses for a surah based on current locale.
  List<Verse> getSurahVersesTranslated(int surahNumber) {
    final lang = quranLanguageFromLocale(currentLocale);
    return Quran.getSurahVersesAsList(surahNumber, language: lang);
  }

  @override
  void onClose() {
    _playRequest++;
    _playerStateSubscription.cancel();
    surahScrollController.dispose();
    _audioPlayer.dispose();
    super.onClose();
  }
}

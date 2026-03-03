// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get home => 'Home';
  @override
  String get quran => 'Quran';
  @override
  String get qibla => 'Qibla';
  @override
  String get tasbih => 'Tasbih';
  @override
  String get language => 'Language';
  @override
  String get english => 'English';
  @override
  String get bangla => 'Bangla';
  @override
  String get preparingQiblaCompass => 'Preparing Qibla compass...';
  @override
  String get locationAccessRequired => 'Location access required';
  @override
  String get locationAccessMessage =>
      'Please enable location services and grant permission so we can calculate the direction of Qibla from your current position.';
  @override
  String get compassCalibrationMessage =>
      'Compass needs calibration. Move your device in the figure-8 pattern below to improve accuracy.';
  @override
  String get moveDeviceLikeThis => 'Move device like this';
  @override
  String get qiblaDirection => 'Qibla Direction';
  @override
  String get qiblaDirectionHint =>
      'Point the arrow towards the top of your device to face Qibla.';
  @override
  String qiblaHeadingFormat(double qibla, double heading) =>
      'Qibla: ${qibla.toStringAsFixed(0)}°  |  Heading: ${heading.toStringAsFixed(0)}°';
  @override
  String get deviceLevelMessage =>
      'Device is level — center the bubble in the circle';
  @override
  String tiltMessage(double tilt) =>
      'Tilt: ${tilt.toStringAsFixed(0)}° — center the bubble to level the device';
  @override
  String get levelIndicator => 'Level indicator (center bubble)';

  // Quran
  @override
  String get quranLastRead => 'Last read surah';
  @override
  String get quranContinueReading => 'Continue reading';
  @override
  String get quranStartReading => 'Start reading';
  @override
  String get quranNoLastReadYet => 'You have not opened any surah yet.';
  @override
  String get quranSurahTab => 'Surah';
  @override
  String get quranParaTab => 'Para';
  @override
  String get quranSurahLabel => 'Surah';
  @override
  String get quranParaLabel => 'Para';
  @override
  String quranAyahNumberLabel(int ayahNumber) => 'Ayah $ayahNumber';
}

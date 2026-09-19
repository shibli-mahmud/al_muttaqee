import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:al_muttaqee/src/core/constants/app_strings.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager.dart';
import 'package:al_muttaqee/src/core/local/preferences/preference_manager_impl.dart';

/// The bundled, read-only hadith corpus.
///
/// The app ships `assets/data/hadith.db.gz` — six complete collections, Arabic
/// and Bangla, 34,051 hadiths — and inflates it into the app's support
/// directory the first time it is opened. It is read-only from then on, so it
/// never needs migrating; a new corpus ships as a new [assetVersion] and simply
/// replaces the file.
///
/// It is separate from [AppDatabase] on purpose. That one holds the user's own
/// records and must survive every update; this one is disposable content that
/// can be deleted and re-inflated at any time. Keeping them in one file would
/// mean a 113 MB backup of data the user did not create.
class HadithDatabase extends GetxService {
  static HadithDatabase get to => Get.find<HadithDatabase>();

  HadithDatabase({PreferenceManager? prefs})
      : _prefs = prefs ?? PreferenceManagerImpl.to;

  final PreferenceManager _prefs;

  static const String assetPath = 'assets/data/hadith.db.gz';
  static const String fileName = 'hadith.db';

  /// Bumped whenever the bundled corpus changes, which triggers a re-inflate.
  static const int assetVersion = 1;

  Database? _db;
  Future<void>? _opening;

  /// True once the corpus is queryable. The হাদিস screen watches this so it
  /// can show a skeleton for the second or two the first inflate takes.
  final isReady = false.obs;

  /// Set when inflating failed. The screen reports it inline and offers a
  /// retry rather than pretending the collection is empty.
  final error = ''.obs;

  Database get db {
    final database = _db;
    if (database == null) {
      throw StateError('HadithDatabase is not open yet.');
    }
    return database;
  }

  /// Opens the corpus, inflating it from the asset if needed.
  ///
  /// Safe to call from several places at once — the first call owns the work
  /// and the rest await it, so two screens opening together cannot both start
  /// a 113 MB write.
  Future<void> open() {
    if (_db != null) return Future<void>.value();
    return _opening ??= _open().whenComplete(() => _opening = null);
  }

  Future<void> _open() async {
    try {
      error.value = '';
      final directory = await getApplicationSupportDirectory();
      final path = p.join(directory.path, fileName);
      final file = File(path);

      final installed = await _prefs.getInt(AppStrings.spHadithDbVersion);
      final needsInstall =
          !await file.exists() || installed != assetVersion;

      if (needsInstall) {
        await _inflate(file);
        await _prefs.setInt(AppStrings.spHadithDbVersion, assetVersion);
      }

      _db = await openDatabase(path, readOnly: true);
      isReady.value = true;
    } catch (e, st) {
      debugPrint('HadithDatabase.open: $e\n$st');
      error.value = e.toString();
      isReady.value = false;
    }
  }

  /// Streams the gzipped asset through the gzip decoder straight to disk.
  ///
  /// The inflated file is ~113 MB, so it is never held in memory: the bytes go
  /// asset → decoder → sink. It is written to a temporary name and renamed
  /// only on success, so a kill mid-inflate leaves no half-written database
  /// that would then be opened and fail.
  Future<void> _inflate(File destination) async {
    final temporary = File('${destination.path}.part');
    if (await temporary.exists()) await temporary.delete();

    final packed = await rootBundle.load(assetPath);
    final bytes = packed.buffer.asUint8List(
      packed.offsetInBytes,
      packed.lengthInBytes,
    );

    final sink = temporary.openWrite();
    try {
      await sink.addStream(
        Stream<List<int>>.value(bytes).transform(gzip.decoder),
      );
      await sink.flush();
    } finally {
      await sink.close();
    }

    if (await destination.exists()) await destination.delete();
    await temporary.rename(destination.path);
  }

  /// Deletes the inflated copy. Used by আরও → অফলাইন ডাউনলোড to reclaim the
  /// space; the next open puts it back.
  Future<void> evict() async {
    await _db?.close();
    _db = null;
    isReady.value = false;

    final directory = await getApplicationSupportDirectory();
    final file = File(p.join(directory.path, fileName));
    if (await file.exists()) await file.delete();
    await _prefs.setInt(AppStrings.spHadithDbVersion, 0);
  }

  /// Bytes the inflated corpus occupies, for the settings row.
  Future<int> installedBytes() async {
    try {
      final directory = await getApplicationSupportDirectory();
      final file = File(p.join(directory.path, fileName));
      return await file.exists() ? await file.length() : 0;
    } catch (_) {
      return 0;
    }
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
    isReady.value = false;
  }
}

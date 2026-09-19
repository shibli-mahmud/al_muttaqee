import 'package:flutter_test/flutter_test.dart';

import 'package:al_muttaqee/src/core/utils/utils/notification_service.dart';
import 'package:al_muttaqee/src/module/notifications/models/adhan_settings_models.dart';
import 'package:al_muttaqee/src/module/prayer_times/models/prayer_log_models.dart';

void main() {
  group('AdhanSound', () {
    test('gives every sound its own channel', () {
      // Android fixes a notification's sound to its channel, so two sounds
      // sharing a channel id would silently play the wrong recording.
      final ids = AdhanSound.values.map((s) => s.channelId).toSet();
      expect(ids.length, AdhanSound.values.length);
    });

    test('the system default carries no raw resource', () {
      expect(AdhanSound.systemDefault.resourceName, isNull);
      for (final sound in AdhanSound.values) {
        if (sound == AdhanSound.systemDefault) continue;
        expect(sound.resourceName, isNotNull);
      }
    });

    test('no adhan channel collides with the silent or reminder channels', () {
      final ids = AdhanSound.values.map((s) => s.channelId).toList();
      expect(ids, isNot(contains(NotificationService.silentChannelId)));
      expect(ids, isNot(contains(NotificationService.reminderChannelId)));
    });
  });

  group('AdhanSetting', () {
    test('defaults to a full adhan, on time', () {
      const setting = AdhanSetting.defaults();
      expect(setting.mode, AdhanMode.adhan);
      expect(setting.preOffsetMinutes, 0);
      expect(setting.isSilent, isFalse);
      expect(setting.isOff, isFalse);
    });

    test('copyWith changes only what it is given', () {
      const base = AdhanSetting(
        mode: AdhanMode.adhan,
        sound: AdhanSound.makkah,
        preOffsetMinutes: 5,
      );
      final silenced = base.copyWith(mode: AdhanMode.silent);

      expect(silenced.isSilent, isTrue);
      expect(silenced.sound, AdhanSound.makkah);
      expect(silenced.preOffsetMinutes, 5);
    });
  });

  group('notification id space', () {
    test('prayer alerts cannot collide with the extra reminders', () {
      // Prayer ids are 1000 + dayOffset * 10 + prayer.index over a seven-day
      // window; the extras sit at 900. If either range moves, this is the test
      // that catches the overlap before a reminder cancels an adhan.
      final prayerIds = <int>{
        for (var day = 0; day < NotificationService.scheduleHorizonDays; day++)
          for (var i = 0; i < trackedPrayers.length + 1; i++)
            1000 + day * 10 + i,
      };
      final reminderIds =
          ExtraReminder.values.map((r) => r.notificationId).toSet();

      expect(prayerIds.intersection(reminderIds), isEmpty);
      expect(reminderIds.length, ExtraReminder.values.length);
    });
  });

  group('AlarmPermissionState', () {
    test('is only fully granted when all three gates are open', () {
      const all = AlarmPermissionState(
        notificationsGranted: true,
        exactAlarmsAllowed: true,
        batteryOptimisationIgnored: true,
      );
      expect(all.allGranted, isTrue);

      expect(all.copyWith(exactAlarmsAllowed: false).allGranted, isFalse);
      expect(all.copyWith(notificationsGranted: false).allGranted, isFalse);
      expect(all.copyWith(batteryOptimisationIgnored: false).allGranted, isFalse);
    });

    test('assumes nothing before the OS has been asked', () {
      const unknown = AlarmPermissionState.unknown();
      expect(unknown.allGranted, isFalse);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:al_muttaqee/src/module/zakat/controllers/zakat_controller.dart';

void main() {
  group('ZakatLine', () {
    test('survives the round trip through storage', () {
      const line = ZakatLine(
        id: 'gold',
        label: 'স্বর্ণ',
        amount: 123456.75,
        subLabel: '১২ ভরি',
      );

      final restored = ZakatLine.fromJson(line.toJson());

      expect(restored.id, 'gold');
      expect(restored.label, 'স্বর্ণ');
      expect(restored.amount, closeTo(123456.75, 0.001));
      expect(restored.subLabel, '১২ ভরি');
      expect(restored.isDeduction, isFalse);
    });

    test('copyWith leaves the identity alone', () {
      const line = ZakatLine(id: 'cash', label: 'নগদ', amount: 100);
      final updated = line.copyWith(amount: 500);

      expect(updated.id, 'cash');
      expect(updated.label, 'নগদ');
      expect(updated.amount, 500);
    });
  });

  group('constants', () {
    test('a bhori is the Bangladeshi tola', () {
      // 11.664 g. Getting this wrong misvalues every gram of gold a user
      // enters, so it is pinned.
      expect(ZakatController.gramsPerBhori, closeTo(11.664, 0.0001));
    });

    test('nisab thresholds are the classical weights', () {
      expect(ZakatController.goldNisabGrams, closeTo(87.48, 0.01));
      expect(ZakatController.silverNisabGrams, closeTo(612.36, 0.01));
    });

    test('the rate is two and a half percent', () {
      expect(ZakatController.zakatRate, 0.025);
    });

    test('silver nisab is the lower of the two at realistic rates', () {
      // Roughly today's Dhaka rates, in taka per gram.
      const goldPerGram = 12000.0;
      const silverPerGram = 130.0;

      final goldNisab = ZakatController.goldNisabGrams * goldPerGram;
      final silverNisab = ZakatController.silverNisabGrams * silverPerGram;

      // This is why silver is the default basis: it catches more people.
      expect(silverNisab, lessThan(goldNisab));
    });
  });
}

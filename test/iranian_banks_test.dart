import 'package:flutter_test/flutter_test.dart';
import 'package:iranian_banks/iranian_banks.dart';

void main() {
  group('BankService', () {
    test('returns correct bank info by card number', () {
      const cardNumber = '62198619'; // test card number is for blu bank
      final BankInfoView? bankInfo = IranianBanks.getBankFromCard(cardNumber);

      expect(bankInfo, isNotNull);
      expect(bankInfo?.name, equals('blubank'));
    });

    test('returns null for not find bank by cart number', () {
      final cardNumber = '0000000000000000'; // invalid card number
      final bankInfo = IranianBanks.getBankFromCard(cardNumber);

      expect(bankInfo, isNull);
    });

    test('returns correct bank info by IBAN number', () {
      const ibanNumber = 'IR850140040000310011296780';
      final bankInfo = IranianBanks.getBankFromIban(ibanNumber);

      expect(bankInfo, isNotNull);
    });

    test('returns null for not find bank info by IBAN number', () {
      const ibanNumber = 'IR00000';
      final bankInfo = IranianBanks.getBankFromIban(ibanNumber);

      expect(bankInfo, isNull);
    });

    test('returns true for valid card number', () {
      final cardNumber = '6280231348159681';
      final bool validationCardNumber =
          IranianBanks.verifyCardNumber(cardNumber);

      expect(validationCardNumber, isTrue);
    });

    test('returns false for invalid card number', () {
      final cardNumber = '1111000000000000';
      final bool validationCardNumber =
          IranianBanks.verifyCardNumber(cardNumber);

      expect(validationCardNumber, isFalse);
    });
  });
}

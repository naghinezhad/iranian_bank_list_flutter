import 'package:iranian_banks/src/model/bank_data_model.dart';
import 'package:iranian_banks/src/model/bank_view_model.dart';

/// A service class providing static methods to interact with Iranian bank data.
class IranianBanks {
  /// Finds a bank based on the provided card number's prefix (BIN).
  ///
  /// Returns a [BankInfoView] object if a match is found, otherwise returns `null`.
  static BankInfoView? getBankFromCard(String cardNumber) {
    final cleanCardNumber = cardNumber.replaceAll(RegExp(r'\s|-'), '');
    if (cleanCardNumber.length < 6) return null;

    final result = iranianBank.where(
      (b) => RegExp(b.cardRegex).hasMatch(cleanCardNumber),
    );
    return result.isNotEmpty ? BankInfoView.from(result.first) : null;
  }

  /// Finds a bank based on the provided IBAN.
  ///
  /// It checks the bank identifier code within the IBAN string.
  /// Returns a [BankInfoView] object if a match is found, otherwise returns `null`.
  static BankInfoView? getBankFromIban(String iban) {
    final cleanIban = iban.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    if (cleanIban.length < 7) return null;

    final result = iranianBank.where(
      (b) => RegExp(b.ibanRegex).hasMatch(cleanIban),
    );
    return result.isNotEmpty ? BankInfoView.from(result.first) : null;
  }

  /// Verifies a 16-digit card number using the Luhn algorithm.
  ///
  /// Returns `true` if the card number is valid, otherwise `false`.
  static bool verifyCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\s|-'), '');

    if (cardNumber.length != 16) return false;

    if (int.tryParse(cardNumber) == null) return false;

    int sum = 0;
    for (int i = 0; i < 16; i++) {
      int digit = int.parse(cardNumber[i]);
      if (i % 2 == 0) {
        digit *= 2;
        if (digit > 9) digit -= 9;
      }
      sum += digit;
    }
    return sum % 10 == 0;
  }

  /// Verifies an Iranian IBAN using the MOD-97 algorithm.
  ///
  /// The IBAN must be 26 characters long and start with 'IR'.
  /// Returns `true` if the IBAN is valid, otherwise `false`.
  static bool verifyIBAN(String iban) {
    iban = iban.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    if (!iban.startsWith('IR') || iban.length != 26) return false;

    final String rearrangedIban = iban.substring(4) + iban.substring(0, 4);

    String numericIban = '';
    for (int i = 0; i < rearrangedIban.length; i++) {
      final charCode = rearrangedIban.codeUnitAt(i);
      // Character is a letter
      if (charCode >= 65 && charCode <= 90) {
        numericIban += (charCode - 55).toString();
      } else {
        numericIban += rearrangedIban[i];
      }
    }

    try {
      final BigInt ibanAsInt = BigInt.parse(numericIban);
      return ibanAsInt % BigInt.from(97) == BigInt.one;
    } catch (e) {
      return false;
    }
  }

  /// Returns an unmodifiable list of all raw [BankData] objects.
  static List<BankData> get allBanks => List.unmodifiable(iranianBank);
}

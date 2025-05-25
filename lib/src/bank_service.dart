import 'package:iranian_banks/src/model/bank_data_model.dart';
import 'package:iranian_banks/src/model/bank_view_model.dart';

class IranianBanks {
  static final List<IranianBanks> _banks = [];

  static BankInfoView? getBankFromCard(String cardNumber) {
    final result = iranianBank.where(
      (b) => RegExp(b.cardRegex).hasMatch(cardNumber),
    );
    return result.isNotEmpty ? BankInfoView.from(result.first) : null;
  }

  static BankInfoView? getBankFromIban(String iban) {
    if (iban.length < 7) return null;

    final result = iranianBank.where(
      (b) => RegExp(b.ibanRegex).hasMatch(iban),
    );
    return result.isNotEmpty ? BankInfoView.from(result.first) : null;
  }

  static bool verifyCardNumber(String cardNumber) {
    cardNumber = cardNumber.replaceAll(RegExp(r'\s|-'), '');

    if (cardNumber.length != 16) return false;

    if (!RegExp(r'^\d{16}$').hasMatch(cardNumber)) return false;

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

  static bool verifyIBAN(String iban) {
    iban = iban.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    if (!iban.startsWith('IR') || iban.length != 26) return false;

    String numericiban = '${iban.substring(4)}1827'; // IR → 18 27
    for (int i = 4; i < iban.length; i++) {
      final String char = iban[i];
      if (RegExp(r'[0-9]').hasMatch(char)) {
        numericiban += char;
      } else if (RegExp(r'[A-Z]').hasMatch(char)) {
        numericiban += (char.codeUnitAt(0) - 55).toString();
      } else {
        return false;
      }
    }

    // mod-97
    final BigInt number = BigInt.parse(numericiban);
    return number % BigInt.from(97) == BigInt.one;
  }

  static List<BankData> get allBanks => List.unmodifiable(_banks);
}

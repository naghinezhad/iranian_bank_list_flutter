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

  static bool verifyCard(String cardNumber) {
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

    if (!iban.startsWith('IR') || iban.length != 26) {
      return false;
    }

    final String rearrangedIban = iban.substring(4) + iban.substring(0, 4);

    String numericIban = '';
    for (int i = 0; i < rearrangedIban.length; i++) {
      final charCode = rearrangedIban.codeUnitAt(i);
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

  static List<BankData> get allBanks => List.unmodifiable(_banks);
}

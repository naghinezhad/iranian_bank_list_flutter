import 'dart:convert';
import 'package:flutter/services.dart';

import 'bank_model.dart';

class IranianBanks {
  static final List<IranianBank> _banks = [];

  static Future<void> init() async {
    if (_banks.isNotEmpty) return;

    final data = await rootBundle.loadString(
      'packages/iranian_banks/assets/banks.json',
    );

    final List<dynamic> jsonData = json.decode(data);
    _banks.clear();
    _banks.addAll(jsonData.map((e) {
      final logoPath =
          'packages/iranian_banks/${e['bank_logo'].replaceFirst('./', 'assets/')}';

      return IranianBank.fromJson({
        ...e,
        'bank_logo': logoPath,
      });
    }));
  }

  static IranianBank? getBankByCardNumber(String cardNumber) {
    for (var bank in _banks) {
      final regex = RegExp(bank.cardRegex);
      if (regex.hasMatch(cardNumber)) {
        return bank;
      }
    }
    return null;
  }

  static IranianBank? getBankByIBAN(String iban) {
    for (var bank in _banks) {
      final regex = RegExp(bank.ibanRegex);
      if (regex.hasMatch(iban)) {
        return bank;
      }
    }
    return null;
  }

  static bool? verifyCardNumber(String cardNumber) {
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

  static bool? verifyIBAN(String iban) {
    iban = iban.replaceAll(RegExp(r'\s+'), '').toUpperCase();

    if (!iban.startsWith('IR') || iban.length != 26) return false;

    String numericiban = iban.substring(4) + '1827'; // IR → 18 27
    for (int i = 4; i < iban.length; i++) {
      String char = iban[i];
      if (RegExp(r'[0-9]').hasMatch(char)) {
        numericiban += char;
      } else if (RegExp(r'[A-Z]').hasMatch(char)) {
        numericiban += (char.codeUnitAt(0) - 55).toString();
      } else {
        return false;
      }
    }

    // mod-97
    BigInt number = BigInt.parse(numericiban);
    return number % BigInt.from(97) == BigInt.one;
  }

  static List<IranianBank> get allBanks => List.unmodifiable(_banks);
}

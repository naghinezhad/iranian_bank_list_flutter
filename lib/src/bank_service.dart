import 'dart:convert';
import 'package:flutter/services.dart';

import 'bank_model.dart';

class IranianBankInfo {
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

  static IranianBank? findByPrefixCardNumber(String cardNumber) {
    for (var bank in _banks) {
      final regex = RegExp(bank.prefix_card_regex);
      if (regex.hasMatch(cardNumber)) {
        return bank;
      }
    }
    return null;
  }

  static IranianBank? findByCardNumber(String cardNumber) {
    for (var bank in _banks) {
      final regex = RegExp(bank.cardRegex);
      if (regex.hasMatch(cardNumber)) {
        return bank;
      }
    }
    return null;
  }

  static IranianBank? findByPrefixIBAN(String iban) {
    for (var bank in _banks) {
      final regex = RegExp(bank.prefix_iban_regex);
      if (regex.hasMatch(iban)) {
        return bank;
      }
    }
    return null;
  }

  static IranianBank? findByIBAN(String iban) {
    for (var bank in _banks) {
      final regex = RegExp(bank.ibanRegex);
      if (regex.hasMatch(iban)) {
        return bank;
      }
    }
    return null;
  }

  static List<IranianBank> get allBanks => List.unmodifiable(_banks);
}

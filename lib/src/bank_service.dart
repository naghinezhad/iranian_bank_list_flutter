import 'dart:convert';
import 'package:flutter/services.dart';

import 'bank_model.dart';

class IranianBankInfo {
  static final List<IranianBank> _banks = [];

  /// لود کردن اطلاعات از فایل json داخل پکیج
  static Future<void> init() async {
    if (_banks.isNotEmpty) return;

    final data = await rootBundle.loadString(
      'packages/iranian_banks/assets/banks.json',
    );

    final List<dynamic> jsonData = json.decode(data);
    _banks.clear();
    _banks.addAll(jsonData.map((e) {
      // مسیر لوگو را به مسیر کامل داخل پکیج تبدیل می‌کنیم
      final logoPath =
          'packages/iranian_banks/${e['bank_logo'].replaceFirst('./', 'assets/')}';

      return IranianBank.fromJson({
        ...e,
        'bank_logo': logoPath,
      });
    }));
  }

  /// پیدا کردن بانک بر اساس شماره کارت
  static IranianBank? findByCardNumber(String cardNumber) {
    // var reformCardNumber = cardNumber;
    // if (reformCardNumber.length != 16) {
    //   for (var i = reformCardNumber.length; i < 16; i++) {
    //     reformCardNumber = reformCardNumber + '0';
    //   }
    // }
    for (var bank in _banks) {
      final regex = RegExp(bank.cardRegex);
      if (regex.hasMatch(cardNumber)) {
        return bank;
      }
    }
    return null;
  }

  /// پیدا کردن بانک بر اساس شماره شبا
  static IranianBank? findByIBAN(String iban) {
    for (var bank in _banks) {
      final regex = RegExp(bank.ibanRegex);
      if (regex.hasMatch(iban)) {
        return bank;
      }
    }
    return null;
  }

  /// لیست کامل بانک‌ها
  static List<IranianBank> get allBanks => List.unmodifiable(_banks);
}

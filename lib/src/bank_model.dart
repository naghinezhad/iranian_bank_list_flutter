import 'package:flutter/widgets.dart';

class IranianBank {
  IranianBank({
    required this.bankName,
    required this.bankTitle,
    required this.bankLogoPath,
    required this.mainColor,
    required this.lighterColor,
    required this.darkerColor,
    required this.iban,
    required this.cardRegex,
    required this.ibanRegex,
  });

  factory IranianBank.fromJson(Map<dynamic, dynamic> json) {
    return IranianBank(
      bankName: json['bank_name'],
      bankTitle: json['bank_title'],
      bankLogoPath: json['bank_logo'],
      mainColor: _hexToColor(json['color']),
      lighterColor: _hexToColor(json['lighter_color']),
      darkerColor: _hexToColor(json['darker_color']),
      iban: json['iban'],
      cardRegex: json['card_regex'],
      ibanRegex: json['iban_regex'],
    );
  }

  final String bankLogoPath;
  final String bankName;
  final String bankTitle;
  final String cardRegex;
  final Color darkerColor;
  final String iban;
  final String ibanRegex;
  final Color lighterColor;
  final Color mainColor;

  /// Change the color from #ffffff (example) to the Color object.
  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IranianBank {
  IranianBank({
    required this.bankName,
    required this.bankTitle,
    required this.bankLogoPath,
    required this.iban,
    required this.cardRegex,
    required this.ibanRegex,
    required this.prefix_card_regex,
    required this.prefix_iban_regex,
    required this.mainColor,
    required this.lighterColor,
    required this.darkerColor,
  });

  factory IranianBank.fromJson(Map<String, dynamic> json) {
    return IranianBank(
      bankName: json['bank_name'],
      bankTitle: json['bank_title'],
      bankLogoPath: json['bank_logo'],
      iban: json['iban'],
      cardRegex: json['card_regex'],
      ibanRegex: json['iban_regex'],
      prefix_card_regex: json['prefix_card_regex'],
      prefix_iban_regex: json['prefix_iban_regex'],
      mainColor: _hexToColor(json['color']),
      lighterColor: _hexToColor(json['lighter_color']),
      darkerColor: _hexToColor(json['darker_color']),
    );
  }

  final String bankLogoPath;
  final String bankName;
  final String bankTitle;
  final String cardRegex;
  final String iban;
  final String ibanRegex;
  final String prefix_card_regex;
  final String prefix_iban_regex;
  final Color mainColor;
  final Color lighterColor;
  final Color darkerColor;

  /// logo builder from svg path
  SvgPicture logoBuilder({
    double width = 40,
    double height = 40,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      bankLogoPath.replaceFirst('./', 'assets/'),
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// change the color like #FFFFFF (example) to the Color object like 0xFFFFFFFF.
  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

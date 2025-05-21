import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IranianBank {
  IranianBank(
      {required this.name,
      required this.title,
      required this.logoPath,
      required this.iban,
      required this.cardRegex,
      required this.ibanRegex,
      required this.mainColor,
      required this.lighterColor,
      required this.darkerColor,
      required this.secondaryColor});

  factory IranianBank.fromJson(Map<String, dynamic> json) {
    return IranianBank(
      name: json['bank_name'],
      title: json['bank_title'],
      logoPath: json['bank_logo'],
      iban: json['iban'],
      cardRegex: json['card_regex'],
      ibanRegex: json['iban_regex'],
      mainColor: _hexToColor(json['color']),
      lighterColor: _hexToColor(json['lighter_color']),
      darkerColor: _hexToColor(json['darker_color']),
      secondaryColor: _hexToColor(json['secondary_color']),
    );
  }

  final String logoPath;
  final String name;
  final String title;
  final String cardRegex;
  final String iban;
  final String ibanRegex;
  final Color mainColor;
  final Color lighterColor;
  final Color darkerColor;
  final Color secondaryColor;

  /// logo builder from svg path
  SvgPicture logoBuilder({
    double width = 40,
    double height = 40,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      logoPath.replaceFirst('./', 'assets/'),
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

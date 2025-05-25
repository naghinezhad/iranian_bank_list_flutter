import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iranian_banks/src/model/bank_data_model.dart';

class BankInfoView {
  final String bankName;
  final String bankTitle;
  final String bankLogo;
  final String color;
  final String lighterColor;
  final String darkerColor;
  final String secondaryColor;

  const BankInfoView({
    required this.bankName,
    required this.bankTitle,
    required this.bankLogo,
    required this.color,
    required this.lighterColor,
    required this.darkerColor,
    required this.secondaryColor,
  });

  Color get primaryColor => _hexToColor(color);
  Color get secondary => _hexToColor(secondaryColor);
  Color get lighter => _hexToColor(lighterColor);
  Color get darker => _hexToColor(darkerColor);

  factory BankInfoView.from(BankData data) {
    return BankInfoView(
      bankName: data.bankName,
      bankTitle: data.bankTitle,
      bankLogo: data.bankLogo,
      color: data.color,
      lighterColor: data.lighterColor,
      darkerColor: data.darkerColor,
      secondaryColor: data.secondaryColor,
    );
  }
  SvgPicture logoBuilder({
    double width = 40,
    double height = 40,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      bankLogo.replaceFirst('./', 'assets/'),
      width: width,
      height: height,
      fit: fit,
    );
  }

  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

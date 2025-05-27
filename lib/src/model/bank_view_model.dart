import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iranian_banks/src/model/bank_data_model.dart';

class BankInfoView {
  final String name;
  final String title;
  final String logoPath;
  final Color primaryColor;
  final Color lighterColor;
  final Color darkerColor;
  final Color secondaryColor;

  const BankInfoView({
    required this.name,
    required this.title,
    required this.logoPath,
    required this.primaryColor,
    required this.lighterColor,
    required this.darkerColor,
    required this.secondaryColor,
  });

  factory BankInfoView.from(BankData data) {
    return BankInfoView(
      name: data.bankName,
      title: data.bankTitle,
      logoPath:
          data.bankLogo.replaceFirst('./', 'packages/iranian_banks/assets/'),
      primaryColor: _hexToColor(data.color),
      lighterColor: _hexToColor(data.lighterColor),
      darkerColor: _hexToColor(data.darkerColor),
      secondaryColor: _hexToColor(data.secondaryColor),
    );
  }
  SvgPicture logoBuilder({
    double width = 40,
    double height = 40,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      logoPath.replaceFirst('./', 'packages/iranian_banks/assets/'),
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

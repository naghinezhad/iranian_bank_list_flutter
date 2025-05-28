import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iranian_banks/src/model/bank_data_model.dart';

/// A UI-ready model representing a bank's information.
///
/// This class holds processed data, such as [Color] objects and the full asset path
/// for logos, ready to be used directly in Flutter widgets.
class BankInfoView {
  /// The unique machine-readable name of the bank.
  final String name;

  /// The official human-readable title of the bank.
  final String title;

  /// The full asset path to the SVG logo, ready for use in [SvgPicture.asset].
  final String logoPath;

  /// The primary color of the bank.
  final Color primaryColor;

  /// A lighter shade of the primary color.
  final Color lighterColor;

  /// A darker shade of the primary color.
  final Color darkerColor;

  /// A color that's clearly legible when drawn on primary.
  final Color onPrimaryColor;

  /// Creates an instance of [BankInfoView].
  const BankInfoView({
    required this.name,
    required this.title,
    required this.logoPath,
    required this.primaryColor,
    required this.lighterColor,
    required this.darkerColor,
    required this.onPrimaryColor,
  });

  /// A factory constructor to create a [BankInfoView] from a raw [BankData] object.
  ///
  /// This handles the conversion of hex color strings to [Color] objects and
  /// constructs the correct asset path for the package.
  factory BankInfoView.from(BankData data) {
    return BankInfoView(
      name: data.bankName,
      title: data.bankTitle,
      logoPath:
          'packages/iranian_banks/assets/${data.bankLogo.replaceFirst('./', '')}',
      primaryColor: _hexToColor(data.color),
      lighterColor: _hexToColor(data.lighterColor),
      darkerColor: _hexToColor(data.darkerColor),
      onPrimaryColor: _hexToColor(data.onPrimaryColor),
    );
  }

  /// A convenience method to build the bank's logo as an [SvgPicture] widget.
  SvgPicture logoBuilder({
    double width = 40,
    double height = 40,
    BoxFit fit = BoxFit.contain,
  }) {
    return SvgPicture.asset(
      logoPath, // Uses the already-corrected path.
      width: width,
      height: height,
      fit: fit,
    );
  }

  /// A static helper to convert a hex color string to a [Color] object.
  static Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}

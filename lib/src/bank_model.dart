class IranianBank {
  final String bankName;
  final String bankTitle;
  final String bankLogoPath;
  final String color;
  final String lighterColor;
  final String darkerColor;
  final String iban;
  final String cardRegex;
  final String ibanRegex;

  IranianBank({
    required this.bankName,
    required this.bankTitle,
    required this.bankLogoPath,
    required this.color,
    required this.lighterColor,
    required this.darkerColor,
    required this.iban,
    required this.cardRegex,
    required this.ibanRegex,
  });

  factory IranianBank.fromJson(Map<String, dynamic> json) {
    return IranianBank(
      bankName: json['bank_name'],
      bankTitle: json['bank_title'],
      bankLogoPath: json['bank_logo'],
      color: json['color'],
      lighterColor: json['lighter_color'],
      darkerColor: json['darker_color'],
      iban: json['iban'],
      cardRegex: json['card_regex'],
      ibanRegex: json['iban_regex'],
    );
  }
}

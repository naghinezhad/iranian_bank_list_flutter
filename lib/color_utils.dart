import 'package:flutter/animation.dart';

Color hexToColor(String hex) {
  hex = hex.replaceAll('#', '');
  if (hex.length == 6) hex = 'FF$hex'; // اگر شفافیت مشخص نشده، کامل کن
  return Color(int.parse('0x$hex'));
}

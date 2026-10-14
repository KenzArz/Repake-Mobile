import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Base
  static const charcoal = Color(0xFF202320);
  static const lime = Color(0xFFB8D94E);
  static const offWhite = Color(0xFFF5F5F0);
  static const gray = Color(0xFFD9DBD5);

  // Neutral scale
  static const neutral50 = Color(0xFFF5F5F0);
  static const neutral100 = Color(0xFFEAEBE6);
  static const neutral200 = Color(0xFFD9DBD5);
  static const neutral300 = Color(0xFFC2C4BE);
  static const neutral400 = Color(0xFFA4A6A1);
  static const neutral500 = Color(0xFF868984);
  static const neutral600 = Color(0xFF6A6D69);
  static const neutral700 = Color(0xFF515450);
  static const neutral800 = Color(0xFF3A3C39);
  static const neutral900 = Color(0xFF202320);

  // Lime scale
  static const lime50 = Color(0xFFEFF2E0);
  static const lime100 = Color(0xFFE6EEC8);
  static const lime200 = Color(0xFFDAE8A7);
  static const lime300 = Color(0xFFCDE387);
  static const lime400 = Color(0xFFC1DD66);
  static const lime500 = Color(0xFFB8D94E);
  static const lime600 = Color(0xFF9DB846);
  static const lime700 = Color(0xFF81973D);
  static const lime800 = Color(0xFF647535);
  static const lime900 = Color(0xFF46502C);

  // Semantic (base = warna status, tint = latar badge, shade = teks di atas tint)
  static const successBase = Color(0xFF4C8B4A);
  static const successTint = Color(0xFFE1E8DC);
  static const successShade = Color(0xFF365735);
  static const warningBase = Color(0xFFD9A23B);
  static const warningTint = Color(0xFFF2EBDA);
  static const warningShade = Color(0xFF7C622E);
  static const errorBase = Color(0xFFC1543F);
  static const errorTint = Color(0xFFEFE2DB);
  static const errorShade = Color(0xFF703C30);
  static const infoBase = Color(0xFF4E7DA6);
  static const infoTint = Color(0xFFE1E7E7);
  static const infoShade = Color(0xFF375063);

  // Surface / border / text
  static const surfacePage = neutral50;
  static const surfaceElevated = Color(0xFFFFFFFF);
  static const surfaceInverse = neutral900;
  static const borderDefault = neutral200;
  static const borderStrong = neutral400;
  static const textPrimary = neutral900;
  static const textSecondary = neutral600;
  static const textMuted = neutral500;
  static const textOnInverse = neutral50;
  static const textOnDark =
      Color(0xFFFFFFFF); // Putih untuk text di atas dark background

  // Additional colors
  static const ratingYellow = Color(0xFFFFC107); // Star rating color

  // Brand colors
  static const googleBlue = Color(0xFF4285F4);
  static const googleRed = Color(0xFFEA4335);
  static const googleYellow = Color(0xFFFBBC05);
  static const googleGreen = Color(0xFF34A853);
}

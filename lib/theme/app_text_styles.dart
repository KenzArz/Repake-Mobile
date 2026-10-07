import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle display() => GoogleFonts.bricolageGrotesque(
        fontSize: 40,
        height: 1.05,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      );

  static TextStyle h1() => GoogleFonts.bricolageGrotesque(
        fontSize: 32,
        height: 1.1,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle h2() => GoogleFonts.bricolageGrotesque(
        fontSize: 28,
        height: 1.15,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle h3() => GoogleFonts.bricolageGrotesque(
        fontSize: 24,
        height: 1.2,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle h4() => GoogleFonts.bricolageGrotesque(
        fontSize: 20,
        height: 1.3,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle h5() => GoogleFonts.bricolageGrotesque(
        fontSize: 18,
        height: 1.4,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle bodyLarge() => GoogleFonts.manrope(
        fontSize: 17,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle body() => GoogleFonts.manrope(
        fontSize: 16,
        height: 1.6,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle label() => GoogleFonts.bricolageGrotesque(
        fontSize: 14,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle smallLabel() => GoogleFonts.bricolageGrotesque(
        fontSize: 12,
        height: 1.5,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle caption() => GoogleFonts.manrope(
        fontSize: 12,
        height: 1.4,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );
}

import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    const scheme = ColorScheme.light(
      primary: AppColors.lime,
      onPrimary: AppColors.charcoal,
      secondary: AppColors.neutral800,
      onSecondary: AppColors.neutral50,
      surface: AppColors.surfaceElevated,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.borderStrong,
      outlineVariant: AppColors.borderDefault,
      error: AppColors.errorBase,
      onError: Colors.white,
      inverseSurface: AppColors.surfaceInverse,
      onInverseSurface: AppColors.textOnInverse,
    );

    final textTheme = TextTheme(
      displayLarge: AppTextStyles.display(),
      headlineLarge: AppTextStyles.h1(),
      headlineMedium: AppTextStyles.h2(),
      headlineSmall: AppTextStyles.h3(),
      titleLarge: AppTextStyles.h4(),
      titleMedium: AppTextStyles.h5(),
      bodyLarge: AppTextStyles.bodyLarge(),
      bodyMedium: AppTextStyles.body(),
      bodySmall: AppTextStyles.caption(),
      labelLarge: AppTextStyles.label(),
      labelSmall: AppTextStyles.smallLabel(),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.surfacePage,
      textTheme: textTheme,
      dividerColor: AppColors.borderDefault,
    );
  }
}

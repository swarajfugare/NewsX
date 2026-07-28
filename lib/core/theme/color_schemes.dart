import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppColorSchemes {
  AppColorSchemes._();

  static const ColorScheme darkColorScheme = ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF4F46E5),
    onPrimaryContainer: Colors.white,
    secondary: AppColors.secondary,
    onSecondary: Colors.black,
    surface: AppColors.darkSurface,
    onSurface: AppColors.darkTextPrimary,
    surfaceContainerHighest: AppColors.darkSurfaceVariant,
    onSurfaceVariant: AppColors.darkTextSecondary,
    background: AppColors.darkBackground,
    onBackground: AppColors.darkTextPrimary,
    error: AppColors.accentRose,
    onError: Colors.white,
    outline: AppColors.darkBorder,
  );

  static const ColorScheme lightColorScheme = ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFEEF2FF),
    onPrimaryContainer: Color(0xFF3730A3),
    secondary: AppColors.secondary,
    onSecondary: Colors.white,
    surface: AppColors.lightSurface,
    onSurface: AppColors.lightTextPrimary,
    surfaceContainerHighest: AppColors.lightSurfaceVariant,
    onSurfaceVariant: AppColors.lightTextSecondary,
    background: AppColors.lightBackground,
    onBackground: AppColors.lightTextPrimary,
    error: AppColors.accentRose,
    onError: Colors.white,
    outline: AppColors.lightBorder,
  );
}

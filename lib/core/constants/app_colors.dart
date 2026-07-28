import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Dark Theme Palette
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B);    // Slate 800
  static const Color darkSurfaceVariant = Color(0xFF334155); // Slate 700
  static const Color darkCard = Color(0xFF1E293B);
  
  // Light Theme Palette
  static const Color lightBackground = Color(0xFFF8FAFC); // Slate 50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9); // Slate 100
  static const Color lightCard = Color(0xFFFFFFFF);

  // Primary Brand Colors
  static const Color primary = Color(0xFF6366F1);        // Indigo 500
  static const Color primaryGradientStart = Color(0xFF6366F1);
  static const Color primaryGradientEnd = Color(0xFF8B5CF6);  // Purple 500
  
  // Accent Colors
  static const Color secondary = Color(0xFF06B6D4);      // Cyan 500
  static const Color accentRose = Color(0xFFF43F5E);      // Rose 500
  static const Color accentAmber = Color(0xFFF59E0B);     // Amber 500
  static const Color accentEmerald = Color(0xFF10B981);   // Emerald 500
  static const Color accentViolet = Color(0xFF8B5CF6);    // Violet 500

  // Text Colors Dark
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkTextMuted = Color(0xFF64748B);

  // Text Colors Light
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF475569);
  static const Color lightTextMuted = Color(0xFF94A3B8);

  // Borders & Dividers
  static const Color darkBorder = Color(0xFF334155);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Glassmorphism Overlay Colors
  static Color darkGlassOverlay = Colors.black.withValues(alpha: 0.4);
  static Color lightGlassOverlay = Colors.white.withValues(alpha: 0.7);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient reelsOverlayGradient = LinearGradient(
    colors: [
      Colors.transparent,
      Color(0x80000000),
      Color(0xFFA000000),
      Color(0xFF0F172A),
    ],
    stops: [0.0, 0.4, 0.75, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

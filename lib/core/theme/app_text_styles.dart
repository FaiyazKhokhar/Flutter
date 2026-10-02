import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Sora Bold 40/48
  static TextStyle display = GoogleFonts.sora(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 48 / 40,
    letterSpacing: -1,
    color: AppColors.textPrimary,
  );

  // Sora SemiBold 24/32
  static TextStyle h2 = GoogleFonts.sora(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    color: AppColors.textPrimary,
  );

  // Sora Regular 16/24
  static TextStyle h3 = GoogleFonts.sora(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textPrimary,
  );

  // Inter 16/24
  static TextStyle body = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textSecondary,
  );

  // Inter 14/20
  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    color: AppColors.textSecondary,
  );

  // Uppercase label: JetBrains Mono 14/16, ls 0.7
  static TextStyle label = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 16 / 14,
    letterSpacing: 0.7,
    color: AppColors.textSecondary,
  );

  // Button label
  static TextStyle button = GoogleFonts.jetBrainsMono(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 16 / 14,
    letterSpacing: 0.7,
    color: AppColors.bg,
  );

  // Caption 12/14, ls 0.6
  static TextStyle caption = GoogleFonts.jetBrainsMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 14 / 12,
    letterSpacing: 0.6,
    color: AppColors.textMuted,
  );
}
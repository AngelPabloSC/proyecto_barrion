// lib/theme/theme.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_barrion/core/constants/constants.dart';
import 'package:google_fonts/google_fonts.dart';


ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    iconTheme: const IconThemeData(color: AppColors.contentColorLight),
    progressIndicatorTheme:
    const ProgressIndicatorThemeData(color: AppColors.tertiaryColor),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: AppColors.contentColorLight,
      fontFamily: 'visby',
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.primaryColor;
        }
        return null;
      }),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.textButtonLight),
    ),
    cardTheme: const CardTheme(color: Color(0xFFF9F9F9)),
    dividerTheme: DividerThemeData(color: Colors.grey[350]),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.secondaryColor;
        }
        return AppColors.textButtonLight;
      }),
    ),
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor).copyWith(
      background: AppColors.backgroundLight,
      primary: AppColors.primaryColor,
      secondary: AppColors.secondaryColor,
      error: AppColors.errorColor,
      onPrimary: Colors.black,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      unselectedItemColor: AppColors.contentColorLight.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: AppColors.primaryColor),
      showUnselectedLabels: true,
    ),
  );
}

// Tema Oscuro
ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.backgroundDark,

    iconTheme: const IconThemeData(color: AppColors.contentColorDark),
    progressIndicatorTheme:
    const ProgressIndicatorThemeData(color: AppColors.tertiaryColor),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
      bodyColor: AppColors.contentColorDark,
      fontFamily: 'visby',
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color?>((states) {
        if (states.contains(MaterialState.selected)) {
          return AppColors.tertiaryColor;
        }
        return null;
      }),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.textButtonDark),
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryColor,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.secondaryColor,
      secondary: AppColors.primaryColor,
      error: AppColors.errorColor,
      onPrimary: Colors.white,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundDark,
      unselectedItemColor: AppColors.contentColorDark.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: AppColors.tertiaryColor),
      showUnselectedLabels: true,
    ),
  );
}
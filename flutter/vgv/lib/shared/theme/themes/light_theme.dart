import 'package:flutter/material.dart';
import 'package:vgv/shared/theme/colors.dart';

/// Gets the light theme configuration
ThemeData getLightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimaryContainer: AppColors.lightOnBackground,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      secondaryContainer: AppColors.lightSecondaryContainer,
      onSecondaryContainer: AppColors.lightOnBackground,
      tertiary: AppColors.lightSecondary,
      onTertiary: AppColors.lightOnSecondary,
      tertiaryContainer: AppColors.lightSecondaryContainer,
      onTertiaryContainer: AppColors.lightOnBackground,
      error: AppColors.lightError,
      onError: AppColors.lightOnError,
      errorContainer: AppColors.lightErrorContainer,
      onErrorContainer: AppColors.lightOnBackground,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
      surfaceContainerHighest: AppColors.lightSurface,
      onSurfaceVariant: AppColors.lightOnSurface.withOpacity(0.7),
      outline: AppColors.lightBorder,
      outlineVariant: AppColors.lightBorder.withOpacity(0.5),
      shadow: Colors.black.withOpacity(0.05),
      scrim: Colors.black.withOpacity(0.3),
      inverseSurface: AppColors.darkSurface,
      onInverseSurface: AppColors.darkOnSurface,
      inversePrimary: AppColors.darkPrimary,
      surfaceTint: Colors.transparent,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightSurface,
      foregroundColor: AppColors.lightOnSurface,
      elevation: 0,
      centerTitle: true,
      scrolledUnderElevation: 0.5,
    ),
    cardTheme: CardTheme(
      color: AppColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.lightBorder.withOpacity(0.5)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.lightOnPrimary,
        backgroundColor: AppColors.lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        minimumSize: const Size(44, 44),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        side: const BorderSide(color: AppColors.lightBorder),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightBorder.withOpacity(0.5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.lightBorder.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightPrimary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightError),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.lightError),
      ),
      errorStyle: const TextStyle(color: AppColors.lightError),
      labelStyle: TextStyle(color: AppColors.lightOnSurface.withOpacity(0.7)),
      hintStyle: TextStyle(color: AppColors.lightOnSurface.withOpacity(0.5)),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.lightBorder,
      thickness: 0.5,
      space: 1,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.lightDisabled;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightPrimary;
        }
        return AppColors.lightBackground;
      }),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      side: const BorderSide(color: AppColors.lightBorder),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.lightDisabled;
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightOnPrimary;
        }
        return Colors.white;
      }),
      trackColor: MaterialStateProperty.resolveWith<Color>((states) {
        if (states.contains(MaterialState.disabled)) {
          return AppColors.lightDisabled.withOpacity(0.3);
        }
        if (states.contains(MaterialState.selected)) {
          return AppColors.lightPrimary;
        }
        return AppColors.lightBorder;
      }),
      trackOutlineColor: MaterialStateProperty.all(Colors.transparent),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      indicatorColor: Colors.transparent,
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.lightPrimary,
          );
        }
        return TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.lightOnSurface.withOpacity(0.6),
        );
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(
            color: AppColors.lightPrimary,
            size: 24,
          );
        }
        return IconThemeData(
          color: AppColors.lightOnSurface.withOpacity(0.6),
          size: 24,
        );
      }),
      elevation: 0,
      height: 60,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.lightSurface,
      selectedItemColor: AppColors.lightPrimary,
      unselectedItemColor: AppColors.lightOnSurface.withOpacity(0.6),
      selectedLabelStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      unselectedLabelStyle:
          const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    textTheme: ThemeData.light().textTheme.apply(
          bodyColor: AppColors.lightOnSurface,
          displayColor: AppColors.lightOnSurface,
        ),
  );
}

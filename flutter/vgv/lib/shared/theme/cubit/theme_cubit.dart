import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit to manage the app's theme state
class ThemeCubit extends Cubit<ThemeMode> {
  /// Creates a new ThemeCubit instance
  ThemeCubit() : super(ThemeMode.system);

  /// Toggles between light and dark theme
  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}

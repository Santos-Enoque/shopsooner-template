import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit to manage the app's language state
class LanguageCubit extends Cubit<Locale> {
  /// Creates a new LanguageCubit instance
  LanguageCubit() : super(const Locale('en'));

  /// Changes the app's language
  void changeLanguage(Locale locale) {
    emit(locale);
  }
}

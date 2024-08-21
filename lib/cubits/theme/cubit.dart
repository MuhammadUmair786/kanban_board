import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/custom_utils.dart';

part 'state.dart';

class ThemeLocaleCubit extends Cubit<ThemeState> {
  ThemeLocaleCubit()
      : super(ThemeState(themeData: getSavedTheme(), locale: getSavedLocale()));

  Future<void> changeTheme(String themeName) async {
    await saveThemeLocally(themeName);

    emit(
      ThemeState(
        themeData: getSavedTheme(),
        locale: getSavedLocale(),
      ),
    );
  }

  Future<void> changeLocale(String languageCode) async {
    await saveLocalLocally(languageCode);

    emit(
      ThemeState(
        themeData: getSavedTheme(),
        locale: getSavedLocale(),
      ),
    );
  }
}

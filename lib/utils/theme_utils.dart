import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kanban_board/constants/theme.dart';

import '../localization/localization.dart';

const String selectedThemeKey = "selectedTheme";
const String selectedLocaleKey = "selectedLocale";

Future<void> saveThemeLocally(String themeName) async {
  await GetStorage().write(selectedThemeKey, themeName);
}

ThemeData getSavedTheme() {
  try {
    String themeName = GetStorage().read(selectedThemeKey);

    String? key =
        availbleThemes.keys.firstWhere((element) => element == themeName);
    return availbleThemes[key]!;
  } catch (_) {
    return availbleThemes.values.first;
  }
}

Future<void> saveLocalLocally(String languageCode) async {
  await GetStorage().write(selectedLocaleKey, languageCode);
}

Locale getSavedLocale() {
  try {
    String savedLocaleLanguageCode = GetStorage().read(selectedLocaleKey);

    return supportedLocales.firstWhere(
        (element) => element.languageCode == savedLocaleLanguageCode);
  } catch (e) {
    return supportedLocales.first;
  }
}

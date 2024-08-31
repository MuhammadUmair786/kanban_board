import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kanban_board/constants/theme.dart';

import '../localization/localization.dart';

const String selectedThemeKey = "selectedTheme";
const String selectedLocaleKey = "selectedLocale";
const String lastUpdateBackUpKey = "lastUpdateBackUp";

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
    // log(e.toString());
    // log(x.toString());
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
  } catch (_) {
    return supportedLocales.first;
  }
}

DateTime? getLastUpdateBackUp() {
  try {
    return DateTime.parse(GetStorage().read(lastUpdateBackUpKey)).toLocal();
  } catch (_) {
    return null;
  }
}

Future<void> setLastUpdatebackUp(DateTime dateTime) async {
  await GetStorage().write(lastUpdateBackUpKey, dateTime.toIso8601String());
}

import 'package:flutter/material.dart';

import 'locale_list.dart';

List<Locale> supportedLocales = [
  const Locale('en', 'US'),
  const Locale('fr', 'FR')
];

Map<Locale, Map<String, String>> translationList = {
  // English
  supportedLocales[0]: {for (LocaleItem item in localeList) item.key: item.en},
  // French
  supportedLocales[1]: {for (LocaleItem item in localeList) item.key: item.fr},
};

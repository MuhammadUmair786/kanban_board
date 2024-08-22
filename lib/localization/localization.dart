import 'package:flutter/material.dart';

import 'locale_list.dart';

List<Locale> supportedLocales = [
  const Locale('en', 'US'),
  // France
  const Locale('fr', 'FR'),
  // Arabic
  const Locale('ar', 'AR'),
  // German
  const Locale('de', 'DE'),
];

Map<Locale, Map<String, String>> translationList = {
  // English
  supportedLocales[0]: {for (LocaleItem item in localeList) item.key: item.en},
  // French
  supportedLocales[1]: {for (LocaleItem item in localeList) item.key: item.fr},
  // Arabic
  supportedLocales[2]: {for (LocaleItem item in localeList) item.key: item.ar},
  // German
  supportedLocales[3]: {for (LocaleItem item in localeList) item.key: item.de},
};

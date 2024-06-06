import 'local_keys.dart';

/// key, en, fr
class LocaleItem {
  final String key;
  final String en;
  final String fr;

  LocaleItem({required this.key, required this.en, required this.fr});
}

List<LocaleItem> localeList = <LocaleItem>[
  LocaleItem(
    key: loginLK,
    en: 'Login',
    fr: 'Connexion',
  ),
];

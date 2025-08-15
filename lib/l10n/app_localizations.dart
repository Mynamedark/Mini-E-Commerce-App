import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class AppLocalizations {
  AppLocalizations(this.locale);
  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  late Map<String, String> _map;

  Future<bool> load() async {
    final data = await rootBundle.loadString('assets/i18n/${locale.languageCode}.arb');
    _map = Map<String, dynamic>.from(jsonDecode(data)).map((k, v) => MapEntry(k, v.toString()));
    return true;
  }

  String t(String key) => _map[key] ?? key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final l = AppLocalizations(locale);
    await l.load();
    return l;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

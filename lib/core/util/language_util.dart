import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

String getUserLanguage(BuildContext context) {
  final userLocale = Localizations.localeOf(context);
  const supportedLocales = AppLocalizations.supportedLocales;
  return supportedLocales.contains(userLocale) ? userLocale.languageCode : 'en';
}
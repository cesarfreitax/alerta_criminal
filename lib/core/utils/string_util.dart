import 'package:alerta_criminal/core/factories/string_service_factory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

AppLocalizations getStrings(BuildContext context) {
  return StringServiceFactory.create(context).get();
}
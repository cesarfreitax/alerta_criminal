import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StringService {
  final BuildContext context;

  StringService(this.context);

  AppLocalizations get() {
    return AppLocalizations.of(context)!;
  }
}
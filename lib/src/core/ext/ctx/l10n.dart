import 'package:fl_lib/l10n/gen/lib_l10n.dart';
import 'package:fl_lib/l10n/gen/lib_l10n_en.dart';
import 'package:fl_lib/src/res/l10n.dart';
import 'package:flutter/material.dart';

extension LibL10n on BuildContext {
  void setLibL10n() => l10n = LibLocalizations.of(this) ?? LibLocalizationsEn();
}

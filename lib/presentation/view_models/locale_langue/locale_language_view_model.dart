import 'package:alpha/core/base/base_view_model.dart';
import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/mixins/local_storage/local_storage_mixin.dart';
import 'package:alpha/data/services/local/hive_service.dart';
import 'package:alpha/injection/injector.dart';
import 'package:flutter/material.dart';

class LocaleNotifier extends BaseViewModel with LocalStorageMixin {
  LocaleNotifier() {
    initLocalStorage(getIt<HiveService>());
    initLocale();
  }

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> initLocale() async {
    final savedLocaleCode = await loadFromHive<String>(
      key: AppLocalKey.selectedLocale,
      boxName: AppLocalKey.commonBox,
    );

    if (savedLocaleCode != null) {
      _locale = Locale(savedLocaleCode);
    }
    notifyListeners();
  }

  void setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    await saveToHive<String>(
      key: AppLocalKey.selectedLocale,
      value: locale.languageCode,
      boxName: AppLocalKey.commonBox,
    );
    notifyListeners();
  }
}

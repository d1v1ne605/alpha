import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';

import '../constants/app_storage_key.dart';

class OrderHelper {
  static String getOrderExecuted(String? state, BuildContext context) {
    switch (state?.toLowerCase()) {
      case AppStorageKey.done:
        return context.appLocaleLanguage.executed;
      case AppStorageKey.cancel:
        return context.appLocaleLanguage.canceled.toCapitalized();
      default:
        return context.appLocaleLanguage.open;
    }
  }
}

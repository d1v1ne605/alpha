import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';

class PasswordUtils {
  static bool hasMinLength(String password) {
    return password.length >= 8;
  }

  static bool hasUpperAndLowerCase(String password) {
    return RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(password);
  }

  static bool hasNumber(String password) {
    return RegExp(r'(?=.*\d)').hasMatch(password);
  }
}

class EmailUtils {
  static bool isValidEmail(String email) {
    return RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(email);
  }
}

class HtmlCleaner {
  static String removeHrTags(String html) {
    return html.replaceAll(RegExp(r'<hr[^>]*>'), '');
  }
}

class FormatEmail {
  static String formatEmail(String email) {
    if (email.length <= 20) return email;

    final parts = email.split('@');
    if (parts.length != 2) return email;

    final username = parts[0];
    final domain = parts[1];

    if (username.length > 10) {
      final start = username.substring(0, 4);
      final end = username.substring(username.length - 3);
      return '$start...$end@$domain';
    }

    return email;
  }
}

class WithdrawValidate {
  static String? isValidAddress(String? address, BuildContext context) {
    if (address == null || address.isEmpty) {
      return context.appLocaleLanguage.addressRequired;
    }
    if (address.length <= 10) {
      return context.appLocaleLanguage.addressNotValid;
    }
    return null;
  }

  static String? isValidNameAddress(String? name, BuildContext context) {
    if (name == null || name.isEmpty) {
      return context.appLocaleLanguage.nameRequired;
    }
    if (name.length > 12) {
      return context.appLocaleLanguage.nameTooLong;
    }
    return null;
  }

  static bool _isValidErc20Address(String address) {
    final pattern = RegExp(r'^0x[0-9a-fA-F]{40}$');
    return pattern.hasMatch(address);
  }

  static bool _isValidBitcoinAddress(String address) {
    final pattern = RegExp(r'^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$');
    return pattern.hasMatch(address);
  }

  static bool _isValidTrxAddress(String address) {
    if (address.length > 34) {
      return false;
    }
    final pattern = RegExp(r'^T[A-Za-z1-9]{33}$');
    return pattern.hasMatch(address);
  }

  static bool validateBlockchainAddress(String address, String blockchainType) {
    if (address.isEmpty) return false;

    switch (blockchainType.toLowerCase()) {
      case AppStorageKey.ethBlockchainType:
      case AppStorageKey.bscBlockchainType:
        return _isValidErc20Address(address);
      case AppStorageKey.btcBlockchainType:
        return _isValidBitcoinAddress(address);
      case AppStorageKey.trxBlockchainType:
        return _isValidTrxAddress(address);
      default:
        return true; // Allow unknown blockchain types
    }
  }

  static String? isValidBlockchainAddress(
    String? address,
    String? blockchainType,
    BuildContext context,
  ) {
    if (address == null || address.isEmpty) {
      return context.appLocaleLanguage.addressRequired;
    }

    if (blockchainType == null || blockchainType.isEmpty) {
      return isValidAddress(address, context);
    }

    if (!validateBlockchainAddress(address, blockchainType)) {
      return context.appLocaleLanguage.addressNotValid;
    }

    return null;
  }
}

class ExtractUtilsNetwork {
  static String extractNetworkName(String name) {
    final regex = RegExp(r'\((.*?)\)');
    final match = regex.firstMatch(name);
    if (match != null) {
      return match.group(1)!;
    }
    return name;
  }
}

class InputNumber {
  static String formatNumber(String input) {
    final regex = RegExp(r'[^0-9]');
    return input.replaceAll(regex, '');
  }
}

class DateTimeUtils {
  static String formatToUTCZeroTime(DateTime date) {
    final utcDate = DateTime.utc(date.year, date.month, date.day, 0, 0, 0);
    return "${utcDate.toIso8601String().split('T')[0]} 00:00:00 UTC";
  }
}

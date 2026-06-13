import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FormatterUtils {
  static double toDoubleSafe(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int toIntSafe(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }

  static String isoToFormattedDateTime(String isoString) {
    final dateTime = DateTime.tryParse(isoString);
    if (dateTime == null) return '';
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
  }

  static String formatDateYMD(DateTime? date) {
    return DateFormat('yyyy-MM-dd').format(date ?? DateTime.now());
  }

  static String formatFullDateTimeFromTimestamp(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('dd-MM-yyyy HH:mm:ss').format(dateTime);
  }

  static String toFixed(double value, int precision) {
    return value.toStringAsFixed(precision);
  }

  static double toDoubleOrZero(String? value) {
    if (value == null) return 0.0;
    return double.tryParse(value) ?? 0.0;
  }

  static double toDoubleCleaned(String? value) {
    if (value == null) return 0.0;
    return double.tryParse(
          value.replaceAll('%', '').replaceAll('+', '').trim(),
        ) ??
        0.0;
  }

  static double parseChangePercent(String value) {
    return double.tryParse(
          value
              .replaceAll('%', '')
              .replaceAll('+', '')
              .replaceAll('−', '-')
              .replaceAll('–', '-')
              .trim(),
        ) ??
        0.0;
  }

  static String formatTokenValue({
    required double value,
    String? symbol,
    LocaleFormatEnum locale = LocaleFormatEnum.en,
    bool isRounded = false,
    bool truncateZeroDecimal = true,
  }) {
    if (isRounded) {
      value = value.roundToDouble();
    }

    if (value > 0 && value < 0.0001) {
      final str = value.toString();
      final regex = RegExp(r'^0\.0*(\d+)$');
      final match = regex.firstMatch(str);

      if (truncateZeroDecimal && match != null) {
        final zeroCount = str
            .split('.')[1]
            .split('')
            .takeWhile((c) => c == '0')
            .length;

        if (zeroCount >= 5) {
          final digits = match.group(1)!;
          return '0.{${zeroCount}}$digits ${symbol ?? ''}';
        } else {
          return '$value ${symbol ?? ''}';
        }
      }
    }
    final localeString = locale == LocaleFormatEnum.en ? 'en_US' : 'vi_VN';
    final formatter = NumberFormat.decimalPattern(localeString);
    final parts = value.toString().split('.');
    final intPart = int.tryParse(parts[0]) ?? 0;
    final decimalPart = parts.length > 1 && parts[1] != '0'
        ? ".${parts[1]}"
        : "";
    final formattedInt = formatter.format(intPart);
    return '$formattedInt$decimalPart${symbol != null ? ' $symbol' : ''}';
  }

  static double parsePrice(String price) {
    return double.tryParse(price.replaceAll(',', '').trim()) ?? 0.0;
  }

  static String formatWithDecimals(dynamic number, int decimalPlaces) {
    if (number == null) return '0';

    double numValue;
    if (number is String) {
      numValue = double.tryParse(number) ?? 0;
    } else if (number is num) {
      numValue = number.toDouble();
    } else {
      return '0';
    }
    return numValue.toStringAsFixed(decimalPlaces);
  }

  static String formatCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }

  static String formatPercentage(double value) {
    final percent = value * 100;
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }

  static String formatSignedPercentage(double value) {
    final sign = value >= 0 ? '+' : '';
    return '$sign${value.toStringAsFixed(2)}%';
  }

  static String formatVolume(double value) {
    if (value >= 1000000) {
      final inMillions = value / 1000000;
      return '${inMillions.toStringAsFixed(1)} M';
    } else {
      return value.toStringAsFixed(5);
    }
  }

  static String formatCompact(dynamic number, {int fractionDigits = 1}) {
    if (number == null) return '0';

    double numValue;
    if (number is String) {
      numValue = double.tryParse(number) ?? 0.0;
    } else if (number is num) {
      numValue = number.toDouble();
    } else {
      return '0.0';
    }

    final formatter = NumberFormat.compact();
    return formatter.format(numValue);
  }

  static String formatAssetChange({
    required double amountUSDT,
    required double percentageChange,
    String symbol = '\$',
  }) {
    final changeValue = amountUSDT * percentageChange;

    if (changeValue.toStringAsFixed(2) == '0.00') {
      return '${symbol}0.00 (+0%)';
    }

    final sign = percentageChange > 0 ? '+' : '';
    final formattedChange = formatCurrency(changeValue, symbol: symbol);
    final formattedPercentage = formatPercentage(percentageChange);

    return '$sign$formattedChange ($formattedPercentage)';
  }

  static String formatNumber({
    required double value,
    bool truncateToDecimalPlaces = true,
    String? symbol,
    LocaleFormatEnum locale = LocaleFormatEnum.en,
    bool isRounded = false,
    int? decimalDigits,
  }) {
    if (isRounded) {
      value = value.round().toDouble();
    }
    if (truncateToDecimalPlaces && decimalDigits != null) {
      value = value.truncateToDecimalPlaces(decimalDigits);
    }
    String localeString = getLocaleString(locale);
    int integerPartLength = value.truncate().toString().length;

    final formatter = NumberFormat.decimalPattern(localeString);

    if (decimalDigits != null) {
      formatter.minimumFractionDigits = decimalDigits;
      formatter.maximumFractionDigits = decimalDigits;
    }

    String formattedValue;
    if (integerPartLength > 6) {
      double inMillions = value / 1000000;
      formattedValue = '${formatter.format(inMillions)}M';
    } else {
      formattedValue = formatter.format(value);
    }
    if (symbol != null && symbol.isNotEmpty) {
      return '$formattedValue $symbol';
    }
    return formattedValue;
  }

  static String getLocaleString(LocaleFormatEnum locale) {
    switch (locale) {
      case LocaleFormatEnum.en:
        return 'en_US';
    }
  }

  static FilteringTextInputFormatter decimalInputFormatter(int decimalDigits) {
    return FilteringTextInputFormatter.allow(
      RegExp(AppStorageKey.decimalLimitRegex(decimalDigits.toString())),
    );
  }

  static int convertIsoToTimestamp(var timestamp) {
    if (timestamp is String) {
      final dateTime = DateTime.tryParse(timestamp);
      if (dateTime != null) {
        return dateTime.toUtc().millisecondsSinceEpoch ~/ 1000;
      }
    }
    return timestamp;
  }

  static bool isSameOrAfter(DateTime a, DateTime b) {
    return a.year > b.year ||
        (a.year == b.year && a.month > b.month) ||
        (a.year == b.year && a.month == b.month && a.day >= b.day);
  }

  static bool isSameOrBefore(DateTime a, DateTime b) {
    return a.year < b.year ||
        (a.year == b.year && a.month < b.month) ||
        (a.year == b.year && a.month == b.month && a.day <= b.day);
  }

  static String formatPrice(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toString();
  }

  static String formatCustomWithdraw(double value) {
    if (value >= 1000000) {
      final inMillions = value / 1000000;
      String str = inMillions.toString();
      str = str.replaceAll(RegExp(r'0+$'), '');
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
      }
      return '${str}M';
    } else {
      String str = value.toString();
      str = str.replaceAll(RegExp(r'0+$'), '');
      if (str.endsWith('.')) {
        str = '${str}0';
      }

      return str;
    }
  }

  static String formatCustomDeposit(double value) {
    if (value >= 1000000) {
      final inMillions = value / 1000000;
      String str = inMillions.toString();
      str = str.replaceAll(RegExp(r'0+$'), '');
      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
      }
      return '${str}M';
    } else {
      String str = value.toStringAsFixed(10);
      str = str.replaceAll(RegExp(r'0+$'), '');

      if (str.endsWith('.')) {
        str = str.substring(0, str.length - 1);
      }
      return str;
    }
  }

  static String formatAmount(String value, {int precision = 6}) {
    final parsed = double.tryParse(value) ?? 0.0;
    final pattern = '0.${'0' * precision}';
    final formatter = NumberFormat(pattern);
    return formatter.format(parsed);
  }

  static String formatNumberPrice(double number) {
    if (number == 0) return '0.00';
    if (number >= 1000000) {
      double mValue = number / 1000000;
      double truncated = mValue.truncateToDecimalPlaces(2);
      return (truncated == truncated.truncateToDecimalPlaces(0))
          ? '${truncated.toInt()}M'
          : '${_formatWithoutRound(truncated)}M';
    }
    if (number >= 1000) {
      double kValue = number / 1000;
      double truncated = kValue.truncateToDecimalPlaces(2);
      return (truncated == truncated.truncateToDecimalPlaces(0))
          ? '${truncated.toInt()}K'
          : '${_formatWithoutRound(truncated)}K';
    }
    double truncated = number.truncateToDecimalPlaces(2);
    String result = truncated.toString();
    if (!result.contains('.')) {
      result += '.00';
    } else {
      int digits = result.split('.')[1].length;
      if (digits == 1) result += '0';
    }
    return result;
  }

  static String _formatWithoutRound(double value) {
    String s = value.toString();
    if (!s.contains('.')) return s;
    List<String> parts = s.split('.');
    String decimal = parts[1];
    if (decimal.length > 2) decimal = decimal.substring(0, 2);
    while (decimal.length < 2) {
      decimal += '0';
    }
    return '${parts[0]}.$decimal';
  }

  static String formatWithDecimalsNoRound(double value, int decimalPlaces) {
    final intPart = value.truncate();
    final intPartFormatted = NumberFormat('#,##0', 'en_US').format(intPart);
    if (decimalPlaces == 0) return intPartFormatted;
    final decimalPartRaw = (value - intPart).toStringAsFixed(20).split('.')[1];
    var decimalPart = decimalPartRaw;
    if (decimalPart.length > decimalPlaces) {
      decimalPart = decimalPart.substring(0, decimalPlaces);
    } else {
      decimalPart = decimalPart.padRight(decimalPlaces, '0');
    }
    return '$intPartFormatted.$decimalPart';
  }
}

import 'package:flutter/services.dart';

class DecimalLimitFormatter extends TextInputFormatter {
  final int decimalRange;
  DecimalLimitFormatter(this.decimalRange);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 1 && parts[1].length > decimalRange) {
        return oldValue;
      }
    }
    return newValue;
  }
}

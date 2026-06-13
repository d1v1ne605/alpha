import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Future<void> showDatePickerDialog(
  DateTime? fromDate,
  DateTime? toDate,
  BuildContext context,
  bool isFrom,
  Function(bool, DateTime) onDateSelected,
) async {
  final now = DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: isFrom ? (fromDate ?? now) : (toDate ?? now),
    firstDate: DateTime(now.year - 5),
    lastDate: DateTime(now.year + 5),
  );
  if (picked != null) {
    onDateSelected.call(isFrom, picked);
  }
}

import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LabelsColumn extends StatelessWidget {
  final RecordType type;

  const LabelsColumn({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final labels = <String>[
      if (type == RecordType.withdraw) context.appLocaleLanguage.feeAmount,
      type == RecordType.withdraw
          ? context.appLocaleLanguage.withdrawAmount
          : context.appLocaleLanguage.amount,
      context.appLocaleLanguage.status,
      if (type == RecordType.withdraw) context.appLocaleLanguage.tID,
      context.appLocaleLanguage.txID,
      if (type == RecordType.withdraw) context.appLocaleLanguage.address,
      context.appLocaleLanguage.dateTime,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.space15.h,
      children: labels
          .map(
            (label) => Text(
              label,
              style: AppTextStyles.body.copyWith(color: AppColors.textTertiary),
            ),
          )
          .toList(),
    );
  }
}

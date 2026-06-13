import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDataCol extends StatelessWidget {
  final String type;
  final String value;

  const OrderDataCol({super.key, required this.type, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSpacing.space5.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: AppTextStyles.content2.copyWith(color: AppColors.textTertiary),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}

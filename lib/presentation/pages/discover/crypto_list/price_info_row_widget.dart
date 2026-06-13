import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceInfoRowWidget extends StatelessWidget {
  final String label;
  final dynamic value;
  final Color? labelColor;
  final Color? valueColor;
  final double? labelFontSize;
  final double? valueFontSize;
  final FontWeight? valueFontWeight;
  final VoidCallback? onTap;
  final double? verticalPadding;

  const PriceInfoRowWidget({
    Key? key,
    required this.label,
    required this.value,
    this.labelColor = Colors.grey,
    this.valueColor = Colors.white,
    this.labelFontSize = AppSize.size14,
    this.valueFontSize = AppSize.size14,
    this.valueFontWeight = FontWeight.w500,
    this.onTap,
    this.verticalPadding = AppSpacing.space10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: EdgeInsets.symmetric(vertical: verticalPadding!.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: labelColor, fontSize: labelFontSize!.sp),
          ),
          value is Widget
              ? value
              : Text(
                  value.toString(),
                  style: TextStyle(
                    color: valueColor,
                    fontSize: valueFontSize!.sp,
                    fontWeight: valueFontWeight,
                  ),
                ),
        ],
      ),
    );

    return onTap != null ? InkWell(onTap: onTap, child: content) : content;
  }
}

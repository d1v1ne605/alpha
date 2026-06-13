import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShowDataBox extends StatelessWidget {
  final Widget content;

  const ShowDataBox({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSize.fullSize.w,
      margin: EdgeInsets.symmetric(vertical: AppSpacing.space4.r),
      decoration: BoxDecoration(
        color: AppColors.transparent,
        borderRadius: BorderRadius.circular(AppSize.size4.r),
        border: Border.all(color: AppColors.borderCard, width: AppSize.size1.r),
      ),
      child: content,
    );
  }
}

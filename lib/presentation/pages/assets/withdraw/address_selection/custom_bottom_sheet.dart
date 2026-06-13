import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomSheet extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget> fields;
  final List<Widget> actions;

  const CustomBottomSheet({
    Key? key,
    required this.title,
    this.description,
    required this.fields,
    required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Container(
      height: height,
      padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.size8.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: AppSize.size10.h),
          Container(
            width: AppSize.size68.w,
            height: AppSize.size3.h,
            decoration: BoxDecoration(
              color: AppColors.stock,
              borderRadius: BorderRadius.circular(AppSize.size2.r),
            ),
          ),
          SizedBox(height: AppSize.size20.h),
          Text(
            title,
            style: AppTextStyles.content4.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (description != null) ...[
            SizedBox(height: AppSize.size4.h),
            Text(
              description!,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: AppSize.size30.h),
          ...fields.map(
            (e) => Padding(
              padding: EdgeInsets.symmetric(vertical: AppSize.size10.h),
              child: e,
            ),
          ),
          SizedBox(height: AppSize.size30.h),
          Row(
            children: actions
                .map(
                  (e) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSize.size4.w,
                      ),
                      child: e,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

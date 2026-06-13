import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItem extends StatelessWidget {
  final String item;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryItem({
    Key? key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space6.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space10.w,
            vertical: AppSpacing.space8.h,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.backgroundCategory
                : AppColors.transparent,
            borderRadius: BorderRadius.circular(AppSize.size4.r),
          ),
          child: Text(
            item,
            style: AppTextStyles.subtitle.copyWith(
              color: isSelected ? AppColors.white : AppColors.grey,
            ),
          ),
        ),
      ),
    );
  }
}

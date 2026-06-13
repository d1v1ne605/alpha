import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../data/models/referall_model/invite_tab_model.dart';

class InviteTabWidget extends StatelessWidget {
  final InviteTabModel tab;
  final bool isSelected;
  final VoidCallback onTap;

  const InviteTabWidget({
    super.key,
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: isSelected ? AppColors.primary : AppColors.tertiary,
        side: BorderSide(
          color: isSelected ? AppColors.primary : AppColors.stock,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSize.size8.r),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space10.w,
          vertical: AppSpacing.space10.h,
        ),
        backgroundColor: isSelected
            ? AppColors.backgroundCategory
            : AppColors.transparent,
      ),
      onPressed: onTap,
      child: Column(
        children: [
          SvgPicture.asset(
            tab.icon,
            width: AppSize.size18.w,
            height: AppSize.size18.h,
          ),
          SizedBox(height: AppSpacing.space4.h),
          Text(
            tab.label,
            style: AppTextStyles.content1.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

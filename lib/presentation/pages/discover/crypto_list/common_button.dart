import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final String? icon;
  final VoidCallback? onTap;

  const CommonButton({super.key, required this.title, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.space5.w,
          vertical: AppSpacing.space8.h,
        ),
        decoration: BoxDecoration(
          color: AppColors.textTertiary,
          borderRadius: BorderRadius.circular(AppSize.size4.r),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: AppSpacing.space6),
              SvgPicture.asset(
                icon!,
                width: AppSize.size12.w,
                height: AppSize.size12.w,
                color: AppColors.textFourth,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

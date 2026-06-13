import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_size.dart';
import '../../../core/constants/app_text_styles.dart';

class MenuItem extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback? onTap;

  const MenuItem({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: SvgPicture.asset(
              icon,
              width: AppSize.size24.w,
              height: AppSize.size24.h,
            ),
          ),
          SizedBox(width: AppSize.size3.w),
          Text(
            label,
            style: AppTextStyles.content2.copyWith(color: AppColors.tertiary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

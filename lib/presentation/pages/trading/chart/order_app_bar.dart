import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_svg.dart';
import '../../../../core/constants/app_text_styles.dart';

class OrderAppBar extends StatelessWidget {
  final String title;

  const OrderAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
      child: SizedBox(
        height: AppSize.size56.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  context.pop();
                },
                child: SvgPicture.asset(AppSvg.back),
              ),
            ),
            Center(
              child: Text(
                title,
                style: AppTextStyles.content5.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.tertiary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

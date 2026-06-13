import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_svg.dart';
import '../../../../core/constants/app_text_styles.dart';

class AnnouncementsAppBar extends StatelessWidget {
  const AnnouncementsAppBar({super.key});

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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(AppSvg.back),
                ),
              ),
            ),
            Center(
              child: Text(
                context.appLocaleLanguage.announcement,
                style: AppTextStyles.content5.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSize.size14.sp,
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

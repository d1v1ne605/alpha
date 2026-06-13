import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterHeading extends StatelessWidget {
  const RegisterHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: AppSpacing.space25.h),
        child: Column(
          children: [
            Text(
              context.appLocaleLanguage.authHeading,
              style: (AppTextStyles.title1.copyWith(
                fontSize: AppSize.size22.sp,
                color: AppColors.textPrimary,
              )),
            ),
            SizedBox(height: AppSpacing.space10.h),
            Text(
              context.appLocaleLanguage.registerSubheading,
              style: AppTextStyles.subBody.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

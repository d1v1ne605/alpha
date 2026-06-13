import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_string.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/pages/profile/my_api_key/widget/warning_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

class CreatedApiKeyBottomSheet extends StatelessWidget {
  final String accessKey;
  final String secretKey;

  const CreatedApiKeyBottomSheet({
    super.key,
    required this.accessKey,
    required this.secretKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.space8.r),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: AppSpacing.space10.h),
            HandleBar(),
            SizedBox(height: AppSpacing.space20.h),
            Text(
              context.appLocaleLanguage.created,
              style: AppTextStyles.content4.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: AppSpacing.space30.h),
            _buildKeyField(
              title: context.appLocaleLanguage.accessKey,
              value: accessKey,
            ),
            SizedBox(height: AppSpacing.space10.h),
            WarningWidget(text: context.appLocaleLanguage.infoNotice),
            SizedBox(height: AppSpacing.space15.h),

            _buildKeyField(
              title: context.appLocaleLanguage.secretKey,
              value: secretKey,
            ),
            SizedBox(height: AppSpacing.space10.h),
            WarningWidget(text: context.appLocaleLanguage.securityWarning),

            SizedBox(height: AppSpacing.space30.h),

            AppButton(
              text: context.appLocaleLanguage.confirm,
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyField({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.content3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: AppSpacing.space9.h),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space13.h,
            vertical: AppSpacing.space10.h,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.stock),
            borderRadius: BorderRadius.circular(AppSpacing.space4.r),
            color: AppColors.background,
          ),
          child: Row(
            children: [
              Text(
                value,
                style: AppTextStyles.content3.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Spacer(),
              GestureDetector(
                child: SvgPicture.asset(AppSvg.copy),
                onTap: () {
                  Clipboard.setData(ClipboardData(text: value));
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

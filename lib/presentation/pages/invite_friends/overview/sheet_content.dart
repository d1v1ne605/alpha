import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ShareSheet extends StatelessWidget {
  final String title;
  final String description;
  final String imageAsset;
  final VoidCallback? onShare;
  final bool showButton;
  final String? urlLink;

  const ShareSheet({
    super.key,
    required this.title,
    required this.description,
    required this.imageAsset,
    this.onShare,
    this.showButton = true,
    this.urlLink,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.space20.w,
        vertical: AppSpacing.space10.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: AppSize.size68.w,
            height: AppSize.size2.h,
            decoration: BoxDecoration(
              color: AppColors.textTertiary,
              borderRadius: BorderRadius.circular(AppSpacing.space2.r),
            ),
          ),
          SizedBox(height: AppSpacing.space18.h),
          Text(
            title,
            style: AppTextStyles.title2.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.space6.h),
          Text(
            description,
            style: AppTextStyles.content2.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: showButton ? AppSpacing.space60.h : AppSpacing.space75.h,
          ),
          urlLink != null
              ? QrImageView(
                  data: urlLink!,
                  size: AppSize.size197.w,
                  backgroundColor: AppColors.tertiary,
                )
              : Image.asset(
                  imageAsset,
                  width: AppSize.size350.w,
                  height: AppSize.size169.h,
                ),
          if (showButton) ...[
            SizedBox(height: AppSpacing.space30.h),
            AppButton(
              text: context.appLocaleLanguage.shareNow,
              fontWeight: FontWeight.w700,
              onPressed: onShare,
              size: AppButtonSizeEnum.medium,
            ),
          ],
        ],
      ),
    );
  }
}

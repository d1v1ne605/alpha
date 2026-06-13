import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_png.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/assets/deposit/share/deposit_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DepositQrSection extends StatelessWidget {
  final String data;
  final bool isisEnable2FA;

  DepositQrSection({Key? key, required this.data, required this.isisEnable2FA})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.space15.r),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.space8.r),
        border: Border.all(
          color: AppColors.borderCard,
          width: AppSpacing.space1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: data.isEmpty | !isisEnable2FA
                ? Image.asset(
                    AppPng.qrcode,
                    width: AppSize.size156.w,
                    height: AppSize.size156.h,
                  )
                : QrImageView(
                    data: data,
                    size: AppSize.size156.r,
                    backgroundColor: AppColors.white,
                  ),
          ),
          SizedBox(height: AppSpacing.space10.h),
          Text(
            context.appLocaleLanguage.depositDescription,
            textAlign: TextAlign.center,
            style: AppTextStyles.content2.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: AppSpacing.space15.h),
          DepositInfoBox(
            border: Border.all(
              color: AppColors.borderCard,
              width: AppSize.size1.w,
            ),
            backgroundColor: AppColors.backgroundAssetsCard,
            prefix: Text(
              data.isEmpty | !isisEnable2FA ? "" : data,
              style: AppTextStyles.content2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            postfix: SvgPicture.asset(
              AppSvg.copy,
              width: AppSize.size24.w,
              height: AppSize.size24.h,
              colorFilter: ColorFilter.mode(
                (data.isEmpty || !isisEnable2FA)
                    ? AppColors.disabledButton
                    : AppColors.primaryButton,
                BlendMode.srcIn,
              ),
            ),
            onPostfixTap: (data.isEmpty || !isisEnable2FA)
                ? null
                : () => Clipboard.setData(ClipboardData(text: data)),
          ),
        ],
      ),
    );
  }
}

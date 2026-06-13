import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CryptoDataRow extends StatelessWidget {
  final String name;
  final String volume;
  final String? price;
  final String usdPrice;
  final double change;
  final String? imagePath;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final int flexName;
  final int flexPrice;
  final int flexChange;

  final VoidCallback? onStarTap;

  final bool isFavorite;
  final bool isShowArrow;
  final bool isChangeVolumeCrypto;
  final bool isChangePriceCrypto;
  final bool isChangeImage;

  const CryptoDataRow({
    super.key,
    required this.name,
    required this.volume,
    this.price,
    required this.usdPrice,
    required this.change,
    this.imagePath,
    this.onTap,
    this.padding,
    this.flexName = 20,
    this.flexPrice = 15,
    this.flexChange = 15,
    this.onStarTap,
    this.isFavorite = false,
    this.isShowArrow = false,
    this.isChangeVolumeCrypto = false,
    this.isChangePriceCrypto = false,
    this.isChangeImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final changeColor = change >= 0 ? AppColors.changeButton : AppColors.red;
    final changeText = FormatterUtils.formatSignedPercentage(change);
    return InkWell(
      splashColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      hoverColor: AppColors.transparent,
      onTap: onTap,
      child: Padding(
        padding:
            padding ??
            EdgeInsets.symmetric(
              horizontal: isShowArrow
                  ? AppSpacing.space14.w
                  : AppSpacing.space20.w,
              vertical: AppSpacing.space10.h,
            ),
        child: Row(
          children: [
            Expanded(
              flex: flexName,
              child: Row(
                children: [
                  if (onStarTap != null) ...[
                    InkWell(
                      onTap: onStarTap,
                      child: SvgPicture.asset(
                        isFavorite ? AppSvg.star : AppSvg.star_outline,
                        width: AppSize.size24.w,
                        height: AppSize.size24.h,
                        color: isFavorite
                            ? AppColors.primary
                            : AppColors.iconUnselected,
                      ),
                    ),
                    SizedBox(width: AppSpacing.space10.w),
                  ],
                  isChangeImage ? _buildCryptoImage() : SizedBox.shrink(),
                  SizedBox(width: AppSpacing.space5.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildCryptoName(),
                      isChangeVolumeCrypto
                          ? SizedBox.shrink()
                          : Text(
                              FormatterUtils.formatCompact(
                                double.tryParse(volume) ?? 0.0,
                              ),
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              flex: flexPrice,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  isChangePriceCrypto
                      ? SizedBox.shrink()
                      : Text(
                          price ?? '0.0',
                          style: AppTextStyles.smallTextButton.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                  SizedBox(height: AppSpacing.space4.h),
                  Text(
                    '\$$usdPrice',
                    style: AppTextStyles.caption.copyWith(
                      color: isChangePriceCrypto
                          ? AppColors.textPrimary
                          : AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: flexChange,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: isShowArrow
                        ? EdgeInsets.zero
                        : EdgeInsets.only(left: AppSpacing.space10.w),
                    height: AppSize.size32,
                    width: AppSize.size75,
                    decoration: BoxDecoration(
                      color: changeColor,
                      borderRadius: BorderRadius.circular(AppSize.size4.r),
                    ),
                    child: Center(
                      child: Text(
                        changeText,
                        style: AppTextStyles.smallTextButton.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  if (isShowArrow) ...[
                    SizedBox(width: AppSpacing.space5.w),
                    SvgPicture.asset(
                      AppSvg.arrow,
                      width: AppSize.size12.w,
                      height: AppSize.size24.h,
                      color: AppColors.textPrimary,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCryptoImage() {
    return Container(
      width: AppSize.size32.w,
      height: AppSize.size32.h,
      decoration: BoxDecoration(shape: BoxShape.circle),
      child: ClipOval(
        child: imagePath != null
            ? Image.network(
                imagePath!,
                width: AppSize.size32.w,
                height: AppSize.size32.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.error,
                    color: AppColors.grey,
                    size: AppSize.size24.w,
                  );
                },
              )
            : Icon(Icons.error, color: AppColors.grey, size: AppSize.size24.w),
      ),
    );
  }

  Widget _buildCryptoName() {
    final parts = name.split('/');
    if (parts.length < 2) {
      return Text(
        name,
        style: AppTextStyles.smallTextButton.copyWith(color: AppColors.white),
      );
    }

    return Row(
      children: [
        Text(
          parts[0],
          style: AppTextStyles.smallTextButton.copyWith(color: AppColors.white),
        ),
        Text(
          '/${parts[1]}',
          style: AppTextStyles.smallTextButton.copyWith(
            color: AppColors.textFourth,
          ),
        ),
      ],
    );
  }
}

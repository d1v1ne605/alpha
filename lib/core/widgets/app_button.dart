import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback? onPressed;
  final AppButtonSizeEnum size;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final bool isEnabled;
  final FontWeight? fontWeight;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderSide? border;
  final Color? borderColor;
  final double? borderWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.size = AppButtonSizeEnum.small,
    this.backgroundColor,
    this.textColor,
    this.borderRadius,
    this.isEnabled = true,
    this.fontWeight,
    this.width,
    this.height,
    this.padding,
    this.icon,
    this.border,
    this.borderColor,
    this.borderWidth,
  });

  TextStyle getTextStyle() {
    switch (size) {
      case AppButtonSizeEnum.small:
        return AppTextStyles.smallTextButton.copyWith(
          color: textColor ?? Colors.white,
          fontWeight: fontWeight ?? AppTextStyles.smallTextButton.fontWeight,
        );
      case AppButtonSizeEnum.medium:
        return AppTextStyles.mediumTextButton.copyWith(
          color: textColor ?? Colors.white,
          fontWeight: fontWeight ?? AppTextStyles.mediumTextButton.fontWeight,
        );
      case AppButtonSizeEnum.large:
        return AppTextStyles.largeTextButton.copyWith(
          color: textColor ?? Colors.white,
          fontWeight: fontWeight ?? AppTextStyles.largeTextButton.fontWeight,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = AppButtonStyle.of(size);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? style.height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? (backgroundColor ??
                    style
                        .backgroundColor) // Use passed backgroundColor first, then default
              : AppColors.disabledButton,
          disabledBackgroundColor:
              AppColors.disabledButton, // Explicitly set disabled color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? style.borderRadius,
            ),
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: borderWidth ?? 1.0)
                : BorderSide.none,
          ),
          elevation: 0,
          padding: padding ?? style.padding,
          minimumSize: Size(width ?? double.infinity, height ?? style.height),
          side: border,
        ),
        onPressed: isEnabled ? onPressed : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: AppSize.size5.w)],
            Text(text, style: getTextStyle()),
          ],
        ),
      ),
    );
  }
}

class AppButtonStyle {
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  const AppButtonStyle({
    required this.height,
    required this.borderRadius,
    this.padding = EdgeInsets.zero,
    this.backgroundColor = AppColors.primaryButton,
  });

  static final AppButtonStyle small = AppButtonStyle(
    height: AppSize.size38.h,
    borderRadius: AppSize.size4,
  );

  static final AppButtonStyle medium = AppButtonStyle(
    height: AppSize.size48.h,
    borderRadius: AppSize.size4,
    padding: EdgeInsets.symmetric(
      vertical: AppSize.size10.h,
      horizontal: AppSize.size63.w,
    ),
  );

  static final AppButtonStyle large = AppButtonStyle(
    height: AppSize.size56.h,
    borderRadius: AppSize.size4,
    padding: EdgeInsets.symmetric(
      vertical: AppSize.size10.h,
      horizontal: AppSize.size63.w,
    ),
  );

  static AppButtonStyle of(AppButtonSizeEnum size) {
    switch (size) {
      case AppButtonSizeEnum.small:
        return small;
      case AppButtonSizeEnum.medium:
        return medium;
      case AppButtonSizeEnum.large:
        return large;
    }
  }
}

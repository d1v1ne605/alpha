import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback? onTap;
  final String textTitle;
  final Widget? actionWidget;
  final Widget? titleIcon;

  const AppHeader({
    super.key,
    this.onTap,
    required this.textTitle,
    this.actionWidget,
    this.titleIcon,
  });

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage(AppImage.logoAlpha), context);

    return SizedBox(
      height: AppSize.size56.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back_outlined, size: AppSize.size24.r),
              onPressed: onTap ?? () => context.pop(),
            ),
          ),
          Center(
            child: titleIcon == null
                ? Text(
                    textTitle,
                    style: AppTextStyles.content5.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      titleIcon!,
                      SizedBox(width: AppSize.size8.w),
                      Text(
                        textTitle,
                        style: AppTextStyles.content5.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
          ),
          if (actionWidget != null)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: AppSize.size20.w),
                child: actionWidget!,
              ),
            ),
        ],
      ),
    );
  }
}

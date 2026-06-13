import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_size.dart';
import '../../../../core/constants/app_text_styles.dart';

class BuildInfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailingText;
  final VoidCallback? onTrailingTap;
  final TextStyle? valueStyle;
  final TextAlign? valueAlign;
  final Widget? avatarWidget;
  final Widget? actionIcon;
  final VoidCallback? onIconTap;
  final bool multiLine;
  final String? valuePass;
  final VoidCallback? onTap;

  const BuildInfoRow({
    super.key,
    required this.label,
    required this.value,
    this.trailingText,
    this.onTrailingTap,
    this.valueStyle,
    this.valueAlign,
    this.avatarWidget,
    this.actionIcon,
    this.onIconTap,
    this.multiLine = false,
    this.valuePass,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
        horizontal: AppSize.size15.w,
        vertical: AppSize.size15.h,
      ),
      child: Row(
        crossAxisAlignment: multiLine
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: AppTextStyles.content3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
              fontSize: AppSize.size14.sp,
            ),
          ),
          SizedBox(width: AppSize.size8.w),
          if (valuePass != null && valuePass!.isNotEmpty)
            Text(
              valuePass!,
              style:
                  valueStyle ??
                  AppTextStyles.content3.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: valueAlign ?? TextAlign.left,
              maxLines: multiLine ? null : 1,
              overflow: TextOverflow.ellipsis,
            ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: multiLine
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            children: [
              if (value != null && value!.isNotEmpty)
                GestureDetector(
                  onTap: onTrailingTap,
                  child: Text(
                    value!,
                    style:
                        valueStyle ??
                        AppTextStyles.content3.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: valueAlign ?? TextAlign.right,
                    maxLines: multiLine ? null : 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

              if (avatarWidget != null) ...[
                SizedBox(width: AppSize.size8.w),
                avatarWidget ?? const SizedBox.shrink(),
              ],

              if (trailingText != null) ...[
                SizedBox(width: AppSize.size8.w),
                GestureDetector(onTap: onTrailingTap, child: trailingText!),
              ],

              if (actionIcon != null) ...[
                SizedBox(width: AppSize.size8.w),
                GestureDetector(
                  onTap: onIconTap,
                  child: actionIcon ?? const SizedBox.shrink(),
                ),
              ],
            ],
          ),
        ],
      ),
    ),
    );
  }
}

import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlockchainExploreRow extends StatelessWidget {
  final String label;
  final String url;

  const BlockchainExploreRow({Key? key, required this.label, required this.url})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.space4.h),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: AppTextStyles.content4.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Text(
                    url,
                    style: AppTextStyles.content4.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
                SizedBox(width: AppSize.size4.w),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: url));
                  },
                  child: SvgPicture.asset(
                    AppSvg.copy,
                    height: AppSize.size16.h,
                    width: AppSize.size16.w,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

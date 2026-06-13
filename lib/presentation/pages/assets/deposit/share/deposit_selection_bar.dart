import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/presentation/pages/assets/deposit/share/deposit_info_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DepositSelectionBar extends StatelessWidget {
  final String? title;
  final Widget prefixContent;
  final Widget? bottomWidget;
  final Function? toggleOpenList;

  const DepositSelectionBar({
    Key? key,
    this.title,
    required this.prefixContent,
    this.bottomWidget,
    this.toggleOpenList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: AppTextStyles.primaryLabel.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        SizedBox(height: AppSpacing.space10.h),
        GestureDetector(
          onTap: () {
            if (toggleOpenList != null) {
              toggleOpenList!();
            }
          },
          child: DepositInfoBox(
            prefix: prefixContent,
            postfix: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.iconPrimary,
              size: AppSize.size24.w,
            ),
            border: Border.all(
              color: AppColors.borderCard,
              width: AppSpacing.space1.w,
            ),
          ),
        ),
      ],
    );
  }
}

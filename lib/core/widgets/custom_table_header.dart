import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTableHeader extends StatelessWidget {
  final String? nameTitle;
  final String? priceTitle;
  final String? changeTitle;

  final VoidCallback? onNameTap;
  final VoidCallback? onPriceTap;
  final VoidCallback? onChangeTap;

  final Color backgroundColor;
  final Color textColor;
  final String sortIcon;
  final String? currentSortedColumn;
  final int flexName;
  final int flexPrice;
  final int flexChange;

  const CustomTableHeader({
    super.key,
    this.nameTitle,
    this.priceTitle,
    this.changeTitle,
    this.onNameTap,
    this.onPriceTap,
    this.onChangeTap,
    required this.sortIcon,
    required this.backgroundColor,
    required this.textColor,
    required this.currentSortedColumn,
    this.flexName = 2,
    this.flexPrice = 1,
    this.flexChange = 1,
  });

  Widget _buildHeaderItem(
    String key,
    String title,
    VoidCallback? onTap, {
    bool alignRight = false,
  }) {
    final bool isActive = currentSortedColumn == key;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisAlignment: alignRight
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.white : textColor,
            ),
          ),
          SizedBox(width: AppSize.size4.w),
          SvgPicture.asset(
            sortIcon,
            width: AppSize.size7.w,
            height: AppSize.size10.h,
            color: isActive ? AppColors.white : textColor,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: flexName,
            child: _buildHeaderItem(
              AppStorageKey.nameHeader,
              nameTitle ?? context.appLocaleLanguage.nameHeader,
              onNameTap,
            ),
          ),
          Expanded(
            flex: flexPrice,
            child: _buildHeaderItem(
              AppStorageKey.priceHeader,
              priceTitle ?? context.appLocaleLanguage.priceHeader,
              onPriceTap,
            ),
          ),
          Expanded(
            flex: flexChange,
            child: _buildHeaderItem(
              AppStorageKey.changeHeader,
              changeTitle ?? context.appLocaleLanguage.changeHeader,
              onChangeTap,
              alignRight: true,
            ),
          ),
        ],
      ),
    );
  }
}

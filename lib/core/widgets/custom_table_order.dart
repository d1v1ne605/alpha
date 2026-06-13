import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_storage_key.dart';

class CustomTableOrder extends StatelessWidget {
  final String orderNameHeader;
  final String? orderFilledHeader;
  final String orderPriceHeader;
  final String orderAmountHeader;
  final String orderActionHeader;

  final int flexNameHeader;
  final int flexFilledHeader;
  final int flexPriceHeader;
  final int flexAmountHeader;
  final int flexActionButton;
  final bool isRecentAmount;

  const CustomTableOrder({
    super.key,
    this.flexNameHeader = 15,
    this.flexFilledHeader = 13,
    this.flexPriceHeader = 22,
    this.flexAmountHeader = 12,
    this.flexActionButton = 10,
    this.orderNameHeader = AppStorageKey.nameHeader,
    this.orderFilledHeader,
    this.orderPriceHeader = AppStorageKey.priceHeader,
    this.orderAmountHeader = AppStorageKey.changeHeader,
    this.orderActionHeader = AppStorageKey.actionHeader,
    this.isRecentAmount = false,
  });

  Widget _buildHeaderItem(String title, Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Text(
        title,
        style: AppTextStyles.caption.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.subtitleText,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: AppSpacing.space10.h,
        left: AppSpacing.space20.w,
        right: AppSpacing.space20.w,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: flexNameHeader,
            child: _buildHeaderItem(orderNameHeader, Alignment.centerLeft),
          ),
          if (orderFilledHeader != null && orderFilledHeader!.isNotEmpty)
            Expanded(
              flex: flexFilledHeader,
              child: _buildHeaderItem(orderFilledHeader!, Alignment.centerLeft),
            ),
          Expanded(
            flex: flexPriceHeader,
            child: _buildHeaderItem(orderPriceHeader, Alignment.centerLeft),
          ),
          Expanded(
            flex: flexAmountHeader,
            child: _buildHeaderItem(
              orderAmountHeader,
              isRecentAmount ? Alignment.centerRight : Alignment.centerLeft,
            ),
          ),
          Visibility(
            visible: flexActionButton > 0,
            child: Expanded(
              flex: flexActionButton,
              child: _buildHeaderItem(orderActionHeader, Alignment.centerRight),
            ),
          ),
        ],
      ),
    );
  }
}

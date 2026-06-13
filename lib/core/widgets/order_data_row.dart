import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/slantedClipper.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class OrderDataRow extends StatelessWidget {
  final String? baseSymbol;
  final Widget? customNameWidget;
  final Color color;
  final String? quoteSymbol;
  final String orderPrice;
  final String amount;
  final EdgeInsets? padding;
  final int flexName;
  final int flexPrice;
  final int flexAmount;
  final int flexActionButton;
  final int flexFilledCell;
  final String sideValue;
  final double percent;
  final String dataId;
  final bool isRecentAmount;

  const OrderDataRow({
    super.key,
    this.baseSymbol,
    this.quoteSymbol,
    required this.orderPrice,
    required this.amount,
    this.percent = 0.0,
    this.padding,
    this.flexName = 15,
    this.flexPrice = 22,
    this.flexAmount = 12,
    this.flexActionButton = 10,
    this.flexFilledCell = 13,
    this.sideValue = AppStorageKey.buy,
    this.customNameWidget,
    this.color = AppColors.green,
    required this.dataId,
    this.isRecentAmount = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: flexName,
          child: customNameWidget ?? _buildCurrencyName(),
        ),
        Visibility(
          visible: flexFilledCell > 0,
          child: Expanded(
            flex: flexFilledCell,
            child: _buildFilledCell(percent),
          ),
        ),
        Expanded(
          flex: flexPrice,
          child: Align(
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                orderPrice,
                style: AppTextStyles.smallTextButton.copyWith(
                  color: sideValue.toLowerCase() == AppStorageKey.taker_type
                      ? AppColors.green
                      : AppColors.red,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: flexAmount,
          child: Align(
            alignment: isRecentAmount
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                amount,
                style: AppTextStyles.smallTextButton.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
        Visibility(
          visible: flexActionButton > 0,
          child: Expanded(
            flex: flexActionButton,
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () async {
                  try {
                    await context.read<TradeViewModel>().cancelOrderWithID(
                      id: dataId,
                      cancelLoading: true,
                    );
                    if (!context.mounted) return;
                    context.showSuccessSnackBar('Delete successful');
                  } catch (e) {
                    context.showErrorSnackBar('Delete failed');
                  }
                },
                child: SvgPicture.asset(
                  AppSvg.tabOrderTrash,
                  width: AppSize.size20.w,
                  height: AppSize.size20.h,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCurrencyName() {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: baseSymbol,
            style: AppTextStyles.smallTextButton.copyWith(
              color: AppColors.white,
            ),
          ),
          TextSpan(
            text: '/$quoteSymbol',
            style: AppTextStyles.smallTextButton.copyWith(
              color: AppColors.textFourth,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilledCell(double percent) {
    final clamped = percent.clamp(0.0, 1.0);
    final percentText = "${(clamped * 100).toStringAsFixed(2)}%";

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: AppSize.size40.w,
        height: AppSize.size10.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary,
            width: AppSize.size0_5.w,
          ),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSize.size1.r),
            bottomRight: Radius.circular(AppSize.size1.r),
          ),
          color: AppColors.stock,
        ),
        child: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: clamped,
              alignment: Alignment.centerLeft,
              child: ClipPath(
                clipper: SlantedClipper(),
                child: Container(color: AppColors.primary),
              ),
            ),
            Center(
              child: Text(
                percentText,
                style: AppTextStyles.smallText.copyWith(
                  color: AppColors.lightPeach,
                  fontSize: AppSize.size6.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

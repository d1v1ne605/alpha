import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class OrderBookFilterBar extends StatelessWidget {
  const OrderBookFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TradeViewModel>();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          buildIconButton(AppSvg.buyAndSellOrderBook, () {
            vm.filterOrderBook();
          }),
          buildIconButton(AppSvg.sellOrderBook, () {
            vm.filterOrderBook(OrderTypeEnum.sell);
          }),
          buildIconButton(AppSvg.buyOrderBook, () {
            vm.filterOrderBook(OrderTypeEnum.buy);
          }),
        ],
      ),
    );
  }

  Widget buildIconButton(String asset, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.space4.r),
        splashColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.15),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(AppSpacing.space2.w.h),
          child: SvgPicture.asset(
            asset,
            width: AppSpacing.space25.w,
            height: AppSpacing.space25.h,
          ),
        ),
      ),
    );
  }
}

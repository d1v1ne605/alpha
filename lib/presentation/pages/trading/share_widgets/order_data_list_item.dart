import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/order_data_row.dart';
import 'package:alpha/data/models/trading/trade/order_item_model.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDataListItem extends StatelessWidget {
  final OrderItemModel data;
  final String baseUnit;
  final String quoteUnit;
  final bool enableDeleteAction;
  final TradeViewModel vm;
  final int currentPage;
  final BuildContext parentContext;

  const OrderDataListItem({
    super.key,
    required this.data,
    required this.baseUnit,
    required this.quoteUnit,
    required this.enableDeleteAction,
    required this.vm,
    required this.currentPage,
    required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    final executed = double.tryParse(data.executedVolume) ?? 0;
    final origin = double.tryParse(data.originVolume) ?? 1;
    final percent = executed / origin;
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space11.h),
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSpacing.space3.h,
          bottom: AppSpacing.space3.h,
        ),
        child: OrderDataRow(
          baseSymbol: baseUnit,
          quoteSymbol: quoteUnit,
          sideValue: data.side,
          orderPrice: FormatterUtils.formatNumber(
            value: double.parse(data.price ?? '0.0'),
          ).toString(),
          amount: data.originVolume,
          percent: percent,
          dataId: data.id.toString(),
        ),
      ),
    );
  }
}

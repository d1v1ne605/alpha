import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/order_book_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_storage_key.dart';

class OrderBookDepth extends StatelessWidget {
  final OrderTypeEnum orderBookType;
  final List<List<String>> orders;
  final String titleLeft;
  final String titleRight;
  final bool reverseDepthInfoRow;
  final bool reverseDepthBar;
  final bool enableDepthItemTap;
  final bool alignToBottom;

  const OrderBookDepth({
    super.key,
    required this.orderBookType,
    required this.orders,
    this.titleLeft = AppStorageKey.price,
    this.titleRight = AppStorageKey.amount,
    this.reverseDepthInfoRow = false,
    this.reverseDepthBar = false,
    this.enableDepthItemTap = false,
    this.alignToBottom = false,
  });

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return const SizedBox.shrink();
    }

    final double maxAmount = _calculateMaxAmount();

    return SizedBox(
      height: (orders.length * 20.0).h,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orders.length,
        reverse: alignToBottom,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return OrderBookItem(
            key: ValueKey('${orders[index][0]}_${orders[index][1]}'),
            order: orders[index],
            maxAmount: maxAmount,
            orderBookType: orderBookType,
            reverseDepthBar: reverseDepthBar,
            reverseDepthInfoRow: reverseDepthInfoRow,
            enableDepthItemTap: enableDepthItemTap,
          );
        },
      ),
    );
  }

  double _calculateMaxAmount() {
    if (orders.isEmpty) return 0.0;

    double maxAmount = 0.0;
    for (final order in orders) {
      final double amount = double.tryParse(order[1]) ?? 0.0;
      if (amount > maxAmount) {
        maxAmount = amount;
      }
    }
    return maxAmount;
  }
}

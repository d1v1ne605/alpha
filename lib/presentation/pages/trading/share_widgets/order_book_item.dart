import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderBookItem extends StatefulWidget {
  final List<String> order;
  final double maxAmount;
  final OrderTypeEnum orderBookType;
  final bool reverseDepthBar;
  final bool reverseDepthInfoRow;
  final bool enableDepthItemTap;

  const OrderBookItem({
    super.key,
    required this.order,
    required this.maxAmount,
    required this.orderBookType,
    required this.reverseDepthBar,
    required this.reverseDepthInfoRow,
    required this.enableDepthItemTap,
  });

  @override
  State<OrderBookItem> createState() => OrderBookItemState();
}

class OrderBookItemState extends State<OrderBookItem>
    with AutomaticKeepAliveClientMixin {
  late final double _amount;
  late final double _price;
  late final double _percentage;
  late final bool _isRowEmpty;
  late final String _leftText;
  late final String _rightText;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _amount = double.tryParse(widget.order[1]) ?? 0.0;
    _price = double.tryParse(widget.order[0]) ?? 0.0;
    _percentage = widget.maxAmount > 0
        ? (_amount / widget.maxAmount).clamp(0.0, 1.0)
        : 0.0;
    _isRowEmpty = widget.order.any((e) => e == "");

    _leftText = _getOrderBookCellValue(isLeft: true);
    _rightText = _getOrderBookCellValue(isLeft: false);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (_isRowEmpty) {
      return SizedBox(height: AppSize.size20.h);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.space0.r),
        splashColor: Colors.white.withOpacity(0.3),
        highlightColor: Colors.white.withOpacity(0.15),
        onTap: widget.enableDepthItemTap ? () => _handleTap() : null,
        child: Container(
          height: 20.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: widget.reverseDepthBar
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              end: widget.reverseDepthBar
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              stops: [0.0, _percentage, _percentage, 1.0],
              colors: [
                widget.orderBookType == OrderTypeEnum.sell
                    ? AppColors.depthBackgroundOnSellOrderBook
                    : AppColors.depthBackgroundOnBuyOrderBook,
                widget.orderBookType == OrderTypeEnum.sell
                    ? AppColors.depthBackgroundOnSellOrderBook
                    : AppColors.depthBackgroundOnBuyOrderBook,
                Colors.transparent,
                Colors.transparent,
              ],
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.space2.w,
            vertical: AppSpacing.space2.h,
          ),
          child: Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _leftText,
                    maxLines: 1,
                    style: widget.reverseDepthInfoRow
                        ? _rightTextStyle
                        : _leftTextStyle,
                  ),
                ),
              ),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    _rightText,
                    maxLines: 1,
                    textAlign: TextAlign.right,
                    style: widget.reverseDepthInfoRow
                        ? _leftTextStyle
                        : _rightTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late final TextStyle _leftTextStyle = AppTextStyles.body.copyWith(
    fontSize: AppSize.size13.sp,
    color: widget.orderBookType == OrderTypeEnum.sell
        ? AppColors.textOnSellOrderBook
        : AppColors.textOnBuyOrderBook,
    fontFamily: 'Poppins',
  );

  late final TextStyle _rightTextStyle = AppTextStyles.body.copyWith(
    fontSize: AppSize.size12.sp,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  void _handleTap() {
    final vm = context.read<TradeViewModel>();
    vm.onOrderBookItemTapped(_price, widget.orderBookType);
  }

  String _getOrderBookCellValue({required bool isLeft}) {
    final vm = context.read<TradeViewModel>();
    if (widget.reverseDepthInfoRow) {
      return isLeft
          ? _formatQuantity(_amount, vm.quantityPrecision)
          : _formatPrice(_price, vm.pricePrecision);
    } else {
      return isLeft
          ? _formatPrice(_price, vm.pricePrecision)
          : _formatQuantity(_amount, vm.quantityPrecision);
    }
  }

  String _formatPrice(double price, int pricePrecision) {
    return price != 0.0 ? FormatterUtils.formatTokenValue(value: price) : '';
  }

  String _formatQuantity(double amount, int quantityPrecision) {
    if (amount == 0.0) return '';

    final truncated = amount.truncateToDecimalPlaces(quantityPrecision);
    return FormatterUtils.formatTokenValue(value: truncated);
  }
}

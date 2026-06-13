import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/trading/trade/ticker_data.dart';
import 'package:alpha/domain/usecase/trading/get_order_book_usecase.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/header_order_book_depth.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/order_book_depth.dart';
import 'package:alpha/presentation/pages/trading/trade/last_trade_info.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderBook extends StatefulWidget {
  const OrderBook({super.key, required this.coin});

  final CoinModel coin;

  @override
  State<OrderBook> createState() => _OrderBookState();
}

class _OrderBookState extends State<OrderBook> {
  TradeViewModel? _tradeViewModel;

  TradeViewModel get vm {
    return _tradeViewModel ??= Provider.of<TradeViewModel>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: AppSpacing.space20.w),
      child: Column(
        children: [
          const HeaderOrderBookDepth(),
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Selector<TradeViewModel, OrderTypeEnum?>(
                  selector: (_, viewModel) => viewModel.orderBookType,
                  builder: (context, orderBookType, _) {
                    return SizedBox(
                      height: orderBookType == OrderTypeEnum.buy
                          ? AppSpacing.space5.h
                          : AppSpacing.space11.h,
                    );
                  },
                ),
                Selector<
                  TradeViewModel,
                  ({OrderTypeEnum? orderBookType, String selectedOrderType})
                >(
                  selector: (_, viewModel) => (
                    orderBookType: viewModel.orderBookType,
                    selectedOrderType: viewModel.selectedOrderType,
                  ),
                  builder: (context, data, _) {
                    final showBoth = data.orderBookType == null;
                    return Visibility(
                      visible:
                          (data.orderBookType == OrderTypeEnum.sell ||
                          showBoth),
                      maintainState: true,
                      child: RepaintBoundary(
                        child: StreamBuilder(
                          stream: vm.orderBookStream,
                          initialData: vm.depthOrderBook,
                          builder: (context, asyncSnapshot) {
                            return createOrderBookDepth(
                              orderBookType: OrderTypeEnum.sell,
                              orders: asyncSnapshot.data!.asks,
                              showBoth: showBoth,
                              alignToBottom: true,
                              selectedOrderType: data.selectedOrderType,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: AppSpacing.space6.h),
                StreamBuilder<TickerData>(
                  stream: vm.tickerDataStream,
                  builder: (context, snapshot) {
                    final lastTradeInfo = getLatestTradeInfo(
                      snapshot.data,
                      widget.coin,
                    );

                    return LastTradeInfo(
                      pricePrecision: widget.coin.price_precision,
                      price: lastTradeInfo.lastPrice,
                      color:
                          FormatterUtils.parseChangePercent(
                                lastTradeInfo.priceChangePercent.toString(),
                              ) <
                              0
                          ? AppColors.red
                          : AppColors.textOnLastTradeInfo,
                      approximatelyPrice: lastTradeInfo.usdPrice.toString(),
                    );
                  },
                ),

                Selector<TradeViewModel, OrderTypeEnum?>(
                  selector: (_, viewModel) => viewModel.orderBookType,
                  builder: (context, orderBookType, _) {
                    return SizedBox(
                      height: orderBookType == OrderTypeEnum.buy
                          ? AppSpacing.space12.h
                          : AppSpacing.space6.h,
                    );
                  },
                ),

                Selector<
                  TradeViewModel,
                  ({OrderTypeEnum? orderBookType, String selectedOrderType})
                >(
                  selector: (_, viewModel) => (
                    orderBookType: viewModel.orderBookType,
                    selectedOrderType: viewModel.selectedOrderType,
                  ),
                  builder: (context, data, _) {
                    final showBoth = data.orderBookType == null;
                    return Visibility(
                      visible:
                          (data.orderBookType == OrderTypeEnum.buy || showBoth),
                      maintainState: true,
                      child: RepaintBoundary(
                        child: StreamBuilder(
                          stream: vm.orderBookStream,
                          initialData: vm.depthOrderBook,
                          builder: (context, asyncSnapshot) {
                            return createOrderBookDepth(
                              orderBookType: OrderTypeEnum.buy,
                              orders: asyncSnapshot.data!.bids,
                              showBoth: showBoth,
                              selectedOrderType: data.selectedOrderType,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ({String lastPrice, String priceChangePercent, double usdPrice})
  getLatestTradeInfo(TickerData? tickerData, CoinModel coin) {
    final lastPrice = tickerData?.last ?? coin.lastPrice;
    final priceChangePercent =
        tickerData?.priceChangePercent ?? coin.priceChangePercent;
    final usdPrice = tickerData != null
        ? (double.tryParse(tickerData.last.toString()) ?? 0.0) *
              (double.tryParse(coin.quote_price) ?? 1.0)
        : double.tryParse(coin.usdPrice) ?? 0.0;

    return (
      lastPrice: lastPrice,
      priceChangePercent: priceChangePercent,
      usdPrice: usdPrice,
    );
  }

  Widget createOrderBookDepth({
    required OrderTypeEnum orderBookType,
    required List<List<String>> orders,
    required bool showBoth,
    bool alignToBottom = false,
    required String selectedOrderType,
  }) {
    final limit = selectedOrderType == context.appLocaleLanguage.limit
        ? (showBoth
              ? AppStorageKey.numberOfItemsOrderBookInShowBoth
              : AppStorageKey.numberOfItemsOrderBookInShowBoth * 2)
        : (showBoth
              ? AppStorageKey.numberOfItemsOrderBookInShowBothInMarket
              : AppStorageKey.numberOfItemsOrderBookInShowBothInMarket * 2);

    OrderBookList displayOrders = orders.take(limit).toList();

    return OrderBookDepth(
      orderBookType: orderBookType,
      orders: displayOrders,
      enableDepthItemTap: selectedOrderType == context.appLocaleLanguage.limit
          ? true
          : false,
      alignToBottom: alignToBottom,
    );
  }
}

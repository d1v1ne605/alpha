import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/tab_order.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/trading_pair_selector.dart';
import 'package:alpha/presentation/pages/trading/trade/button_submit_order_form.dart';
import 'package:alpha/presentation/pages/trading/trade/order_book.dart';
import 'package:alpha/presentation/pages/trading/trade/order_book_filter_bar.dart';
import 'package:alpha/presentation/pages/trading/trade/order_form.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TradeScreen extends StatefulWidget {
  final CoinModel? coin;

  const TradeScreen({super.key, this.coin});

  @override
  State<TradeScreen> createState() => _TradeScreenState();
}

class _TradeScreenState extends State<TradeScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  TradeViewModel? _tradeViewModel;

  TradeViewModel get vm {
    return _tradeViewModel ??= Provider.of<TradeViewModel>(
      context,
      listen: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: AppSpacing.space20.w,
                    right: AppSpacing.space20.w,
                    top: AppSpacing.space15.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Selector<TradeViewModel, CoinModel>(
                        selector: (context, vm) => vm.currentCoin!,
                        builder: (context, coin, child) => TradingPairSelector(
                          onTap: () {
                            context.push(RouterPath.search);
                          },
                          tradingPair: coin.name,
                          priceChangePercent: FormatterUtils.toDoubleCleaned(
                            coin.priceChangePercent,
                          ),
                          onTapSuffixIcon: () async {
                            await vm.toggleFavorite(coin.id);
                          },
                          isFavorite: coin.ishar,
                        ),
                      ),
                      SizedBox(height: AppSpacing.space15.h),
                    ],
                  ),
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    Expanded(
                      child: Selector<TradeViewModel, CoinModel>(
                        selector: (context, vm) => vm.currentCoin!,
                        builder: (context, coin, child) => Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(flex: 13, child: OrderForm(coin: coin)),
                            SizedBox(width: AppSpacing.space15.w),
                            Expanded(flex: 10, child: OrderBook(coin: coin)),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space20.w,
                        vertical: AppSpacing.space10.h,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 13,
                            child: ValueListenableBuilder(
                              valueListenable: vm.orderFormType,
                              builder: (context, value, child) {
                                final currentCoin = vm.currentCoin;
                                return ButtonSubmitOrderForm(
                                  market: currentCoin?.id.toLowerCase() ?? '',
                                );
                              },
                            ),
                          ),

                          SizedBox(width: AppSpacing.space10.w),
                          Expanded(flex: 10, child: OrderBookFilterBar()),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: height * 0.45,
                      child: Selector<TradeViewModel, CoinModel>(
                        selector: (context, vm) => vm.currentCoin!,
                        builder: (context, coin, child) => TabOrder(coin: coin),
                      ),
                    ),
                    SizedBox(height: AppSpacing.space10.h),
                  ],
                ),
              ),
            ],
          ),
          if (context.select((TradeViewModel vm) => vm.isBusy) &&
              context.select((TradeViewModel vm) => vm.currentCoin) != null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.4),
                child: const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

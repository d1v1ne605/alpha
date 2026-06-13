import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_interface.dart';
import 'package:alpha/data/models/trading/trade/ticker_data.dart';
import 'package:alpha/presentation/pages/trading/chart/order_book_chart.dart';
import 'package:alpha/presentation/pages/trading/chart/overview_chart.dart';
import 'package:alpha/presentation/pages/trading/chart/price_info_row_widget.dart';
import 'package:alpha/presentation/pages/trading/chart/recent_transaction_chart.dart';
import 'package:alpha/presentation/pages/trading/share_widgets/trading_pair_selector.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChartScreen extends StatefulWidget {
  final TabController tabController;

  const ChartScreen({Key? key, required this.tabController}) : super(key: key);

  @override
  State<ChartScreen> createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;

  TradeViewModel? _tradeViewModel;
  late List<Tab> tabs;

  TradeViewModel get vm {
    return _tradeViewModel ??= Provider.of<TradeViewModel>(
      context,
      listen: false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs = [
      Tab(text: context.appLocaleLanguage.orderBook),
      Tab(text: context.appLocaleLanguage.recentTransactions),
      Tab(text: context.appLocaleLanguage.overview),
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  final width = double.infinity;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final mediaQueryHeight = MediaQuery.of(context).size.height * 0.43;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: AppSpacing.space20.w,
                      right: AppSpacing.space20.w,
                      top: AppSpacing.space15.h,
                    ),
                    child: Selector<TradeViewModel, CoinModel?>(
                      selector: (context, viewModel) => viewModel.currentCoin,
                      builder: (context, coin, child) {
                        return Column(
                          children: [
                            TradingPairSelector(
                              onTap: () {
                                context.push(RouterPath.search);
                              },
                              onTapSuffixIcon: () async {
                                await vm.toggleFavorite(coin?.id ?? '');
                              },
                              isFavorite: coin?.ishar ?? false,
                              tradingPair: coin?.name ?? '',
                              priceChangePercent:
                                  FormatterUtils.toDoubleCleaned(
                                    coin?.priceChangePercent.toString() ?? '0',
                                  ),
                            ),
                            SizedBox(height: AppSpacing.space15.h),
                            StreamBuilder<TickerData>(
                              stream: vm.tickerDataStream,
                              builder: (context, snapshot) {
                                final tickerData = snapshot.data;
                                final priceChangePercent =
                                    tickerData?.priceChangePercent ??
                                    coin?.priceChangePercent ??
                                    0.0;
                                final lastPrice =
                                    tickerData?.last ?? coin?.lastPrice ?? 0.0;
                                final high =
                                    tickerData?.high ?? coin?.high ?? 0.0;
                                final low = tickerData?.low ?? coin?.low ?? 0.0;
                                final volume =
                                    tickerData?.volume ?? coin?.volume ?? 0.0;
                                final amount =
                                    tickerData?.amount ?? coin?.amount ?? 0.0;
                                final usdPrice = tickerData != null
                                    ? (double.tryParse(
                                                tickerData.last.toString(),
                                              ) ??
                                              0.0) *
                                          (double.tryParse(
                                                coin?.quote_price ?? '0.0',
                                              ) ??
                                              1.0)
                                    : double.tryParse(
                                            coin?.usdPrice ?? '0.0',
                                          ) ??
                                          0.0;
                                return Column(
                                  children: [
                                    PriceInfoRowWidget(
                                      mainPriceValue:
                                          FormatterUtils.formatTokenValue(
                                            value: double.parse(
                                              lastPrice.toString(),
                                            ),
                                          ),
                                      color:
                                          FormatterUtils.parseChangePercent(
                                                priceChangePercent.toString(),
                                              ) <
                                              0
                                          ? AppColors.red
                                          : AppColors.textOnLastTradeInfo,
                                      labelLeftTop:
                                          context.appLocaleLanguage.high24h,
                                      labelLeftBottom:
                                          context.appLocaleLanguage.volume24h,
                                      valueRightTop:
                                          FormatterUtils.formatTokenValue(
                                            value: double.parse(
                                              high.toString(),
                                            ),
                                          ),
                                      valueRightBottom:
                                          FormatterUtils.formatCompact(
                                            volume.toString(),
                                          ),
                                      isUsdPrice: false,
                                    ),
                                    PriceInfoRowWidget(
                                      mainPriceValue:
                                          FormatterUtils.formatTokenValue(
                                            value: double.parse(
                                              usdPrice
                                                  .truncateToDecimalPlaces(
                                                    coin?.price_precision ?? 0,
                                                  )
                                                  .toString(),
                                            ),
                                          ),
                                      color: AppColors.white,
                                      labelLeftTop:
                                          context.appLocaleLanguage.low24h,
                                      size: AppSize.size14,
                                      labelLeftBottom:
                                          context.appLocaleLanguage.amount24h,
                                      valueRightTop:
                                          FormatterUtils.formatTokenValue(
                                            value: double.parse(low.toString()),
                                          ),
                                      valueRightBottom:
                                          FormatterUtils.formatCompact(
                                            amount.toString(),
                                            fractionDigits:
                                                coin?.amount_precision ?? 0,
                                          ),
                                      isUsdPrice: true,
                                    ),

                                    SizedBox(height: AppSpacing.space10.h),
                                  ],
                                );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: AppSpacing.space10.h),
                  SizedBox(
                    height: AppSize.size320.h,
                    width: double.infinity,
                    child: Selector<TradeViewModel, WebViewController>(
                      selector: (context, viewModel) =>
                          viewModel.webViewController,
                      builder: (context, webViewController, child) {
                        return WebViewWidget(controller: webViewController);
                      },
                    ),
                  ),
                  Container(
                    color: AppColors.background,
                    child: CustomTabBar(tabs: tabs, controller: _tabController),
                  ),
                  SizedBox(
                    height: mediaQueryHeight,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Selector<TradeViewModel, CoinModel?>(
                          selector: (context, viewModel) =>
                              viewModel.currentCoin,
                          builder: (context, coin, child) {
                            return coin != null
                                ? OrderBookChart(
                                    market: coin.id,
                                    tabController: widget.tabController,
                                  )
                                : const SizedBox.shrink();
                          },
                        ),
                        ValueListenableBuilder<List<ITransaction>>(
                          valueListenable: vm.transactionNotifier,
                          builder: (context, transactionList, child) {
                            return RecentTransactionChart(
                              height: 0.35,
                              tabController: widget.tabController,
                              transactions: transactionList.isEmpty
                                  ? vm.lastTransaction
                                  : transactionList,
                            );
                          },
                        ),
                        OverviewChart(tabController: widget.tabController),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.space20.w),
            child: Row(
              children: [
                Selector<TradeViewModel, CoinModel?>(
                  selector: (context, vm) => vm.currentCoin,
                  builder: (context, coin, child) => GestureDetector(
                    onTap: () {
                      context.push(RouterPath.orderPortal, extra: coin);
                    },
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AppSvg.order,
                          height: AppSize.size18.h,
                          width: AppSize.size18.w,
                        ),
                        Text(
                          context.appLocaleLanguage.order,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.space14.w),
                Expanded(
                  child: AppButton(
                    text: context.appLocaleLanguage.trade,
                    onPressed: () {
                      widget.tabController.animateTo(1);
                    },
                    height: AppSize.size38.h,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

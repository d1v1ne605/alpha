import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/trading/chart/chart_screen.dart';
import 'package:alpha/presentation/pages/trading/trade/trade_screen.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TradingScreen extends StatefulWidget {
  final CoinModel? coin;
  final bool isChangeCoin;

  const TradingScreen({super.key, this.coin, required this.isChangeCoin});

  @override
  State<TradingScreen> createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late TradeViewModel vm;
  late List<Tab> tabs;

  @override
  void initState() {
    super.initState();
    vm = getIt<TradeViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs = [
      Tab(text: context.appLocaleLanguage.tabChart),
      Tab(text: context.appLocaleLanguage.tabTrade),
    ];
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<TradeViewModel>(
      useSelector: true,
      autoDispose: false,
      padding: false,
      viewModelBuilder: () => getIt<TradeViewModel>(),
      onModelReady: (vm) {
        vm.viewModelAddListener(
          vm.globalViewModel,
          vm.onGlobalViewModelChanged,
        );
        vm.viewModelAddListener(
          vm.globalViewModel.latestOrderBookNotifier,
          vm.onLatestOrderBookChanged,
        );
        vm.viewModelAddListener(
          vm.globalViewModel.latestedTickerNotifier,
          vm.coinGetStream,
        );
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          vm.statusExecutingOrder = null;
          await vm.loadCoins();
          await vm.initializeCoin(widget.coin);
          vm.initializeSelectedOrderType(context);
        });
      },
      onModelDispose: (vm) {
        vm.viewModelRemoveListener(
          vm.globalViewModel,
          vm.onGlobalViewModelChanged,
        );
        vm.viewModelRemoveListener(
          vm.globalViewModel.latestOrderBookNotifier,
          vm.onLatestOrderBookChanged,
        );
        vm.viewModelRemoveListener(
          vm.globalViewModel.latestedTickerNotifier,
          vm.coinGetStream,
        );
      },
      builder: (context, vm, child) {
        return Scaffold(
          body: Stack(
            children: [
              Column(
                children: [
                  CustomTabBar(controller: _tabController, tabs: tabs),
                  Expanded(
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _tabController,
                      children: [
                        ChartScreen(tabController: _tabController),
                        TradeScreen(),
                      ],
                    ),
                  ),
                ],
              ),
              Selector<TradeViewModel, CoinModel?>(
                selector: (_, viewModel) => viewModel.currentCoin,
                builder: (context, coin, child) {
                  if (coin == null) {
                    return Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.4),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

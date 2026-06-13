import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/coin_infor_crypto.dart';
import 'package:alpha/presentation/pages/home/coins_list_screen.dart';
import 'package:alpha/presentation/view_models/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CoinListCryptoDetail extends StatefulWidget {
  final CoinDetailModel? coin;

  const CoinListCryptoDetail({super.key, this.coin});

  @override
  State<CoinListCryptoDetail> createState() => _CoinListCryptoDetailState();
}

class _CoinListCryptoDetailState extends State<CoinListCryptoDetail>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Tab> tabs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs = [
      Tab(text: context.appLocaleLanguage.inforCoins),
      Tab(text: context.appLocaleLanguage.marketTrading),
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      viewModelBuilder: () => getIt<HomeViewModel>(),
      autoDispose: false,
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              AppHeader(
                textTitle: context.appLocaleLanguage.titleCryptoListDetail,
                onTap: () {
                  context.pop();
                },
              ),
              CustomTabBar(controller: _tabController, tabs: tabs),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: [
                    CoinInforCrypto(coin: widget.coin),
                    CoinsListScreen(
                      type: AppStorageKey.listCryptoKey,
                      isCheckCategory: false,
                      isCheckStar: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

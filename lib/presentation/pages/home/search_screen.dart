import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/crypto_data_row.dart';
import 'package:alpha/core/widgets/custom_header_search.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/trading/trade/trade_screen.dart';
import 'package:alpha/presentation/pages/trading/trading_screen.dart';
import 'package:alpha/presentation/view_models/home/home_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      useSelector: true,
      padding: true,
      autoDispose: false,
      viewModelBuilder: () => getIt<HomeViewModel>(),
      builder: (context, vm, child) {
        return Scaffold(
          body: Column(
            children: [
              CustomHeaderSearch(
                leftIcon: GestureDetector(
                  onTap: () {
                    vm.searchController.clear();
                    context.pop();
                  },

                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.textPrimary,
                  ),
                ),
                titleWidget: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.iconSearch,
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                  ),
                  child: TextField(
                    controller: vm.searchController,
                    textAlignVertical: TextAlignVertical.center,
                    style: TextStyle(fontSize: AppSize.size14.sp),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.grey,
                        size: AppSize.size20.sp,
                      ),
                      hintStyle: TextStyle(
                        color: AppColors.grey,
                        fontSize: AppSize.size12.sp,
                      ),
                      hintText: context.appLocaleLanguage.search,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              Selector<HomeViewModel, List<CoinModel>>(
                selector: (context, vm) => vm.filteredCoins,
                builder: (context, filteredCoins, child) => Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: filteredCoins.length,
                    itemBuilder: (context, index) {
                      final data = filteredCoins[index];
                      return CryptoDataRow(
                        name: data.name,
                        volume: data.volume,
                        price: FormatterUtils.formatTokenValue(
                          value: double.parse(data.lastPrice),
                        ),
                        usdPrice: FormatterUtils.formatTokenValue(
                          value: double.parse(data.usdPrice),
                        ),
                        change: FormatterUtils.toDoubleCleaned(
                          data.priceChangePercent,
                        ),
                        imagePath: data.iconUrl,
                        onTap: () {
                          vm.changeCoinSocket(data.id);
                          context.go(RouterPath.trade, extra: data);
                        },
                        isFavorite: data.ishar,
                        onStarTap: () {
                          vm.toggleFavorite(data.id);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

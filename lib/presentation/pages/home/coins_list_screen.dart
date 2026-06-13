import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/crypto_data_row.dart';
import 'package:alpha/core/widgets/custom_category_filter_bar.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/core/widgets/custom_table_header.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/presentation/view_models/home/home_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_svg.dart';

class CoinsListScreen extends StatefulWidget {
  final bool isCheckStar;
  final bool isCheckCategory;
  final bool isCheckImage;
  final String type;
  final int? count;
  final List<String>? categories;

  const CoinsListScreen({
    super.key,
    required this.type,
    this.isCheckStar = true,
    this.isCheckCategory = true,
    this.isCheckImage = true,
    this.categories,
    this.count,
  });

  @override
  State<CoinsListScreen> createState() => _CoinsListScreenState();
}

class _CoinsListScreenState extends State<CoinsListScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late CoinsListConfig _coinsListConfig;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _coinsListConfig = _getCoinsListConfig(vm);
  }

  List<String> get categories =>
      widget.categories ??
      [
        context.appLocaleLanguage.favorites,
        context.appLocaleLanguage.all,
        AppStorageKey.usdt,
        AppStorageKey.btc,
        AppStorageKey.eth,
        AppStorageKey.bnb,
        AppStorageKey.xmr,
        AppStorageKey.doge,
        AppStorageKey.ltc,
      ];

  HomeViewModel? _homeViewModel;

  HomeViewModel get vm {
    return _homeViewModel ??= context.read<HomeViewModel>();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (context.select<HomeViewModel, bool>((viewModel) => viewModel.isBusy)) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isCheckCategory
            ? ValueListenableBuilder<String>(
                valueListenable: vm.selectedCategoryNotifier,
                builder: (context, selectedCategory, child) {
                  return RepaintBoundary(
                    child: CategoryFilterBar(
                      items: categories,
                      selectedItem: selectedCategory,
                      onItemSelected: (value) {
                        vm.setSelectedCategory(value, context);
                      },
                    ),
                  );
                },
              )
            : const SizedBox.shrink(),
        SizedBox(height: AppSpacing.space10.h),
        Selector<HomeViewModel, String>(
          selector: (context, viewModel) =>
              viewModel.getCurrentSortedColumn(widget.type),
          builder: (context, sortedColumn, child) {
            return CustomTableHeader(
              flexName: 20,
              flexPrice: 15,
              flexChange: 15,
              sortIcon: AppSvg.top_down,
              backgroundColor: AppColors.background,
              textColor: AppColors.iconUnselected,
              currentSortedColumn: sortedColumn,
              onNameTap: () =>
                  _coinsListConfig.onSort!(AppStorageKey.nameHeader),
              onPriceTap: () =>
                  _coinsListConfig.onSort!(AppStorageKey.priceHeader),
              onChangeTap: () =>
                  _coinsListConfig.onSort!(AppStorageKey.changeHeader),
            );
          },
        ),
        Expanded(
          child: ValueListenableBuilder<String>(
            valueListenable: vm.selectedCategoryNotifier,
            builder: (context, selectedCategory, child) {
              context.select<HomeViewModel, List<CoinModel>>((viewModel) {
                _coinsListConfig = _getCoinsListConfig(viewModel);
                return _coinsListConfig.coins;
              });

              final result = _getFilteredCoinsAndCount(selectedCategory);
              final filteredCoins = result.filterCoins;
              final showLearnMore = result.showLearnMore;
              final visibleItemCount = result.visibleItemCount;

              return filteredCoins.isNotEmpty
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: widget.isCheckImage
                          ? NeverScrollableScrollPhysics()
                          : BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: showLearnMore
                          ? visibleItemCount + 1
                          : visibleItemCount,
                      itemBuilder: (context, index) {
                        if (showLearnMore && index == visibleItemCount) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: AppSpacing.space20.h,
                              ),
                              child: TextButton(
                                onPressed: () {
                                  context.go(RouterPath.discover);
                                },
                                child: Text(
                                  context.appLocaleLanguage.learnMore,
                                  style: AppTextStyles.primaryLabel.copyWith(
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                        final data = filteredCoins[index];
                        return Selector<HomeViewModel, String>(
                          selector: (context, viewModel) =>
                              viewModel.checkPriceCurrency(
                                data.base_unit,
                                data.lastPriceCurrency,
                              ),
                          builder: (context, priceCurrencies, child) {
                            return CryptoDataRow(
                              isChangeImage: widget.isCheckImage,
                              name: data.name,
                              volume: data.volume,
                              price: FormatterUtils.formatTokenValue(
                                value: double.parse(
                                  data.lastPrice,
                                ).truncateToDecimalPlaces(data.price_precision),
                              ),
                              usdPrice: FormatterUtils.formatTokenValue(
                                value: double.parse(data.usdPrice),
                              ),
                              change: FormatterUtils.toDoubleCleaned(
                                data.priceChangePercent,
                              ),
                              imagePath: data.iconUrl,
                              onTap: () {
                                vm.saveLastTappedCoinId(data.id);
                                vm.changeCoinSocket(data.id);
                                context.go(RouterPath.trade, extra: data);
                              },
                              isFavorite: data.ishar,
                              onStarTap: widget.isCheckStar
                                  ? () async {
                                      await vm.toggleFavorite(data.id);
                                    }
                                  : null,
                            );
                          },
                        );
                      },
                    )
                  : Center(child: CustomNoData());
            },
          ),
        ),
      ],
    );
  }

  CoinsListConfig _getCoinsListConfig(HomeViewModel viewModel) {
    switch (widget.type) {
      case AppStorageKey.listCryptoKey:
        return (
          coins: viewModel.cryptoListCoin,
          onSort: viewModel.onSort,
          sortedColumn: viewModel.currentSortedColumn,
        );
      case AppStorageKey.listSpotKey:
        return (
          coins: viewModel.sortedData,
          onSort: viewModel.onSort,
          sortedColumn: viewModel.currentSortedColumn,
        );

      case AppStorageKey.listNewKey:
        return (
          coins: viewModel.newCoinsData,
          onSort: viewModel.onNewCoinsSort,
          sortedColumn: viewModel.currentNewCoinsSortedColumn,
        );

      case AppStorageKey.listTopGainersKey:
        final coins = viewModel.sortedData.where((coin) {
          final change = FormatterUtils.toDoubleCleaned(
            coin.priceChangePercent,
          );
          return change >= 0.0;
        }).toList();
        return (
          coins: coins,
          onSort: viewModel.onSort,
          sortedColumn: viewModel.currentSortedColumn,
        );

      case AppStorageKey.listTopVolumesKey:
        return (
          coins: viewModel.topVolumesData,
          onSort: viewModel.onTopVolumesSort,
          sortedColumn: viewModel.currentTopVolumesSortedColumn,
        );
      default:
        return (coins: [], onSort: null, sortedColumn: null);
    }
  }

  ({List<CoinModel> filterCoins, bool showLearnMore, int visibleItemCount})
  _getFilteredCoinsAndCount(String selectedCategory) {
    final filteredCoins = vm.filteredCoinsAfterSorted(
      coins: _coinsListConfig.coins,
      selectedCategory: selectedCategory,
      isCheckCategory: widget.isCheckCategory,
    );
    final showLearnMore =
        widget.count != null && filteredCoins.length > widget.count!;
    final visibleItemCount = widget.count != null
        ? (filteredCoins.length < widget.count!
              ? filteredCoins.length
              : widget.count!)
        : filteredCoins.length;
    return (
      filterCoins: filteredCoins,
      showLearnMore: showLearnMore,
      visibleItemCount: visibleItemCount,
    );
  }
}

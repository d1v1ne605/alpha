import 'dart:async';

import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/crypto_data_row.dart';
import 'package:alpha/core/widgets/custom_category_filter_bar.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/core/widgets/custom_table_header.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/view_models/home/home_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CoinListCrypto extends StatelessWidget {
  const CoinListCrypto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final categories = [
      context.appLocaleLanguage.favorites,
      context.appLocaleLanguage.all,
    ];
    return BaseView(
      autoDispose: false,
      padding: false,
      viewModelBuilder: () => getIt<HomeViewModel>(),
      builder: (context, vm, child) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: vm.selectedCategoryNotifier,
                builder: (context, selectedCategory, _) {
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
              ),
              ValueListenableBuilder<String?>(
                valueListenable: vm.currentSortedColumnCryptoNotifier,
                builder: (context, currentSortedColumn, _) {
                  return CustomTableHeader(
                    sortIcon: AppSvg.top_down,
                    backgroundColor: AppColors.background,
                    textColor: AppColors.iconUnselected,
                    currentSortedColumn: currentSortedColumn,
                    flexName: 15,
                    flexPrice: 10,
                    flexChange: 10,
                    onNameTap: () => vm.onSortCrypto(AppStorageKey.nameHeader),
                    onPriceTap: () =>
                        vm.onSortCrypto(AppStorageKey.priceHeader),
                    onChangeTap: () =>
                        vm.onSortCrypto(AppStorageKey.changeHeader),
                  );
                },
              ),
              SizedBox(height: AppSpacing.space10.h),
              // List coin
              Expanded(
                child: ValueListenableBuilder<List<CoinDetailModel>>(
                  valueListenable: vm.filteredCoinsNotifier,
                  builder: (context, filteredCoins, _) {
                    if (filteredCoins.isEmpty) {
                      return const Center(child: Center(child: CustomNoData()));
                    }
                    return ListView.separated(
                      separatorBuilder: (context, index) {
                        return SizedBox(height: AppSpacing.space14.h);
                      },
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space20.w,
                      ),
                      itemCount: filteredCoins.length,
                      itemBuilder: (context, index) {
                        final coin = filteredCoins[index];
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              AppSpacing.space4.r,
                            ),
                            border: Border.all(color: AppColors.divider),
                          ),
                          child: CryptoDataRow(
                            isChangeVolumeCrypto: true,
                            isShowArrow: true,
                            isChangeImage: true,
                            isChangePriceCrypto: true,
                            flexName: 15,
                            flexPrice: 10,
                            flexChange: 10,
                            volume: coin.title,
                            key: ValueKey(coin.id),
                            name: coin.currencyId.toUpperCase(),
                            usdPrice: FormatterUtils.formatTokenValue(
                              value: double.parse(coin.last ?? '0.0'),
                            ),
                            change: FormatterUtils.toDoubleCleaned(
                              coin.price_change_percent,
                            ),
                            imagePath: coin.icon_url,
                            isFavorite: coin.ishar,
                            onStarTap: () {
                              vm.toggleFavoriteCrypto(coin.currencyId);
                            },
                            onTap: () {
                              context.push(
                                RouterPath.cryptoDetail,
                                extra: coin,
                              );
                              unawaited(vm.getCoinDetail(coin.currencyId));
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

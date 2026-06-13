import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/core/widgets/custom_header_search.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/asset_fee/fiat_screen.dart';
import 'package:alpha/presentation/pages/assets/share/coin_item.dart';
import 'package:alpha/presentation/pages/profile/appbar_screen.dart';
import 'package:alpha/presentation/view_models/asset_fee/asset_fee_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_svg.dart';
import 'crypto_screen.dart';

class AssetFeeScreen extends StatefulWidget {
  const AssetFeeScreen({super.key});

  @override
  State<AssetFeeScreen> createState() => _AssetFeeScreenState();
}

class _AssetFeeScreenState extends State<AssetFeeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late List<Tab> tabs;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs = [
      Tab(text: context.appLocaleLanguage.crypto),
      Tab(text: context.appLocaleLanguage.fiat),
    ];
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<AssetFeeViewModel>(
      padding: true,
      autoDispose: false,
      viewModelBuilder: () => getIt<AssetFeeViewModel>(),
      builder: (context, vm, child) {
        return Scaffold(
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: AppSize.size20.w,
                  right: AppSize.size20.w,
                ),
                child: AppBarScreen(
                  title: context.appLocaleLanguage.feeTransacrion,
                  showNotification: false,
                  showScan: false,
                ),
              ),
              CustomHeaderSearch(
                backgroundColor: AppColors.background,
                titleWidget: GestureDetector(
                  onTap: () {
                    vm.resetCoins();
                    AppBottomSheetWidget.show(
                      context: context,
                      minChildSize: 0.8,
                      maxChildSize: 0.9,
                      child: ValueListenableBuilder<List<CurrencyModel>>(
                        valueListenable: vm.filteredItemsNotifier,
                        builder: (context, filteredCoins, _) {
                          return CoinItem(
                            searchController: vm.searchController,
                            filterCoins: filteredCoins,
                            onSearch: vm.onSearchChanged,
                            onCoinSelected: vm.onCoinSelected,
                          );
                        },
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: AppSize.size38.h,
                    decoration: BoxDecoration(
                      color: AppColors.iconSearch,
                      borderRadius: BorderRadius.circular(AppSize.size4.r),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.space12.w,
                          ),
                          child: Icon(
                            Icons.search,
                            color: AppColors.grey,
                            size: AppSize.size20.sp,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            context.appLocaleLanguage.search,
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: AppSize.size14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                rightIcon: GestureDetector(
                  onTap: () {
                    context.pushNamed(RouterName.inviteFriend);
                  },
                  child: SvgPicture.asset(
                    AppSvg.gift_friends,
                    width: AppSize.size38.w,
                    height: AppSize.size38.h,
                  ),
                ),
              ),
              CustomTabBar(controller: _tabController, tabs: tabs),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _tabController,
                  children: const [
                    Center(child: CryptoScreen()),
                    Center(child: FiatScreen()),
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

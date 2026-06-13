import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/banners/custom_tab_bar.dart';
import 'package:alpha/core/widgets/custom_header_search.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/discover/crypto_list/coin_list_crypto.dart';
import 'package:alpha/presentation/pages/home/coins_list_screen.dart';
import 'package:alpha/presentation/view_models/home/home_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({Key? key}) : super(key: key);

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with TickerProviderStateMixin {
  late HomeViewModel vm;

  late List<Tab> tabs;

  @override
  void initState() {
    super.initState();
    vm = getIt<HomeViewModel>();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tabs = [
      Tab(text: context.appLocaleLanguage.spotCoins),
      Tab(text: context.appLocaleLanguage.cryptoCoins),
      Tab(text: context.appLocaleLanguage.topGainers),
      Tab(text: context.appLocaleLanguage.newCoins),
      Tab(text: context.appLocaleLanguage.topVolumes),
    ];
    vm.initTabController(this, vm.selectedTabIndexDis.value, tabs.length, (
      index,
    ) {
      vm.setSelectedTabIndexDis(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      padding: false,
      autoDispose: false,
      viewModelBuilder: () => getIt<HomeViewModel>(),
      onModelReady: (vm) {
        vm.initializeSelectedCategory(context);
        vm.loadCoinCrypto();
        vm.viewModelAddListener(
          vm.globalViewModel,
          vm.onGlobalViewModelChanged,
        );
        vm.setSelectedCategory(context.appLocaleLanguage.all, context);
      },
      onModelDispose: (vm) {
        vm.viewModelRemoveListener(
          vm.globalViewModel,
          vm.onGlobalViewModelChanged,
        );
      },
      builder: (context, viewModel, child) {
        return Scaffold(
          body: Column(
            children: [
              SizedBox(height: AppSpacing.space10.h),
              CustomHeaderSearch(
                titleWidget: InkWell(
                  onTap: () {
                    context.push(RouterPath.search);
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
              ),
              CustomTabBar(controller: vm.tabController, tabs: tabs),
              Expanded(
                child: TabBarView(
                  controller: vm.tabController,
                  children: [
                    CoinsListScreen(
                      type: AppStorageKey.listSpotKey,
                      isCheckImage: false,
                    ),
                    CoinListCrypto(),
                    CoinsListScreen(
                      type: AppStorageKey.listTopGainersKey,
                      isCheckImage: false,
                    ),
                    CoinsListScreen(
                      type: AppStorageKey.listNewKey,
                      isCheckImage: false,
                    ),
                    CoinsListScreen(
                      type: AppStorageKey.listTopVolumesKey,
                      isCheckImage: false,
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppSpacing.space30.h),
            ],
          ),
        );
      },
    );
  }
}

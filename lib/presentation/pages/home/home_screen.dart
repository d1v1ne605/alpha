import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/network/auth_change_notifier.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/custom_header_search.dart';
import 'package:alpha/core/widgets/custom_tab_bar.dart';
import 'package:alpha/data/models/banner_models/banner_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/home/coins_list_screen.dart';
import 'package:alpha/presentation/pages/home/favorite_screen.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/banners/custom_banner.dart';
import '../../../../core/widgets/banners/custom_coin.dart';
import '../../../../core/widgets/banners/top_section_view.dart';
import '../../../../core/widgets/total_assets_view/total_assets_view.dart';
import '../../../core/base/base_view.dart';
import '../../view_models/home/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
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
      Tab(text: context.appLocaleLanguage.favorites),
      Tab(text: context.appLocaleLanguage.topGainers),
      Tab(text: context.appLocaleLanguage.newCoins),
      Tab(text: context.appLocaleLanguage.topVolumes),
    ];
    vm.initTabController(
      this,
      vm.selectedTabIndexHome.value,
      tabs.length,
      (index) => vm.setSelectedTabIndexHome(index),
    );
  }

  State<HomeScreen> createState() => _HomeScreenState();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      padding: false,
      autoDispose: false,
      useSelector: true,
      viewModelBuilder: () => getIt<HomeViewModel>(),
      onModelReady: (vm) {
        vm.viewModelAddListener(
          vm.globalViewModel,
          vm.onGlobalViewModelChanged,
        );
      },
      onModelDispose: (vm) {
        vm.viewModelRemoveListener(
          vm.globalViewModel,
          vm.onGlobalViewModelChanged,
        );
      },
      builder: (BuildContext context, HomeViewModel vm, Widget? child) {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RepaintBoundary(
                  child: CustomHeaderSearch(
                    leftIcon: Selector<AuthChangeNotifier, bool>(
                      selector: (context, authNotifier) =>
                          authNotifier.isAuthenticated,
                      builder: (context, isAuthenticated, child) =>
                          GestureDetector(
                            onTap: () {
                              if (isAuthenticated) {
                                context.pushNamed(RouterName.profile);
                              } else {
                                context.go(RouterPath.login);
                              }
                            },
                            child: SvgPicture.asset(
                              AppSvg.nice,
                              width: AppSize.size24.w,
                              height: AppSize.size24.h,
                              color: AppColors.textPrimary,
                            ),
                          ),
                    ),
                    rightIcon: GestureDetector(
                      onTap: () {
                        context.pushNamed(RouterName.announcements);
                      },
                      child: SvgPicture.asset(
                        AppSvg.noti,
                        width: AppSize.size24.w,
                        height: AppSize.size24.h,
                      ),
                    ),
                    backgroundColor: AppColors.background,
                    isChecked: true,
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
                ),
                Selector<AuthChangeNotifier, bool>(
                  selector: (context, authNotifier) =>
                      authNotifier.isAuthenticated,
                  builder: (context, isAuthenticated, child) {
                    if (isAuthenticated) {
                      return Column(children: [TotalAssetsScreen()]);
                    } else {
                      return TopSectionView();
                    }
                  },
                ),
                const SizedBox(height: AppSpacing.space15),
                _bannerSection(vm),
                const SizedBox(height: AppSpacing.space15),
                CustomCoin(),
                SizedBox(height: AppSpacing.space15),
                Container(
                  color: AppColors.background,
                  child: CustomTabBar(tabs: tabs, controller: vm.tabController),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.8,
                  child: TabBarView(
                    controller: vm.tabController,
                    children: [
                      FavoriteScreen(),
                      CoinsListScreen(
                        key: PageStorageKey(AppStorageKey.listTopGainersKey),
                        type: AppStorageKey.listTopGainersKey,
                        isCheckStar: false,
                        count: 10,
                        isCheckCategory: false,
                      ),
                      CoinsListScreen(
                        key: const PageStorageKey(AppStorageKey.listNewKey),
                        type: AppStorageKey.listNewKey,
                        isCheckStar: false,
                        count: 10,
                        isCheckCategory: false,
                      ),
                      CoinsListScreen(
                        key: const PageStorageKey(
                          AppStorageKey.listTopVolumesKey,
                        ),
                        type: AppStorageKey.listTopVolumesKey,
                        isCheckStar: false,
                        count: 10,
                        isCheckCategory: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _bannerSection(HomeViewModel vm) {
    return Selector<
      HomeViewModel,
      ({bool isBusy, String? errorMessage, List<BannerModel> banners})
    >(
      selector: (context, viewModel) => (
        isBusy: viewModel.isBusy,
        errorMessage: viewModel.errorMessage,
        banners: viewModel.banners,
      ),
      builder: (context, record, child) {
        if (record.isBusy) {
          return const Center(child: CircularProgressIndicator());
        } else if (record.errorMessage != null) {
          return Padding(
            padding: const EdgeInsets.all(AppSize.size16),
            child: Column(
              children: [
                Text(
                  record.errorMessage ?? context.appLocaleLanguage.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                const SizedBox(height: AppSpacing.space8),
                ElevatedButton(
                  onPressed: vm.fetchBanners,
                  child: Text(context.appLocaleLanguage.retry),
                ),
              ],
            ),
          );
        } else if (record.banners.isEmpty) {
          return Center(child: Text(context.appLocaleLanguage.bannerIsEmpty));
        } else {
          return CustomBanner();
        }
      },
    );
  }
}

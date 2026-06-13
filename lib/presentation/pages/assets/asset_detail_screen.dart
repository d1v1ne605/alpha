import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/widgets/app_header.dart';
import 'package:alpha/data/models/asset/asset_detail_model.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/assets/share/assets_overview_card.dart';
import 'package:alpha/presentation/pages/assets/wallet/action_section.dart';
import 'package:alpha/presentation/pages/assets/wallet/allocation_section.dart';
import 'package:alpha/presentation/pages/assets/wallet/market_list_section.dart';
import 'package:alpha/presentation/view_models/asset/asset_detail_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetDetailScreen extends StatelessWidget {
  final AssetDetailModel assetData;

  const AssetDetailScreen({Key? key, required this.assetData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AssetDetailViewModel>(
      padding: false,
      autoDispose: false,
      viewModelBuilder: () => getIt<AssetDetailViewModel>(),
      onModelReady: (vm) => vm.init(assetData),
      builder: (context, vm, child) {
        final double screenHeight = MediaQuery.of(context).size.height;
        return Scaffold(
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.space20,
              right: AppSpacing.space20,
              bottom: AppSpacing.space40,
            ),
            child: ActionSection(asset: assetData, viewModel: vm),
          ),
          backgroundColor: AppColors.background,
          body: SingleChildScrollView(
            child: vm.isBusy
                ? SizedBox(
                    height: screenHeight,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  )
                : SizedBox(
                    child: Column(
                      children: [
                        AppHeader(
                          textTitle: vm.assetDetail.asset.name,
                          titleIcon: CircleAvatar(
                            radius: AppSize.size16.r,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: Image.network(
                                vm.assetDetail.asset.iconUrl,
                                width: AppSize.size32.w,
                                height: AppSize.size32.h,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.space20.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: AppSpacing.space20.h),
                              AssetsOverviewCard(
                                assetOverview: vm.assetDetail.overview,
                                showActions: false,
                                isShowAssets: vm.isShowingAssets,
                                showAssets: () {
                                  vm.toggleAssetVisibility();
                                },
                              ),
                              SizedBox(height: AppSpacing.space20.h),
                              AllocationSection(
                                asset: vm.assetDetail.asset,
                                overview: vm.assetDetail.overview,
                                equivalent: vm.assetDetail.equivalent,
                              ),
                              SizedBox(height: AppSpacing.space15.h),
                              SizedBox(
                                height: screenHeight * AppSize.size0_3,
                                child: MarketListSection(
                                  coins: vm.assetDetail.marketList ?? [],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

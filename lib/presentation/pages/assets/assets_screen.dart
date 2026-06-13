import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/mockdata/asset_mockdata.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/assets/share/assets_overview_card.dart';
import 'package:alpha/presentation/pages/assets/wallet/wallet_list_section.dart';
import 'package:alpha/presentation/view_models/asset/asset_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AssetsScreen extends StatelessWidget {
  const AssetsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AssetViewModel>(
      padding: false,
      autoDispose: false,
      viewModelBuilder: () => getIt<AssetViewModel>(),
      onModelReady: (vm) {
        vm.viewModelAddListener(
          vm.globalViewModel,
          vm.onGlobalViewModelChanged,
        );
        vm.init();
      },
      onModelDispose: (vm) {
        vm.viewModelRemoveListener(
          vm.globalViewModel,
          vm.onGlobalViewModelChanged,
        );
      },
      builder: (context, vm, child) {
        if (vm.assetOverview == null) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return Scaffold(
          backgroundColor: AppColors.background,
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space20.w,
                      vertical: AppSpacing.space20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            context.appLocaleLanguage.assetsTitle,
                            style: AppTextStyles.title1.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.space20.h),
                        AssetsOverviewCard(
                          isShowAssets: vm.isShowingAssets,
                          showAssets: vm.toggleAssetVisibility,
                          assetOverview: vm.assetOverview ?? defaultValue,
                        ),
                        SizedBox(height: AppSpacing.space20.h),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Padding(
              padding: EdgeInsets.only(
                left: AppSpacing.space20.w,
                right: AppSpacing.space20.w,
                bottom: AppSpacing.space30.h,
              ),
              child: WalletListSection(),
            ),
          ),
        );
      },
    );
  }
}

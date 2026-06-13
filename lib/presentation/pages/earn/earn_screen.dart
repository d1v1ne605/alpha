import 'package:alpha/core/base/base_view.dart';
import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_image.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/injection/injector.dart';
import 'package:alpha/presentation/pages/assets/share/assets_overview_card.dart';
import 'package:alpha/presentation/pages/earn/earn_list_section.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EarnScreen extends StatelessWidget {
  const EarnScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<EarnViewModel>(
      padding: false,
      autoDispose: false,
      viewModelBuilder: () => getIt<EarnViewModel>(),
      onModelReady: (vm) {
        vm.loadEarnWallets();
      },
      builder: (context, vm, child) {
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
                            context.appLocaleLanguage.overview,
                            style: AppTextStyles.title1.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: AppSpacing.space20.h),
                        AssetsOverviewCard(
                          isShowAssets: vm.isShowingAssets,
                          showAssets: () {
                            vm.toggleAssetVisibility();
                          },
                          showActions: false,
                          assetOverview: vm,
                          isEarn: true,
                        ),
                        SizedBox(height: AppSpacing.space10.h),
                        Image.asset(
                          AppImage.banner_earn,
                          height: AppSize.size50.h,
                          fit: BoxFit.cover,
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
              child: EarnListSection(),
            ),
          ),
        );
      },
    );
  }
}

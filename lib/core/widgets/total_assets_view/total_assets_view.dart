import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/asset/asset_overview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../presentation/view_models/home/home_view_model.dart';
import '../../constants/app_spacing.dart';

class TotalAssetsScreen extends StatefulWidget {
  const TotalAssetsScreen({super.key});

  @override
  State<TotalAssetsScreen> createState() => _TotalAssetsScreenState();
}

class _TotalAssetsScreenState extends State<TotalAssetsScreen> {
  HomeViewModel? _homeViewModel;

  HomeViewModel get vm => _homeViewModel ??= context.read<HomeViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                context.appLocaleLanguage.estTotalAssets,
                style: AppTextStyles.content2.copyWith(color: AppColors.white),
              ),
              SizedBox(width: AppSpacing.space10.w),
              ValueListenableBuilder<bool>(
                valueListenable: vm.isBalanceVisibleNotifier,
                builder: (context, isVisible, child) {
                  return GestureDetector(
                    onTap: vm.toggleBalanceVisibility,
                    child: SvgPicture.asset(
                      isVisible ? AppSvg.eyeVisible : AppSvg.eyeHidden,
                      colorFilter: const ColorFilter.mode(
                        AppColors.grey,
                        BlendMode.srcIn,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: AppSpacing.space5.h),
          Selector<HomeViewModel, AssetOverview?>(
            selector: (context, viewModel) => viewModel.assetOverview,
            builder: (context, assetOverview, child) {
              final totalAssets = assetOverview?.totalAssets ?? "0.0";
              final unit = assetOverview?.unit ?? "USDT";
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: vm.isBalanceVisibleNotifier,
                    builder: (context, isVisible, child) {
                      return Text(
                        isVisible ? totalAssets : "**********",
                        style: AppTextStyles.content4.copyWith(
                          color: AppColors.white,
                        ),
                      );
                    },
                  ),
                  SizedBox(width: AppSpacing.space8.w),
                  Text(
                    unit,
                    style: AppTextStyles.content3.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  SizedBox(width: AppSpacing.space8.w),
                  SvgPicture.asset(AppSvg.dropDown),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

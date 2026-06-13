import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_detail_wrapper.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/presentation/pages/trading/chart/blockchain_explore_row.dart';
import 'package:alpha/presentation/pages/trading/chart/info_row.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OverviewChart extends StatelessWidget {
  final TabController tabController;

  const OverviewChart({Key? key, required this.tabController})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentCoin = context.select<TradeViewModel, CoinModel?>(
      (viewModel) => viewModel.currentCoin,
    );
    return Selector<TradeViewModel, CoinDetailWrapper?>(
      selector: (context, viewModel) => viewModel.coinDetail,
      builder: (context, coinDetail, child) {
        final coin = coinDetail?.data;
        final formattedDate = FormatterUtils.formatDateYMD(coin?.releaseDate);
        if (coin == null) {
          return const Center(child: CustomNoData());
        }
        return Scaffold(
          body: Padding(
            padding: EdgeInsets.only(
              left: AppSpacing.space20.w,
              right: AppSpacing.space20.w,
              top: AppSpacing.space15.h,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        currentCoin?.iconUrl ?? '',
                        width: AppSize.size32.w,
                        height: AppSize.size32.h,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: AppSize.size9.w),
                      Text(
                        coin.title,
                        style: AppTextStyles.content4.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSize.size24.h),
                  Text(
                    "${context.appLocaleLanguage.quickInformation} ${coin.currencyId.toUpperCase()}",
                    style: AppTextStyles.content4.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSize.size5.h),
                  Text(
                    coin.information,
                    style: AppTextStyles.content3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(height: AppSize.size5.h),

                  Divider(height: AppSize.size1.h, color: AppColors.divider),
                  InfoRow(
                    title: context.appLocaleLanguage.engTokenName,
                    value: currentCoin?.lastName.toUpperCase() ?? '',
                  ),
                  InfoRow(
                    title: context.appLocaleLanguage.withdrawStatus,
                    value: currentCoin?.withdrawal_enabled ?? false == true
                        ? context.appLocaleLanguage.enable
                        : context.appLocaleLanguage.disable,
                  ),
                  InfoRow(
                    title: context.appLocaleLanguage.releaseDate,
                    value: formattedDate,
                  ),
                  InfoRow(
                    title: context.appLocaleLanguage.depositStatus,
                    value: currentCoin?.deposit_enabled ?? false == true
                        ? context.appLocaleLanguage.enable
                        : context.appLocaleLanguage.disable,
                  ),
                  InfoRow(
                    title: context.appLocaleLanguage.issuePriceUSD,
                    value: currentCoin?.lastPriceCurrency ?? '0',
                  ),
                  InfoRow(
                    title: context.appLocaleLanguage.maximumSupply,
                    value: coin.maximumSupply?.toString() ?? '0',
                  ),
                  InfoRow(
                    title: context.appLocaleLanguage.blockchainType,
                    value: coin.blockchainType,
                  ),
                  BlockchainExploreRow(
                    label: context.appLocaleLanguage.blockchainExplore,
                    url: coin.blockchainExplorerUrl,
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

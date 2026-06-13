import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/announcements/widgets/no_data_widget.dart';
import 'package:alpha/presentation/pages/asset_fee/crypto_detail_bottom.dart';
import 'package:alpha/presentation/view_models/asset_fee/asset_fee_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoinListScreen extends StatefulWidget {
  final Future<void> Function(AssetFeeViewModel) onInit;

  const CoinListScreen({super.key, required this.onInit});

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onInit(context.read<AssetFeeViewModel>());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetFeeViewModel>(
      builder: (context, vm, child) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.space15.h),
              vm.isBusy
                  ? Expanded(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : Expanded(
                      child: ValueListenableBuilder<List<CurrencyModel>>(
                        valueListenable: vm.filteredItemsNotifier,
                        builder: (context, coins, _) {
                          if (coins.isEmpty) {
                            return const Center(child: NoDataWidget());
                          }
                          return ListView.separated(
                            padding: EdgeInsets.zero,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: AppSpacing.space15.h),
                            itemCount: coins.length,
                            itemBuilder: (context, index) {
                              final coin = coins[index];
                              return GestureDetector(
                                onTap: () {
                                  callNetwork(context, vm, coin);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      AppSize.size4.r,
                                    ),
                                    border: Border.all(
                                      color: AppColors.borderCard,
                                      width: AppSize.size1.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: AppSpacing.space10.h,
                                    horizontal: AppSpacing.space15.h,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 4,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              radius: AppSize.size16.r,
                                              backgroundColor:
                                                  Colors.transparent,
                                              child: ClipOval(
                                                child: Image.network(
                                                  coin.icon_url,
                                                  width: AppSize.size32.r,
                                                  height: AppSize.size32.r,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: AppSpacing.space9.w,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    coin.id.toUpperCase(),
                                                    style: AppTextStyles
                                                        .content4
                                                        .copyWith(
                                                          color: AppColors
                                                              .textPrimary,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.space8.w),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              context
                                                  .appLocaleLanguage
                                                  .depositMin,
                                              style: AppTextStyles.content2
                                                  .copyWith(
                                                    color:
                                                        AppColors.subtitleText,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: AppSpacing.space5.h,
                                            ),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                FormatterUtils.formatCustomDeposit(
                                                  double.tryParse(
                                                        coin.min_deposit_amount,
                                                      )?.truncateToDecimalPlaces(
                                                        coin.precision,
                                                      ) ??
                                                      0,
                                                ),
                                                style: AppTextStyles.body
                                                    .copyWith(
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: AppSpacing.space8.w),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              context
                                                  .appLocaleLanguage
                                                  .withdrawMin,
                                              style: AppTextStyles.content2
                                                  .copyWith(
                                                    color:
                                                        AppColors.subtitleText,
                                                  ),
                                            ),
                                            SizedBox(
                                              height: AppSpacing.space5.h,
                                            ),
                                            FittedBox(
                                              fit: BoxFit.scaleDown,
                                              child: Text(
                                                FormatterUtils.formatCustomWithdraw(
                                                  double.tryParse(
                                                        coin.min_withdraw_amount,
                                                      )?.truncateToDecimalPlaces(
                                                        coin.precision,
                                                      ) ??
                                                      0,
                                                ),
                                                style: AppTextStyles.body
                                                    .copyWith(
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: AppColors.iconPrimary,
                                        size: AppSize.size16.w,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
              SizedBox(height: AppSpacing.space40.h),
            ],
          ),
        );
      },
    );
  }

  void callNetwork(
    BuildContext context,
    AssetFeeViewModel vm,
    CurrencyModel coin,
  ) async {
    if (vm.isSelectNetwork) {
      vm.networks.clear();
      vm.selectedNetwork = null;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    await vm.loadNetworks(coin.id);
    context.pop();
    if (vm.networks.isNotEmpty) {
      AppBottomSheetWidget.show(
        context: context,
        child: ChangeNotifierProvider.value(
          value: vm,
          child: CryptoDetailBottom(crypto: coin),
        ),
      );
    }
  }
}

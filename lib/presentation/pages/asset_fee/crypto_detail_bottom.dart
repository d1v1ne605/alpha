import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/home_market/currency_model.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/view_models/asset_fee/asset_fee_view_model.dart';
import 'package:alpha/routers/router_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'networkSelector.dart';

class CryptoDetailBottom extends StatefulWidget {
  final CurrencyModel crypto;

  const CryptoDetailBottom({super.key, required this.crypto});

  @override
  State<CryptoDetailBottom> createState() => _CryptoDetailBottomState();
}

class _CryptoDetailBottomState extends State<CryptoDetailBottom> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = context.read<AssetFeeViewModel>();
      vm.loadNetworks(widget.crypto.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssetFeeViewModel>(
      builder: (context, vm, _) {
        vm.setCryptoCoin(widget.crypto.id);
        return Container(
          padding: EdgeInsets.only(
            top: AppSpacing.space10.h,
            right: AppSpacing.space20.w,
            left: AppSpacing.space20.w,
            bottom: AppSpacing.space60.h,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const HandleBar(),
              SizedBox(height: AppSpacing.space18.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: AppSize.size16.r,
                    backgroundColor: Colors.transparent,
                    child: Image.network(
                      widget.crypto.icon_url,
                      width: AppSize.size32.r,
                      height: AppSize.size32.r,
                    ),
                  ),
                  SizedBox(width: AppSpacing.space8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.crypto.id.toUpperCase(),
                        style: AppTextStyles.content4.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.crypto.name,
                        style: AppTextStyles.content2.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.space13.h),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.stock,
                  borderRadius: BorderRadius.circular(AppSpacing.space4.r),
                ),
                child: vm.networks.isNotEmpty
                    ? NetworkSelector(
                        networks: vm.networks
                            .map((e) => e.blockchainName)
                            .toList(),
                        selected: vm.selectedNetwork?.blockchainName,
                        onChanged: (name) {
                          final network = vm.networks.firstWhere(
                            (n) => n.blockchainName == name,
                          );
                          vm.selectNetwork(network);
                        },
                      )
                    : const Center(
                        child: Text(
                          "No networks available",
                          style: TextStyle(color: AppColors.textTertiary),
                        ),
                      ),
              ),

              SizedBox(height: AppSpacing.space20.h),

              if (vm.selectedNetwork != null) ...[
                _buildFeeRow(
                  context.appLocaleLanguage.depositMin,
                  Text(
                    FormatterUtils.formatNumber(
                      value:
                          double.tryParse(
                            vm.selectedNetwork!.minDepositAmount,
                          )?.truncateToDecimalPlaces(8) ??
                          0,
                      decimalDigits: 8,
                    ),
                    style: AppTextStyles.content3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.space15.h),
                _buildFeeRow(
                  context.appLocaleLanguage.withdrawMin,
                  Text(
                    FormatterUtils.formatNumber(
                      value:
                          double.tryParse(
                            vm.selectedNetwork!.minWithdrawAmount,
                          )?.truncateToDecimalPlaces(8) ??
                          0,
                      decimalDigits: 8,
                    ),
                    style: AppTextStyles.content3.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.space15.h),
                _buildFeeRow(
                  context.appLocaleLanguage.withdrawFee,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: vm.selectedNetwork!.fees.map((fee) {
                      return Text(
                        "${FormatterUtils.formatNumber(value: fee.feeAmount.truncateToDecimalPlaces(8))} ${fee.feeCurrency.toUpperCase()}",
                        style: AppTextStyles.content3.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w400,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.appLocaleLanguage.deposit,
                      fontWeight: FontWeight.w700,
                      onPressed: () {
                        context.push(
                          RouterPath.deposit,
                          extra: widget.crypto.id.toUpperCase(),
                        );
                      },
                      size: AppButtonSizeEnum.small,
                      backgroundColor: AppColors.primary,
                    ),
                  ),
                  SizedBox(width: AppSpacing.space28.w),
                  Expanded(
                    child: AppButton(
                      text: context.appLocaleLanguage.trade,
                      fontWeight: FontWeight.w700,
                      onPressed: () {
                        final crypto = vm.cryptoListCoin.first;
                        context.go(RouterPath.trade, extra: crypto);
                      },
                      size: AppButtonSizeEnum.small,
                      backgroundColor: AppColors.background,
                      border: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFeeRow(String label, Widget valueWidget) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.content2.copyWith(color: AppColors.subtitleText),
        ),
        valueWidget,
      ],
    );
  }
}

import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WithdrawEarnBottomSheet extends StatelessWidget {
  WithdrawEarnBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<EarnViewModel>();

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: vm.amountController,
      builder: (context, value, _) {
        final text = value.text;
        final coin = vm.findCurrencyByWallet(vm.selectedWallet!.currencyId);
        String usdValue = "0 ${context.appLocaleLanguage.usdt.toUpperCase()}";
        if (text.isNotEmpty && coin != null) {
          final amount = double.tryParse(text) ?? 0;
          final price = double.tryParse(coin.lastPriceCurrency) ?? 0;
          final precision = coin.price_precision;
          final totalValue = (amount * price).toStringAsFixed(precision);
          usdValue =
              "$totalValue ${context.appLocaleLanguage.usdt.toUpperCase()}";
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            left: AppSize.size20.w,
            right: AppSize.size20.w,
            top: AppSize.size10.h,
            bottom: AppSize.size30.h,
          ),
          decoration: BoxDecoration(color: AppColors.bgWithEarn),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRow(context.appLocaleLanguage.convertUSD, usdValue),
              SizedBox(height: AppSize.size18.h),
              _buildRow(
                context.appLocaleLanguage.youWillReceive,
                "${text.isEmpty ? '0' : FormatterUtils.formatAmount(text)} ${vm.selectedWallet?.currencyId.toUpperCase() ?? ''}",
              ),
              SizedBox(height: AppSize.size65.h),
              SizedBox(
                child: AppButton(
                  fontWeight: FontWeight.w700,
                  text: context.appLocaleLanguage.assetsButtonWithdraw,
                  onPressed: () {
                    vm.executeWithdraw();
                  },
                  isEnabled: text.isNotEmpty,
                  borderRadius: AppSize.size4.r,
                  backgroundColor: text.isEmpty
                      ? AppColors.bgWithEarn
                      : AppColors.primary,
                  borderColor: AppColors.primary,
                  size: AppButtonSizeEnum.medium,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.content2.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.content2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

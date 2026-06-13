import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/data/models/earn/earn_wallets.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/format_usdt.dart';
import '../../../../core/widgets/app_button.dart';

class WithdrawEarnDetailScreen extends StatefulWidget {
  final double? availableBalance;
  final Function(double)? onInputValueChanged;

  const WithdrawEarnDetailScreen({
    Key? key,
    this.availableBalance,
    this.onInputValueChanged,
  }) : super(key: key);

  @override
  _WithdrawEarnDetailScreenState createState() =>
      _WithdrawEarnDetailScreenState();
}

class _WithdrawEarnDetailScreenState extends State<WithdrawEarnDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = context.read<EarnViewModel>();
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: AppSize.size20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(context.appLocaleLanguage.orderTableAmount),
                    SizedBox(height: AppSize.size5.h),
                    _buildTextField(
                      controller: vm.amountController,
                      hintText: context.appLocaleLanguage.withdrawAmount,
                      keyboardType: TextInputType.number,
                      suffixIcon: _buildAmountSuffix(context, vm),
                    ),
                    SizedBox(height: AppSize.size5.h),
                    Selector<EarnViewModel, EarnWalletData?>(
                      selector: (context, viewModel) =>
                          viewModel.selectedWallet,
                      builder: (context, wallet, child) {
                        return Row(
                          children: [
                            Text(
                              "${context.appLocaleLanguage.availableBalance} ${context.appLocaleLanguage.balance}",
                              style: AppTextStyles.content2.copyWith(
                                color: AppColors.textTertiary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Text(
                              " ${wallet?.balance ?? '0.0'} ${wallet?.currencyId.toUpperCase() ?? ''}",
                              style: AppTextStyles.content2.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: vm.amountController,
          builder: (context, value, _) {
            final text = value.text;
            final coin = vm.findCurrencyByWallet(
              vm.selectedWallet?.currencyId ?? '',
            );
            String usdValue =
                "0 ${context.appLocaleLanguage.usdt.toUpperCase()}";
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
        ),
      ],
    );
  }

  Widget _buildAmountSuffix(BuildContext context, EarnViewModel vm) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          onPressed: () {
            final balance = vm.selectedWallet?.balance.toString() ?? '0.0';
            vm.amountController.text = balance;
          },
          child: Text(
            context.appLocaleLanguage.all,
            style: AppTextStyles.content2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceRow(
    BuildContext context,
    int precision,
    EarnViewModel vm,
  ) {
    return Row(
      children: [
        Text(
          "${context.appLocaleLanguage.availableBalance} ${context.appLocaleLanguage.balance}",
          style: AppTextStyles.content2.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          " ${(vm.selectedWallet?.balance)} ${vm.selectedWallet?.currencyId.toUpperCase()}",
          style: AppTextStyles.content2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: AppTextStyles.content2.copyWith(
        color: AppColors.tertiary,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    Widget? suffixIcon,
    final String? Function(String?)? validator,
    int decimalLimit = 8,
  }) {
    final vm = context.read<EarnViewModel>();
    final maxBalance =
        double.tryParse(vm.selectedWallet?.balance.toString() ?? '0') ?? 0.0;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final text = value.text;
        double entered = double.tryParse(text) ?? 0.0;
        if (entered > maxBalance && text.isNotEmpty) {
          String newText = text.substring(0, text.length - 1);
          controller.text = newText;
          controller.selection = TextSelection.fromPosition(
            TextPosition(offset: newText.length),
          );
          entered = double.tryParse(newText) ?? 0.0;
        }
        widget.onInputValueChanged?.call(entered);
        return TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.content2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
          validator: validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [FormatterUtils.decimalInputFormatter(decimalLimit)],
          decoration: InputDecoration(
            errorStyle: TextStyle(
              color: AppColors.error,
              fontWeight: FontWeight.w500,
            ),
            errorBorder: _buildBorder().copyWith(
              borderSide: BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: _buildBorder().copyWith(
              borderSide: BorderSide(color: AppColors.error),
            ),
            isDense: true,
            errorMaxLines: 2,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSize.size15.w,
              vertical: AppSize.size10.h,
            ),
            hintText: hintText,
            hintStyle: AppTextStyles.content2.copyWith(
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w400,
            ),
            suffixIcon: suffixIcon,
            enabledBorder: _buildBorder(),
            focusedBorder: _buildBorder(),
          ),
        );
      },
    );
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.size4.r),
      borderSide: BorderSide(color: AppColors.stock),
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

import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_fee_response_model.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/enums.dart';

class WithdrawBottomSheet extends StatelessWidget {
  final bool isEnableWithdrawButton;

  const WithdrawBottomSheet({super.key, this.isEnableWithdrawButton = false});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<WithdrawViewModel>();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: AppSize.size20.w,
        right: AppSize.size20.w,
        top: AppSize.size10.h,
        bottom: AppSize.size30.h,
      ),
      decoration: BoxDecoration(color: AppColors.stock),
      child: Selector<WithdrawViewModel, Fee?>(
        selector: (_, viewModel) => viewModel.selectedFee,
        builder: (context, value, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRow(
                context.appLocaleLanguage.convertUSD,
                "${vm.amountController.text.isNotEmpty && vm.coinSelected?.price != null ? (FormatterUtils.formatNumber(value: vm.convertUsdToUsdt(), decimalDigits: 6)) : '--'} ${context.appLocaleLanguage.usdt.toUpperCase()}",
              ),
              SizedBox(height: AppSize.size18.h),
              _buildRow(
                context.appLocaleLanguage.withdrawFee,
                _formatFeeAmount(vm.selectedFee),
              ),
              SizedBox(height: AppSize.size18.h),
              _buildRow(
                context.appLocaleLanguage.receivedAmount,
                vm.amountController.text.isNotEmpty
                    ? '${vm.calculateReceivedAmount().toStringAsFixed(6)} ${vm.networkSelected!.id.toUpperCase()}'
                    : '--',
              ),
              SizedBox(height: AppSize.size40.h),
              SizedBox(
                child: AppButton(
                  isEnabled: isEnableWithdrawButton,
                  fontWeight: FontWeight.w700,
                  text: context.appLocaleLanguage.assetsButtonWithdraw,
                  onPressed: () {
                    executeWithdraw(vm, context);
                  },
                  borderRadius: AppSize.size4.r,
                  size: AppButtonSizeEnum.medium,
                ),
              ),
            ],
          );
        },
      ),
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

  Future<void> executeWithdraw(
    WithdrawViewModel vm,
    BuildContext context,
  ) async {
    await vm.executeWithdraw();
    if (!context.mounted) return;
    if (vm.errorMessage != null) {
      context.showErrorSnackBar(vm.errorMessage!);
      vm.clearError();
    } else {
      context.showSuccessSnackBar('Withdraw successful');
    }
  }

  String _formatFeeAmount(Fee? selectedFee) {
    if (selectedFee == null) return '--';

    final precision = selectedFee.feeCurrencyInfo.precision ?? 8;
    return "${selectedFee.feeAmount.truncateToDecimalPlaces(precision).toStringAsFixed(precision)} ${selectedFee.feeCurrency.toUpperCase()}";
  }
}

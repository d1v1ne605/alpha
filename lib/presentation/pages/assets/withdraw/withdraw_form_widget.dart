import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/data/models/asset/withdraw/withdraw_fee_response_model.dart';
import 'package:alpha/presentation/view_models/asset/withdraw/withdraw_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

class WithdrawFormWidget extends StatefulWidget {
  final WithdrawFeeResponseModel feeOptions;
  final double availableBalance;
  final ValueChanged<Fee>? onFeeChanged;
  final ValueChanged<double>? onInputValueChanged;

  const WithdrawFormWidget({
    super.key,
    required this.feeOptions,
    required this.availableBalance,
    this.onFeeChanged,
    required this.onInputValueChanged,
  });

  @override
  State<WithdrawFormWidget> createState() => _WithdrawFormWidgetState();
}

class _WithdrawFormWidgetState extends State<WithdrawFormWidget> {
  bool isSelected = false;

  WithdrawViewModel? _withdrawViewModel;

  WithdrawViewModel get vm {
    return _withdrawViewModel ??= context.read<WithdrawViewModel>();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (vm.selectedFee == null &&
        widget.feeOptions.withdrawFeeData.fees.isNotEmpty) {
      vm.selectedFee = widget.feeOptions.withdrawFeeData.fees.first;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(WithdrawFormWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.feeOptions != widget.feeOptions &&
        oldWidget.feeOptions.withdrawFeeData.currencyId !=
            widget.feeOptions.withdrawFeeData.currencyId) {
      vm.selectedFee = widget.feeOptions.withdrawFeeData.fees.isNotEmpty
          ? widget.feeOptions.withdrawFeeData.fees.first
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: vm.executeWithdrawAddressFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeeSelection(),
          SizedBox(height: AppSize.size5.h),
          _buildAmountInput(),
          SizedBox(height: AppSize.size15.h),
          _buildCodeInput(),
        ],
      ),
    );
  }

  Widget _buildFeeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context.appLocaleLanguage.feeOption),
        if (context.select((WithdrawViewModel vm) => vm.selectedFee) !=
            null) ...[
          SizedBox(height: AppSize.size8.h),
          ...widget.feeOptions.withdrawFeeData.fees.map(
            (fee) => _buildFeeOption(fee),
          ),
        ],
      ],
    );
  }

  Widget _buildFeeOption(Fee fee) {
    isSelected = vm.selectedFee?.id == fee.id;
    final precision = fee.feeCurrencyInfo.precision ?? 8;
    return GestureDetector(
      onTap: () => widget.onFeeChanged?.call(fee),
      child: Container(
        margin: EdgeInsets.only(bottom: AppSize.size5.h),
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.size15.w,
          vertical: AppSize.size5.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.transparent,
          ),
          borderRadius: BorderRadius.circular(AppSize.size4.r),
        ),
        child: Row(
          children: [
            SvgPicture.asset(
              isSelected ? AppSvg.checkComlete : AppSvg.checkRadio,
            ),
            SizedBox(width: AppSize.size10.w),
            Image.network(
              fee.feeCurrencyInfo.iconUrl ?? '',
              width: AppSize.size24.w,
              height: AppSize.size24.h,
              fit: BoxFit.cover,
            ),
            SizedBox(width: AppSize.size9.w),
            Text(
              "${fee.feeAmount.truncateToDecimalPlaces(precision).toStringAsFixed(precision)} ${fee.feeCurrency.toUpperCase()}",
              style: AppTextStyles.content3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: AppSize.size9.w),
            Text(
              fee.feeCurrencyInfo.name ?? '',
              style: AppTextStyles.content3.copyWith(
                color: AppColors.subtitleText,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context.appLocaleLanguage.orderTableAmount),
        SizedBox(height: AppSize.size5.h),
        _buildTextField(
          controller: vm.amountController,
          hintText:
              '${context.appLocaleLanguage.minWithdraw} ${FormatterUtils.formatNumber(value: double.tryParse(vm.calculateMinWithdrawAmount().toString()) ?? 0.0)} ${vm.networkSelected!.id.toUpperCase()}',
          keyboardType: TextInputType.number,
          suffixIcon: _buildAmountSuffix(),
          validator: (value) => vm.validateAmount(),
          decimalLimit: vm.coinSelected?.precision ?? 8,
        ),
        SizedBox(height: AppSize.size5.h),
        _buildBalanceRow(vm.coinSelected?.precision ?? 8),
      ],
    );
  }

  Widget _buildAmountSuffix() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          vm.networkSelected!.id.toUpperCase(),
          style: AppTextStyles.content2.copyWith(
            color: AppColors.tertiary,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () => vm.amountController.text = widget.availableBalance
              .toStringAsFixed(8),
          child: Text(
            context.appLocaleLanguage.max,
            style: AppTextStyles.content2.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceRow(int precision) {
    return Row(
      children: [
        Text(
          context.appLocaleLanguage.availableBalance,
          style: AppTextStyles.content2.copyWith(
            color: AppColors.textTertiary,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          " ${widget.availableBalance.truncateToDecimalPlaces(precision).toStringAsFixed(precision)}",
          style: AppTextStyles.content2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildCodeInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(context.appLocaleLanguage.twoFACode),
        SizedBox(height: AppSize.size5.h),
        _buildTextField(
          controller: vm.otpController,
          hintText: context.appLocaleLanguage.twoFACode,
          keyboardType: TextInputType.number,
          validator: (value) => vm.validateOtp(),
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
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: AppTextStyles.content2.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w500,
      ),
      onChanged: (value) {
        widget.onInputValueChanged?.call(
          value.isEmpty ? 0.0 : double.tryParse(value) ?? 0.0,
        );
      },
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
  }

  OutlineInputBorder _buildBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppSize.size4.r),
      borderSide: BorderSide(color: AppColors.stock),
    );
  }
}

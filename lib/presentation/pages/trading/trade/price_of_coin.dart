import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_svg.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/decimal_limit_formatter.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class PriceOfCoin extends StatefulWidget {
  const PriceOfCoin({
    super.key,
    required this.priceOfCoin,
    required this.approximatelyPrice,
    required this.updateSliderPercent,
    required this.tradeViewModel,
    required this.pricePrecision,
  });

  final double approximatelyPrice;
  final int pricePrecision;
  final double priceOfCoin;
  final Function() updateSliderPercent;
  final TradeViewModel tradeViewModel;

  @override
  State<PriceOfCoin> createState() => _PriceOfCoinState();
}

class _PriceOfCoinState extends State<PriceOfCoin> {
  final FocusNode _focusNode = FocusNode();

  late final ValueNotifier<bool> _isFocusedNotifier = ValueNotifier<bool>(
    false,
  );

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      _isFocusedNotifier.value = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.tradeViewModel;
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: _isFocusedNotifier,
          builder: (context, isFocused, child) => Container(
            padding: EdgeInsets.all(AppSpacing.space7.h),
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(AppSize.size4.r),
              border: Border.all(
                color: isFocused ? AppColors.primary : AppColors.divider,
                width: AppSize.size2.w,
              ),
            ),
            child: AppTextField(
              inputFormatter: [
                FormatterUtils.decimalInputFormatter(vm.pricePrecision),
                DecimalLimitFormatter(vm.pricePrecision),
              ],
              onChanged: (value) {
                vm.updateOrder(
                  value: value,
                  type: UpdateOrderTradeEnum.priceOfCoin,
                );
                widget.updateSliderPercent();
              },
              controller: vm.priceOfCoinController,
              focusNode: _focusNode,
              labelText: context.appLocaleLanguage.price,
              labelTextStyle: AppTextStyles.content1.copyWith(
                fontSize: AppSize.size14.sp,
                color: AppColors.textTertiary,
              ),
              isDense: true,
              contentPadding: EdgeInsets.all(AppSpacing.space0),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              keyboardType: TextInputType.number,
              textInputStyle: AppTextStyles.content2.copyWith(
                fontWeight: FontWeight.w600,
              ),
              suffixText: vm.currentCoin?.quote_unit.toUpperCase(),
              suffixTextStyle: AppTextStyles.content2.copyWith(
                fontWeight: FontWeight.w500,
              ),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              fillColor: AppColors.divider,
            ),
          ),
        ),
        SizedBox(height: AppSpacing.space5.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              AppSvg.equalApproximately,
              width: AppSize.size10,
              height: AppSize.size10,
            ),
            Text(
              '${FormatterUtils.formatTokenValue(value: widget.approximatelyPrice.truncateToDecimalPlaces(vm.pricePrecision))} ${context.appLocaleLanguage.usd}',
              style: AppTextStyles.content1.copyWith(
                fontSize: AppSize.size10.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

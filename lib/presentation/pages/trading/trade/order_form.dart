import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/common_bottom_sheet.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/utils/mixins.dart';
import 'package:alpha/core/widgets/app_text_field.dart';
import 'package:alpha/data/models/home_market/coin_model/coin_model.dart';
import 'package:alpha/presentation/pages/trading/trade/bottom_sheet_limit_market.dart';
import 'package:alpha/presentation/pages/trading/trade/custom_slider.dart';
import 'package:alpha/presentation/pages/trading/trade/group_buy_sell_btn.dart';
import 'package:alpha/presentation/pages/trading/trade/price_of_coin.dart';
import 'package:alpha/presentation/pages/trading/trade/your_available.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderForm extends StatefulWidget {
  final CoinModel? coin;

  const OrderForm({super.key, this.coin});

  @override
  State<OrderForm> createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> with Trade {
  late String baseUnit;
  late String quoteUnit;

  TradeViewModel? _tradeViewModel;

  TradeViewModel get vm {
    return _tradeViewModel ??= Provider.of<TradeViewModel>(
      context,
      listen: false,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm.priceOfCoin = double.parse(widget.coin?.lastPrice ?? '0');
    vm.loadBalances();

    final coinUnits = getCoinAndQuoteUnitByCoinName(widget.coin?.name ?? '');
    baseUnit = coinUnits[AppStorageKey.keyBaseCoinUnit]!;
    quoteUnit = coinUnits[AppStorageKey.keyQuoteCoinUnit]!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.space20.w,
        bottom: keyboardHeight > 0 ? keyboardHeight * 0.1 : 0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder(
            valueListenable: vm.orderFormType,
            builder: (context, value, child) {
              return BuyAndSellButton();
            },
          ),
          SizedBox(height: AppSpacing.space24.h),
          ValueListenableBuilder(
            valueListenable: vm.orderFormType,
            builder: (context, value, child) {
              return YourAvailable(
                available: vm.orderFormType.value == OrderTypeEnum.buy
                    ? context.select(
                        (TradeViewModel viewModel) =>
                            viewModel.availableQuoteBalance,
                      )
                    : context.select(
                        (TradeViewModel viewModel) => viewModel.availableCoin,
                      ),
                type: vm.orderFormType.value ?? OrderTypeEnum.buy,
                quoteUnit: quoteUnit,
                coinUnit: baseUnit,
              );
            },
          ),
          SizedBox(height: AppSpacing.space10.h),
          GestureDetector(
            onTap: () {
              final selected = context.read<TradeViewModel>().selectedOrderType;
              CommonBottomSheet.show(
                context: context,
                child: BottomSheetLimitMarket(
                  selectedValue: selected,
                  options: vm.options,
                  onSelected: (value) {
                    context.read<TradeViewModel>().setSelectedOrderType(value);
                  },
                ),
              );
            },
            child: Container(
              height: AppSize.size36,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppSize.size6.r),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.help_outline,
                      size: AppSize.size14,
                      color: AppColors.textTertiary,
                    ),
                    const SizedBox(width: AppSpacing.space8),
                    Expanded(
                      child: Center(
                        child: Selector<TradeViewModel, String>(
                          selector: (context, vm) => vm.selectedOrderType,
                          builder: (context, value, child) {
                            return Text(
                              value,
                              style: AppTextStyles.content2.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: AppColors.textTertiary,
                      size: AppSize.size14,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.space10.h),
          Selector<TradeViewModel, bool>(
            selector: (_, vm) => vm.isLimitOrder,
            builder: (context, isLimit, child) {
              if (!isLimit) return const SizedBox.shrink();
              return Selector<TradeViewModel, double>(
                selector: (context, vm) => vm.approximatelyUSDPriceOfCoin,
                builder: (context, approximatelyUSDPriceOfCoin, child) =>
                    PriceOfCoin(
                      tradeViewModel: vm,
                      priceOfCoin: vm.priceOfCoin,
                      pricePrecision: vm.pricePrecision,
                      approximatelyPrice: approximatelyUSDPriceOfCoin,
                      updateSliderPercent: () {
                        vm.sliderPercent = 0.0;
                      },
                    ),
              );
            },
          ),
          Selector<TradeViewModel, bool>(
            selector: (_, vm) => vm.isLimitOrder,
            builder: (context, isLimit, child) {
              return isLimit
                  ? SizedBox(height: AppSpacing.space15.h)
                  : const SizedBox.shrink();
            },
          ),

          AppTextField(
            inputFormatter: [
              FormatterUtils.decimalInputFormatter(vm.quantityPrecision),
            ],
            hintText: context.appLocaleLanguage.quantity,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppSize.size4.r),
              borderSide: BorderSide(
                color: AppColors.divider,
                width: AppSize.size1.w,
              ),
            ),
            isDense: true,
            keyboardType: TextInputType.number,
            textInputStyle: AppTextStyles.content2,
            suffixText: baseUnit,
            suffixTextStyle: AppTextStyles.content2.copyWith(
              fontWeight: FontWeight.w500,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            fillColor: AppColors.divider,
            onChanged: (value) {
              vm.updateOrder(value: value, type: UpdateOrderTradeEnum.quantity);
              vm.sliderPercent = 0.0;
            },
            controller: vm.quantityController,
          ),

          SizedBox(height: AppSpacing.space23.h),

          Selector<TradeViewModel, double>(
            selector: (context, viewModel) => viewModel.sliderPercent,
            builder: (context, sliderPercent, child) {
              return CustomSlider(
                onChanged: (value) {
                  vm.updateOrder(
                    value: (value).toString(),
                    type: UpdateOrderTradeEnum.slider,
                  );
                },
                initialValue: sliderPercent,
              );
            },
          ),

          SizedBox(height: AppSpacing.space10.h),

          Selector<TradeViewModel, bool>(
            selector: (_, vm) => vm.isLimitOrder,
            builder: (context, isLimit, child) {
              return AppTextField(
                readOnly: !isLimit,
                inputFormatter: [
                  FormatterUtils.decimalInputFormatter(vm.orderValuePrecision),
                ],
                hintText: context.appLocaleLanguage.orderValue,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSize.size4.r),
                  borderSide: BorderSide(
                    color: AppColors.divider,
                    width: AppSize.size1.w,
                  ),
                ),
                keyboardType: TextInputType.number,
                textInputStyle: AppTextStyles.content2,
                suffixText: quoteUnit,
                suffixTextStyle: AppTextStyles.content2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                fillColor: AppColors.divider,
                isDense: true,
                onChanged: (value) {
                  if (isLimit) {
                    vm.updateOrder(
                      value: value,
                      type: UpdateOrderTradeEnum.orderValue,
                    );
                    vm.sliderPercent = 0.0;
                  }
                },
                controller: vm.orderValueController,
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_local_key.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/core/widgets/custom_table_order.dart';
import 'package:alpha/core/widgets/order_data_row.dart';
import 'package:alpha/data/models/home_market/coin_model/transaction_interface.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class RecentTransactionChart extends StatelessWidget {
  final TabController? tabController;
  final double height;
  final List<ITransaction> transactions;

  const RecentTransactionChart({
    Key? key,
    this.tabController,
    required this.transactions,
    this.height = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height * height;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppSpacing.space15.h),
          child: CustomTableOrder(
            isRecentAmount: true,
            orderNameHeader: context.appLocaleLanguage.time,
            orderPriceHeader: context.appLocaleLanguage.price,
            orderAmountHeader: context.appLocaleLanguage.amount,
            flexNameHeader: 17,
            flexPriceHeader: 10,
            flexAmountHeader: 10,
            flexActionButton: 0,
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              left: AppSpacing.space20.w,
              right: AppSpacing.space20.w,
            ),
            height: mediaQueryHeight,
            child: transactions.isEmpty
                ? CustomNoData()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final order = transactions[index];
                      var timestamp = FormatterUtils.convertIsoToTimestamp(
                        order.createdAt,
                      );

                      final double priceDouble = parseToDouble(order.price);
                      final double amountDouble = parseToDouble(order.amount);
                      final formattedDate =
                          FormatterUtils.formatFullDateTimeFromTimestamp(
                            timestamp,
                          );
                      return OrderDataRow(
                        isRecentAmount: true,
                        flexActionButton: 0,
                        flexFilledCell: 0,
                        flexName: 17,
                        flexPrice: 10,
                        flexAmount: 10,
                        orderPrice: FormatterUtils.formatNumber(
                          value: priceDouble,
                          decimalDigits: context
                              .read<TradeViewModel>()
                              .pricePrecision,
                        ),
                        color: order.takerType == AppLocalKey.taker_type
                            ? AppColors.green
                            : AppColors.red,
                        amount: FormatterUtils.formatNumber(
                          value: amountDouble,
                          decimalDigits: context
                              .read<TradeViewModel>()
                              .quantityPrecision,
                        ),
                        customNameWidget: Text(
                          formattedDate,
                          style: AppTextStyles.smallTextButton.copyWith(
                            color: AppColors.white,
                          ),
                        ),
                        dataId: order.id.toString(),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  double parseToDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }
}

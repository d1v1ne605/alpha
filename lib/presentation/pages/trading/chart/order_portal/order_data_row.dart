import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_data_col.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDataRow extends StatelessWidget {
  final dynamic data;
  final OrderPortalType type;
  final int flexName;
  final int flexPrice;
  final int flexAmount;

  const OrderDataRow({
    Key? key,
    required this.type,
    required this.data,
    required this.flexName,
    required this.flexPrice,
    required this.flexAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case OrderPortalType.order:
        return Row(
          spacing: AppSpacing.space10.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: flexName,
              child: OrderDataCol(
                type: context.appLocaleLanguage.type,
                value: data.ordType.toString().toCapitalized(),
              ),
            ),

            Expanded(
              flex: flexPrice,
              child: OrderDataCol(
                type: context.appLocaleLanguage.totalValue,
                value: FormatterUtils.formatTokenValue(
                  value: double.parse(data.price).truncateToDecimalPlaces(
                    double.parse(data.price).currentFractionalDigits,
                  ),
                  truncateZeroDecimal: false,
                ),
              ),
            ),
            Expanded(
              flex: flexAmount,
              child: OrderDataCol(
                type: context.appLocaleLanguage.orderTablePrice,
                value: FormatterUtils.formatTokenValue(
                  value: double.parse(data.originVolume)
                      .truncateToDecimalPlaces(
                        double.parse(data.originVolume).currentFractionalDigits,
                      ),
                  truncateZeroDecimal: false,
                ),
              ),
            ),
          ],
        );
      case OrderPortalType.orderHistory:
        return Row(
          spacing: AppSpacing.space10.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: flexName,
              child: OrderDataCol(
                type: context.appLocaleLanguage.type,
                value: data.ordType.toString().toCapitalized(),
              ),
            ),

            Expanded(
              flex: flexPrice,
              child: OrderDataCol(
                type: context.appLocaleLanguage.orderTablePrice,
                value: FormatterUtils.formatTokenValue(
                  value: double.parse(data.price ?? data.avgPrice)
                      .truncateToDecimalPlaces(
                        double.parse(
                          data.price ?? data.avgPrice,
                        ).currentFractionalDigits,
                      ),
                  truncateZeroDecimal: false,
                ),
              ),
            ),
            Expanded(
              flex: flexAmount,
              child: OrderDataCol(
                type: context.appLocaleLanguage.executed,
                value: FormatterUtils.formatTokenValue(
                  value: double.parse(data.executedVolume ?? '0')
                      .truncateToDecimalPlaces(
                        double.parse(
                          data.executedVolume ?? '0',
                        ).currentFractionalDigits,
                      ),
                  truncateZeroDecimal: false,
                ),
              ),
            ),
          ],
        );
      default:
        return Row(
          spacing: AppSpacing.space10.w,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: flexName,
              child: OrderDataCol(
                type: context.appLocaleLanguage.price,
                value: FormatterUtils.formatTokenValue(
                  value: double.parse(data.price).truncateToDecimalPlaces(
                    double.parse(data.price).currentFractionalDigits,
                  ),
                  truncateZeroDecimal: false,
                ),
              ),
            ),

            Expanded(
              flex: flexPrice,
              child: OrderDataCol(
                type: context.appLocaleLanguage.amount,
                value: FormatterUtils.formatTokenValue(
                  value: double.parse(data.amount).truncateToDecimalPlaces(
                    double.parse(data.amount).currentFractionalDigits,
                  ),
                  truncateZeroDecimal: false,
                ),
              ),
            ),
            Expanded(
              flex: flexAmount,
              child: OrderDataCol(
                type: context.appLocaleLanguage.total,
                value: FormatterUtils.formatTokenValue(
                  value: double.parse(data.total).truncateToDecimalPlaces(
                    double.parse(data.total).currentFractionalDigits,
                  ),
                  truncateZeroDecimal: false,
                ),
              ),
            ),
          ],
        );
    }
  }
}

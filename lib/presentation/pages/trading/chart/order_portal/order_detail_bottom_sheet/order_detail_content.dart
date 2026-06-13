import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/utils/get_data_order.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_detail_bottom_sheet/order_detail_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailContent extends StatelessWidget {
  final dynamic data;
  final String coinName;
  final OrderPortalType type;

  const OrderDetailContent({
    super.key,
    required this.data,
    required this.coinName,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final price = data.price ?? data.avgPrice;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.space20).r,
      child: Column(
        spacing: AppSpacing.space20.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              width: AppSize.size68.w,
              height: AppSize.size2.h,
              decoration: BoxDecoration(
                color: AppColors.textTertiary,
                borderRadius: BorderRadius.circular(AppSpacing.space2.r),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              coinName,
              style: AppTextStyles.content5.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _buildOrderDetails(context, price),
        ],
      ),
    );
  }

  Widget _buildOrderDetails(BuildContext context, String price) {
    switch (type) {
      case OrderPortalType.order:
        return _buildOrderTypeDetails(context, price);
      case OrderPortalType.orderHistory:
        return _buildOrderHistoryDetails(context, price);
      default:
        return _buildTradeHistoryDetails(context, price);
    }
  }

  Widget _buildOrderTypeDetails(BuildContext context, String price) {
    return Column(
      spacing: AppSpacing.space15.h,
      children: [
        OrderDetailRow(
          label: context.appLocaleLanguage.orderId,
          value: data.id.toString(),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.type,
          value: data.ordType.toString().toCapitalized(),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.side,
          value: data.side.toString().toCapitalized(),
          color: data.side.toString().getStatusColor(context),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.totalVolume,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(data.originVolume).truncateToDecimalPlaces(
              double.parse(data.originVolume).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.orderTablePrice,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(price).truncateToDecimalPlaces(
              double.parse(price).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.executeStatus,
          value: OrderHelper.getOrderExecuted(data.state.toString(), context),
        ),
      ],
    );
  }

  Widget _buildOrderHistoryDetails(BuildContext context, String price) {
    return Column(
      spacing: AppSpacing.space15.h,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocaleLanguage.executeStatus,
              style: AppTextStyles.body.copyWith(
                color: AppColors.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.space4.h,
                horizontal: AppSpacing.space8.w,
              ),
              decoration: BoxDecoration(
                color: data.state.toString().getStatusBgColor(context),
                borderRadius: BorderRadius.circular(AppSize.size4.r),
              ),
              child: Text(
                OrderHelper.getOrderExecuted(data.state.toString(), context),
                style: AppTextStyles.body.copyWith(
                  color: data.state.toString().getStatusColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.orderId,
          value: data.id.toString(),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.type,
          value: (data.ordType as String).toCapitalized(),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.side,
          value: data.side.toString().toCapitalized(),
          color: data.side.toString().getStatusColor(context),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.orderTablePrice,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(price).truncateToDecimalPlaces(
              double.parse(price).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.amount,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(data.originVolume).truncateToDecimalPlaces(
              double.parse(data.originVolume).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.executed,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(data.executedVolume).truncateToDecimalPlaces(
              double.parse(data.executedVolume).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.remaining,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(data.remainingVolume).truncateToDecimalPlaces(
              double.parse(data.remainingVolume).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.costRemaining,
          value: FormatterUtils.formatTokenValue(
            value: (double.parse(data.remainingVolume) * double.parse(price))
                .truncateToDecimalPlaces(
                  (double.parse(data.remainingVolume) * double.parse(price))
                      .currentFractionalDigits,
                ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.dateTime,
          value: data.createdAt.toString(),
        ),
      ],
    );
  }

  Widget _buildTradeHistoryDetails(BuildContext context, String price) {
    return Column(
      spacing: AppSpacing.space15.h,
      children: [
        OrderDetailRow(
          label: context.appLocaleLanguage.side,
          value: data.side.toString().toCapitalized(),
          color: data.side.toString().getStatusColor(context),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.price,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(price).truncateToDecimalPlaces(
              double.parse(price).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.amount,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(data.amount).truncateToDecimalPlaces(
              double.parse(data.amount).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.total,
          value: FormatterUtils.formatTokenValue(
            value: double.parse(data.total).truncateToDecimalPlaces(
              double.parse(data.total).currentFractionalDigits,
            ),
            truncateZeroDecimal: false,
          ),
        ),
        OrderDetailRow(
          label: context.appLocaleLanguage.dateTime,
          value: data.createdAt,
        ),
      ],
    );
  }
}

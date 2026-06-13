import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_data_action.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_data_row.dart';
import 'package:alpha/presentation/view_models/trading/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDataListItem extends StatelessWidget {
  final dynamic data;
  final OrderViewModel vm;
  final int flexName;
  final int flexPrice;
  final int flexAmount;
  final OrderPortalType type;
  final BuildContext parentContext;

  const OrderDataListItem({
    super.key,
    required this.data,
    required this.vm,
    required this.type,
    required this.parentContext,
    this.flexName = 10,
    this.flexPrice = 13,
    this.flexAmount = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.space11.h),
      child: Padding(
        padding: EdgeInsets.only(
          top: AppSpacing.space3.h,
          bottom: AppSpacing.space3.h,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppSpacing.space10.h,
            horizontal: AppSpacing.space15.w,
          ),
          decoration: BoxDecoration(
            color: AppColors.transparent,
            borderRadius: BorderRadius.circular(AppSize.size4.r),
            border: Border.all(
              color: AppColors.borderCard,
              width: AppSize.size1.w,
            ),
          ),
          child: Row(
            spacing: AppSpacing.space15.w,
            children: [
              Expanded(
                child: Column(
                  spacing: AppSpacing.space10.w,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 20,
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: vm.getCoinName(data),
                                  style: AppTextStyles.content4.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                TextSpan(
                                  text: '  ',
                                  style: AppTextStyles.content4,
                                ),
                                TextSpan(
                                  text: data.side.toString().toCapitalized(),
                                  style: AppTextStyles.content2.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: data.side.toString().getStatusColor(
                                      context,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(flex: flexPrice, child: SizedBox()),
                        OrderDataAction(
                          type: type,
                          flexAmount: flexAmount,
                          state: type != OrderPortalType.tradeHistory
                              ? data.state
                              : null,
                          onTap: (context) async =>
                              await handleDeleteOrder(context),
                        ),
                      ],
                    ),
                    OrderDataRow(
                      type: type,
                      data: data,
                      flexName: type == OrderPortalType.tradeHistory
                          ? 13
                          : flexName,
                      flexPrice: type == OrderPortalType.tradeHistory
                          ? 10
                          : flexPrice,
                      flexAmount: type == OrderPortalType.tradeHistory
                          ? 10
                          : flexAmount,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textFourth),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> handleDeleteOrder(BuildContext context) async {
    try {
      await vm.deleteOrderById(data.id.toString());
      if (!context.mounted) return;
      context.showSuccessSnackBar(
        context.appLocaleLanguage.deleteStatusSuccess,
      );
    } catch (e) {
      context.showErrorSnackBar(context.appLocaleLanguage.deleteStatusFailed);
    }
  }
}

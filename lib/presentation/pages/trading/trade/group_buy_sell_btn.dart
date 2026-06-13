import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/view_models/trading/trade_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class BuyAndSellButton extends StatelessWidget {
  const BuyAndSellButton({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<TradeViewModel>();
    return Row(
      children: [
        Expanded(
          child: AppButton(
            text: context.appLocaleLanguage.buy,
            fontWeight: FontWeight.w500,
            onPressed: () {
              vm.changeOrderFormType(OrderTypeEnum.buy);
            },
            backgroundColor: vm.orderFormType.value == OrderTypeEnum.buy
                ? AppColors.green
                : AppColors.divider,
            padding: EdgeInsets.symmetric(vertical: AppSpacing.space6.h),
          ),
        ),
        SizedBox(width: AppSpacing.space8.w),
        Expanded(
          child: AppButton(
            text: context.appLocaleLanguage.sell,
            fontWeight: FontWeight.w500,
            onPressed: () {
              vm.changeOrderFormType(OrderTypeEnum.sell);
            },
            backgroundColor: vm.orderFormType.value == OrderTypeEnum.sell
                ? AppColors.red
                : AppColors.divider,
            padding: EdgeInsets.symmetric(vertical: AppSpacing.space6.h),
          ),
        ),
      ],
    );
  }
}

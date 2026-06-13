import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/get_data_order.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDataAction extends StatelessWidget {
  final OrderPortalType type;
  final int flexAmount;
  final void Function(BuildContext context)? onTap;
  final String? state;

  const OrderDataAction({
    super.key,
    required this.type,
    required this.flexAmount,
    this.onTap,
    this.state,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case OrderPortalType.order:
        return Expanded(
          flex: flexAmount,
          child: GestureDetector(
            onTap: () {
              if (onTap != null) onTap!(context);
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space10.w,
                vertical: AppSpacing.space3.h,
              ),
              decoration: BoxDecoration(
                color: AppColors.textRedOnOrderBook,
                borderRadius: BorderRadius.circular(AppSize.size4.r),
                border: Border.all(
                  color: AppColors.borderCard,
                  width: AppSize.size1.w,
                ),
              ),
              child: Center(
                child: Text(
                  context.appLocaleLanguage.delete,
                  style: AppTextStyles.content2.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      case OrderPortalType.orderHistory:
        return Expanded(
          flex: flexAmount,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.space3.h,
              horizontal: AppSpacing.space10.w,
            ),
            decoration: BoxDecoration(
              color: state?.getStatusBgColor(context),
              borderRadius: BorderRadius.circular(AppSize.size4.r),
            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  OrderHelper.getOrderExecuted(state, context),
                  style: AppTextStyles.body.copyWith(
                    color: state?.getStatusColor(context),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      default:
        return SizedBox();
    }
  }
}

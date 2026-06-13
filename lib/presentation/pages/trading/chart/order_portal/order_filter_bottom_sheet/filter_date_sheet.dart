import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/pages/trading/chart/order_portal/order_filter_bottom_sheet/show_date_picker.dart';
import 'package:alpha/presentation/view_models/trading/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderFilterDateSheet extends StatelessWidget {
  final OrderPortalType type;

  const OrderFilterDateSheet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppStorageKey.dateFormat);
    return Consumer<OrderViewModel>(
      builder: (context, vm, child) {
        final stateManager = vm.getStateManager(type);
        return Padding(
          padding: EdgeInsets.all(AppSpacing.space20).r,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.space20).r,
                child: Text(
                  context.appLocaleLanguage.filter,
                  style: AppTextStyles.title2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showDatePickerDialog(
                        stateManager.fromDate,
                        stateManager.toDate,
                        context,
                        true,
                        (isFrom, picked) => vm.setDate(isFrom, picked, type),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space20.w,
                          vertical: AppSpacing.space14.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(AppSize.size4.r),
                          border: Border.all(
                            color: stateManager.fromDateError == true
                                ? AppColors.red
                                : AppColors.borderCard,
                            width: AppSize.size1.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.iconPrimary,
                              size: AppSize.size18.w,
                            ),
                            SizedBox(width: AppSpacing.space8.w),
                            Text(
                              stateManager.fromDate != null
                                  ? dateFormat.format(stateManager.fromDate!)
                                  : AppStorageKey.dateFormat,
                              style: AppTextStyles.content4.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space8.r,
                    ),
                    child: Text(
                      context.appLocaleLanguage.to,
                      style: AppTextStyles.content4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => showDatePickerDialog(
                        stateManager.fromDate,
                        stateManager.toDate,
                        context,
                        false,
                        (isFrom, picked) => vm.setDate(isFrom, picked, type),
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space20.w,
                          vertical: AppSpacing.space14.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(AppSize.size4.r),
                          border: Border.all(
                            color: stateManager.toDateError == true
                                ? AppColors.red
                                : AppColors.borderCard,
                            width: AppSize.size1.w,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month_outlined,
                              color: AppColors.iconPrimary,
                              size: AppSize.size18.w,
                            ),
                            SizedBox(width: AppSpacing.space8.w),
                            Text(
                              stateManager.toDate != null
                                  ? dateFormat.format(stateManager.toDate!)
                                  : AppStorageKey.dateFormat,
                              style: AppTextStyles.content4.copyWith(
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.space30.h),
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: context.appLocaleLanguage.reset,
                      fontWeight: FontWeight.w700,
                      onPressed: () {
                        vm.resetFilterData(type);
                      },
                      backgroundColor: AppColors.transparent,
                      border: BorderSide(
                        color: AppColors.primary,
                        width: AppSize.size1.w,
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppSpacing.space20.w,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSize.size28.w),
                  Expanded(
                    child: AppButton(
                      text: context.appLocaleLanguage.filter,
                      fontWeight: FontWeight.w700,
                      onPressed: vm.canFilter(type)
                          ? () => vm.filterByDate(type)
                          : null,
                      backgroundColor: vm.canFilter(type)
                          ? AppColors.primary
                          : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

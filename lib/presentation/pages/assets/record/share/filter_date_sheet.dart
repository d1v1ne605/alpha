import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/presentation/view_models/asset/record/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterDateSheet extends StatelessWidget {
  const FilterDateSheet({super.key});

  Future<void> _pickDate(
    DateTime? fromDate,
    DateTime? toDate,
    BuildContext context,
    bool isFrom,
    Function(bool, DateTime) onDateSelected,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isFrom ? (fromDate ?? now) : (toDate ?? now),
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      onDateSelected.call(isFrom, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat(AppStorageKey.dateFormat);
    return Consumer<RecordViewModel>(
      builder: (context, vm, child) {
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
                      onTap: () => _pickDate(
                        vm.fromDate,
                        vm.toDate,
                        context,
                        true,
                        vm.setDate,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space20.w,
                          vertical: AppSpacing.space10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(AppSize.size4.r),
                          border: Border.all(
                            color: vm.fromDateError
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
                              vm.fromDate != null
                                  ? dateFormat.format(vm.fromDate!)
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
                      horizontal: AppSpacing.space16.r,
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
                      onTap: () => _pickDate(
                        vm.fromDate,
                        vm.toDate,
                        context,
                        false,
                        vm.setDate,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.space20.w,
                          vertical: AppSpacing.space10.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.transparent,
                          borderRadius: BorderRadius.circular(AppSize.size4.r),
                          border: Border.all(
                            color: vm.toDateError
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
                              vm.toDate != null
                                  ? dateFormat.format(vm.toDate!)
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
                      height: AppSize.size40.h,
                      fontWeight: FontWeight.w700,
                      onPressed: () {
                        vm.resetFilter();
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
                      height: AppSize.size40.h,
                      onPressed: vm.canFilter ? vm.filterByDate : null,
                      backgroundColor: vm.canFilter
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

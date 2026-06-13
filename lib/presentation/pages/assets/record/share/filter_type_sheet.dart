import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/view_models/asset/record/record_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_storage_key.dart';

class FilterTypeSheet extends StatelessWidget {
  const FilterTypeSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordViewModel>(
      builder: (context, vm, child) {
        final Map<String?, String> options = {
          null: context.appLocaleLanguage.all.trim(),
          AppStorageKey.processings: context.appLocaleLanguage.processings
              .trim(),
          AppStorageKey.completeds: context.appLocaleLanguage.completeds.trim(),
          AppStorageKey.transferredOut: context.appLocaleLanguage.transferredOut
              .trim(),
        };

        final keys = options.keys.toList();
        final selectedIndex = keys.indexOf(vm.selectedType);
        return Padding(
          padding: EdgeInsets.all(AppSpacing.space20).r,
          child: Column(
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
                  context.appLocaleLanguage.flowType,
                  style: AppTextStyles.title2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Column(
                children: List.generate(keys.length, (index) {
                  final key = keys[index];
                  final value = options[key]!;
                  final isSelected = selectedIndex == index;

                  return ListTile(
                    onTap: () {
                      vm.filterByType(key);
                    },
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.primary)
                        : Icon(
                            Icons.radio_button_unchecked,
                            color: AppColors.tertiaryButton,
                          ),
                    title: Text(
                      value,
                      style: AppTextStyles.content4.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    leading: null,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.space16.w,
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }
}

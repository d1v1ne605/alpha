import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_storage_key.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/presentation/view_models/trading/order_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class OrderFilterPairSheet extends StatelessWidget {
  final OrderPortalType type;

  const OrderFilterPairSheet({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderViewModel>(
      builder: (context, vm, child) {
        final stateManager = vm.getStateManager(type);
        final options = vm.pairOptions;
        final selectedIndex = stateManager.selectedPair == null
            ? 0
            : options.indexWhere((opt) => opt.id == stateManager.selectedPair);
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
                  context.appLocaleLanguage.pair,
                  style: AppTextStyles.title2.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Column(
                children: List.generate(options.length, (index) {
                  final isSelected = selectedIndex == index;
                  return ListTile(
                    onTap: () {
                      vm.filter(
                        OrderFilterType.Pair,
                        options[index].id == AppStorageKey.all
                            ? null
                            : options[index].id,
                        type,
                      );
                    },
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.primary)
                        : Icon(
                            Icons.radio_button_unchecked,
                            color: AppColors.tertiaryButton,
                          ),
                    title: Text(
                      options[index].name,
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

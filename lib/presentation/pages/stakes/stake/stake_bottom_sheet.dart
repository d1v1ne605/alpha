import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/utils/format_usdt.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/app_button.dart';
import 'package:alpha/data/models/stake/stake_product_model.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/pages/stakes/stake/show_stake_success_bottom_sheet.dart';
import 'package:alpha/presentation/pages/stakes/stake/widget/striped_linear_progress_indicator.dart';
import 'package:alpha/presentation/view_models/stake/stake_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'widget/info_row_widget.dart';
import 'widget/timeline_item_widget.dart';

class StakeBottomSheet {
  static Future<void> show(
    BuildContext context, {
    required StakeViewModel vm,
  }) async {
    await AppBottomSheetWidget.show(
      context: context,
      isSingleChildScrollView: true,
      minChildSize: AppSize.size0_75,
      maxChildSize: AppSize.size0_9,
      child: ChangeNotifierProvider.value(
        value: vm,
        child: const _StakeBottomSheetContent(),
      ),
    );
  }
}

class _StakeBottomSheetContent extends StatelessWidget {
  const _StakeBottomSheetContent();

  @override
  Widget build(BuildContext context) {
    return Consumer<StakeViewModel>(
      builder: (context, vm, _) {
        if (vm.isBusy) {
          return Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.space20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.space10.h),
              const Center(child: HandleBar()),
              SizedBox(height: AppSpacing.space18.h),
              const _StakeHeader(),
              SizedBox(height: AppSpacing.space20.h),
              const _StakeOptionsTabs(),
              SizedBox(height: AppSpacing.space25.h),
              const _StakeDetailsSection(),
            ],
          ),
        );
      },
    );
  }
}

class _StakeHeader extends StatelessWidget {
  const _StakeHeader();

  @override
  Widget build(BuildContext context) {
    return Selector<StakeViewModel, String>(
      selector: (_, vm) => vm.selectedOption?.currencyId ?? "",
      builder: (context, currencyId, _) {
        return Center(
          child: Text(
            "${context.appLocaleLanguage.stake} ${currencyId.toUpperCase()}",
            style: AppTextStyles.title2.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class _StakeOptionsTabs extends StatelessWidget {
  const _StakeOptionsTabs();

  @override
  Widget build(BuildContext context) {
    return Consumer<StakeViewModel>(
      builder: (context, vm, _) {
        final currentOptions = vm.currentOptions;

        return SizedBox(
          height: AppSize.size60.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.space4.w),
            itemCount: currentOptions.length,
            separatorBuilder: (_, __) => SizedBox(width: AppSpacing.space12.w),
            itemBuilder: (context, index) {
              final option = currentOptions[index];
              final isSelected = option == vm.selectedOption;

              return GestureDetector(
                onTap: () => vm.selectOption(option),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: AppSpacing.space85.w,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSize.size4.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.stock,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${option.aprBase}%",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.content3.copyWith(
                          color: isSelected
                              ? AppColors.green
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: AppSize.size5.h),
                      Text(
                        "${option.lockDays} ${context.appLocaleLanguage.days}",
                        textAlign: TextAlign.center,
                        style: AppTextStyles.content2.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _StakeDetailsSection extends StatelessWidget {
  const _StakeDetailsSection();

  @override
  Widget build(BuildContext context) {
    return Selector<StakeViewModel, StakeProduct?>(
      selector: (_, vm) => vm.selectedOption,
      builder: (context, selectedOption, _) {
        if (selectedOption == null) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _StakeInputSection(selectedOption: selectedOption),
            _StakeAprSection(selectedOption: selectedOption),
            _StakeInfoSection(selectedOption: selectedOption),
            _StakeActionButton(selectedOption: selectedOption),
          ],
        );
      },
    );
  }
}

class _StakeInputSection extends StatelessWidget {
  final StakeProduct selectedOption;
  const _StakeInputSection({required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Consumer<StakeViewModel>(
      builder: (context, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${context.appLocaleLanguage.stake} ${selectedOption.currencyId.toUpperCase()}",
              style: AppTextStyles.content3.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSpacing.space10.h),
            Text(
              "${context.appLocaleLanguage.availableBalance}: ${FormatterUtils.formatWithDecimalsNoRound(double.tryParse(vm.availableBalance.toString()) ?? 0.0, 8)} ${selectedOption.currencyId.toUpperCase()}",
              style: AppTextStyles.content4.copyWith(
                color: AppColors.textPrimary.withOpacity(0.5),
              ),
            ),
            SizedBox(height: AppSpacing.space10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.space12.w),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderCard),
                borderRadius: BorderRadius.circular(AppSize.size4.r),
                color: AppColors.background,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: vm.amountController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.content3.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText:
                            "${context.appLocaleLanguage.min} ${selectedOption.currencyId.toUpperCase()}",
                        border: InputBorder.none,
                        hintStyle: AppTextStyles.content4.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.5),
                        ),
                      ),
                      onChanged: vm.onAmountChanged,
                    ),
                  ),
                  GestureDetector(
                    onTap: vm.stakeAll,
                    child: Text(
                      context.appLocaleLanguage.all,
                      style: AppTextStyles.content3.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.space20.h),
          ],
        );
      },
    );
  }
}

class _StakeAprSection extends StatelessWidget {
  final StakeProduct selectedOption;
  const _StakeAprSection({required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Selector<StakeViewModel, Tuple2<double, double>>(
      selector: (_, vm) =>
          Tuple2(vm.stakedAmount, vm.getProgressValue(selectedOption)),
      builder: (context, data, _) {
        final vm = context.read<StakeViewModel>();
        final progressValue = data.item2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.space16.w,
                vertical: AppSpacing.space14.h,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.size4.r),
                border: Border.all(color: AppColors.stock),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoRowWidget(
                    label: context.appLocaleLanguage.apr,
                    value: "${selectedOption.aprBase}%",
                    valueColor: AppColors.green,
                  ),
                  SizedBox(height: AppSpacing.space14.h),
                  InfoRowWidget(
                    label: context.appLocaleLanguage.estimatedReward,
                    value:
                        "${vm.estimatedRewardString} ${selectedOption.currencyId.toUpperCase()}",
                    valueColor: AppColors.textPrimary,
                  ),
                  SizedBox(height: AppSpacing.space14.h),
                  _buildProgress(context, progressValue),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.space20.h),
          ],
        );
      },
    );
  }

  Widget _buildProgress(BuildContext context, double progressValue) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            "${context.appLocaleLanguage.filledPoolSize}",
            style: AppTextStyles.content2.copyWith(color: AppColors.grey),
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: AppSize.size150.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.size3.r),
                    child: StripedLinearProgressIndicator(
                      value: progressValue,
                      height: AppSize.size10.h,
                      backgroundColor: AppColors.stock,
                      stripeColor: AppColors.primaryButton,
                      stripeColorSecondary: AppColors.indicator,
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppSpacing.space6.h),
              Text(
                "${FormatterUtils.formatWithDecimalsNoRound(selectedOption.poolFilled, 3)} / ${FormatterUtils.formatWithDecimalsNoRound(selectedOption.poolSize, 0)} ${selectedOption.currencyId.toUpperCase()}",
                style: AppTextStyles.content2.copyWith(
                  color: AppColors.tertiary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StakeInfoSection extends StatelessWidget {
  final StakeProduct selectedOption;
  const _StakeInfoSection({required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.appLocaleLanguage.moreInfo,
          style: AppTextStyles.content3.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: AppSpacing.space10.h),
        Text(
          "${context.appLocaleLanguage.stakingDuration}",
          style: AppTextStyles.content2.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: AppSpacing.space10.h),
        TimelineItemWidget(
          label: context.appLocaleLanguage.stakeDate,
          date: selectedOption.createdAt,
        ),
        TimelineItemWidget(
          label: context.appLocaleLanguage.profitDistribution,
          date: selectedOption.updatedAt,
        ),
        SizedBox(height: AppSpacing.space20.h),
      ],
    );
  }
}

class _StakeActionButton extends StatelessWidget {
  final StakeProduct selectedOption;
  const _StakeActionButton({required this.selectedOption});

  @override
  Widget build(BuildContext context) {
    return Selector<StakeViewModel, Tuple2<double, bool>>(
      selector: (_, vm) => Tuple2(vm.stakedAmount, vm.canStake),
      builder: (context, data, _) {
        final stakedAmount = data.item1;
        final canStake = data.item2;

        final isLocked = selectedOption.isLocked == 1;
        final isDisabled = isLocked || !canStake;
        final vm = context.read<StakeViewModel>();
        final estimatedRewardString = vm.estimatedRewardString;

        return AppButton(
          text: isLocked
              ? context.appLocaleLanguage.lockedProduct
              : context.appLocaleLanguage.stakeNow,
          onPressed: isDisabled
              ? null
              : () async {
                  try {
                    final response = await vm.registerStake();
                    if (response != null) {
                      context.pop();
                      await showStakeSuccessBottomSheet(
                        context,
                        stake: selectedOption,
                        stakedAmount: stakedAmount,
                        estimatedRewardString: estimatedRewardString,
                      );
                      await vm.loadStakeList();
                      context.appLocaleLanguage.stakeRegisteredSuccessfully;
                    } else {
                      context.appLocaleLanguage.registerStakeFailed;
                    }
                  } catch (e) {
                    print('error staking: $e');
                  }
                },
          textColor: isDisabled
              ? AppColors.textPrimary.withOpacity(0.5)
              : AppColors.textPrimary,
          backgroundColor: isDisabled
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.primary,
          borderColor: isDisabled
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.primary,
          size: AppButtonSizeEnum.medium,
        );
      },
    );
  }
}

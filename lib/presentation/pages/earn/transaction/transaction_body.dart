import 'package:alpha/core/constants/app_colors.dart';
import 'package:alpha/core/constants/app_size.dart';
import 'package:alpha/core/constants/app_spacing.dart';
import 'package:alpha/core/constants/app_text_styles.dart';
import 'package:alpha/core/utils/enums.dart';
import 'package:alpha/core/utils/extension.dart';
import 'package:alpha/core/widgets/app_bottom_sheet.dart';
import 'package:alpha/core/widgets/custom_no_data.dart';
import 'package:alpha/data/models/earn/transaction_earn/rewards/reward_model_earn.dart';
import 'package:alpha/data/models/earn/transaction_earn/withdraw_record/withdraw_record_earn.dart';
import 'package:alpha/presentation/pages/earn/transaction/transaction_list.dart';
import 'package:alpha/presentation/pages/profile/change_pasword/handle_bar.dart';
import 'package:alpha/presentation/view_models/earn/earn_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TransactionBody extends StatefulWidget {
  final TransactionType recordType;

  const TransactionBody({super.key, required this.recordType});

  @override
  State<TransactionBody> createState() => _TransactionBodyState();
}

class _TransactionBodyState extends State<TransactionBody>
    with AutomaticKeepAliveClientMixin {
  EarnViewModel? _earnViewModel;
  int? selectedIndex = 0;

  EarnViewModel get vm {
    return _earnViewModel ??= context.read<EarnViewModel>();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.size15.h,
        horizontal: AppSize.size20.w,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.recordType == TransactionType.reward
              ? GestureDetector(
                  onTap: () {
                    AppBottomSheetWidget.show(
                      context: context,
                      child: ChangeNotifierProvider.value(
                        value: vm,
                        child: Column(
                          children: [
                            SizedBox(height: AppSpacing.space10.h),
                            HandleBar(),
                            SizedBox(height: AppSpacing.space18.h),
                            Text(
                              context.appLocaleLanguage.selectCurrency,
                              style: AppTextStyles.title2.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Expanded(
                              child: Selector<EarnViewModel, int>(
                                selector: (_, vm) => vm.selectedIndex,
                                builder: (context, selectedIndex, _) {
                                  final vm = context.read<EarnViewModel>();
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: vm.rewardCurrencies.length + 1,
                                    itemBuilder: (context, index) {
                                      if (index == 0) {
                                        return ListTile(
                                          title: Text(
                                            context
                                                .appLocaleLanguage
                                                .allCurrencies,
                                            style: AppTextStyles.title2
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          trailing: Icon(
                                            selectedIndex == 0
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: selectedIndex == 0
                                                ? AppColors.primary
                                                : AppColors.textTertiary,
                                          ),
                                          onTap: () async {
                                            vm.selectCurrency(0);
                                          },
                                        );
                                      }

                                      final tx = vm.rewardCurrencies[index - 1];
                                      final bool isSelected =
                                          selectedIndex == index;

                                      return ListTile(
                                        leading: Image.network(
                                          tx.iconUrl,
                                          width: AppSize.size32.w,
                                          height: AppSize.size32.w,
                                        ),
                                        title: Row(
                                          children: [
                                            Text(tx.currencyId),
                                            SizedBox(width: AppSize.size10.w),
                                            Text(
                                              tx.currencyName,
                                              style: AppTextStyles.content3
                                                  .copyWith(
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        trailing: Icon(
                                          isSelected
                                              ? Icons.radio_button_checked
                                              : Icons.radio_button_off,
                                          color: isSelected
                                              ? AppColors.primary
                                              : AppColors.textTertiary,
                                        ),
                                        onTap: () => vm.selectCurrency(index),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: AppSpacing.space12.h),
                          ],
                        ),
                      ),
                      maxChildSize: AppSize.size0_6,
                      minChildSize: AppSize.size0_6,
                    );
                  },
                  child: Container(
                    height: AppSize.size40.h,
                    padding: EdgeInsets.symmetric(horizontal: AppSize.size10.r),
                    decoration: BoxDecoration(
                      color: AppColors.bgWithEarn,
                      borderRadius: BorderRadius.circular(AppSize.size4.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            context.appLocaleLanguage.selectCurrency,
                            style: AppTextStyles.content3.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColors.textTertiary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_drop_down,
                          size: AppSize.size24.r,
                          color: AppColors.textTertiary,
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
          const SizedBox(height: 10),

          Selector<
            EarnViewModel,
            ({
              bool isBusy,
              List<RewardData> rewardRecords,
              List<WithdrawRecordData> withdrawRecords,
              bool isLoadingMoreRewards,
              bool isLoadingMoreWithdraw,
            })
          >(
            selector: (_, viewModel) => (
              isBusy: viewModel.isBusy,
              rewardRecords: viewModel.filteredRewards,
              withdrawRecords: viewModel.withdrawRecords,
              isLoadingMoreRewards: viewModel.isLoadingMoreRewards,
              isLoadingMoreWithdraw: viewModel.isLoadingMoreWithdraw,
            ),
            builder: (context, data, child) {
              return Expanded(
                child: data.isBusy
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      )
                    : (widget.recordType == TransactionType.reward &&
                              data.rewardRecords.isEmpty) ||
                          (widget.recordType ==
                                  TransactionType.withdraw_records &&
                              data.withdrawRecords.isEmpty)
                    ? const CustomNoData()
                    : TransactionList(
                        type: widget.recordType,
                        records: widget.recordType == TransactionType.reward
                            ? data.rewardRecords
                            : data.withdrawRecords,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
